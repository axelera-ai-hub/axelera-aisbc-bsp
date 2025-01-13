#!/usr/bin/env python3
import argparse
import os
import re
import shutil
import subprocess
import sys
import time

parser = argparse.ArgumentParser(description='''Axelera Firefly Metis support.''')
parser.add_argument('-v', '--verbose', action='count', default=0, help='Verbose output')
subparsers = parser.add_subparsers()


def _subcommand(func):
    name = func.__name__.replace('_', '-')
    subparser = subparsers.add_parser(
        name, help=func.__doc__.format(**globals()), formatter_class=argparse.RawTextHelpFormatter
    )
    subparser.set_defaults(func=func)
    subparser.func = func
    return subparser


def _find_device(args):
    by_id = '/dev/serial/by-id'
    device_expr = re.compile(r'usb-Axelera_AI_Metis_Alpha_PCIe_Card_[\dA-F]+-if03-port0')

    devices = sorted([x for x in os.listdir(by_id)])
    metis_ftdis = [d for d in devices if device_expr.match(d)]
    if len(metis_ftdis) == 0:
        raise RuntimeError(f"Could not find ftdi device (found {' '.join(devices)})")
    elif len(metis_ftdis) > 1 and args.index is None:
        devs = '\n'.join(f"{n: 2d}: {d}" for n, d in enumerate(devices))
        raise RuntimeError(f"Multiple ftdi devices found select one:\n{devs}")

    if args.index and args.index >= len(metis_ftdis):
        raise RuntimeError(
            f"Bad index {args.index}, only devices {' '.join(metis_ftdis)} devices available"
        )

    return f"{by_id}/{metis_ftdis[args.index or 0]}"


def _wait_for_prompt(s):
    while 1:
        line = s.readline().decode('latin1').rstrip()
        if '$' in line:
            break
        if line:
            print('(triton)', line)


def _run(args, cmd, check=True, capture=True):
    if args.verbose:
        print(cmd)
    p = subprocess.run(
        cmd, check=check, shell=True, capture_output=capture, universal_newlines=True
    )
    return p.stdout if check else None


@_subcommand
def reset(args):
    '''Reset the Metis device using the usb->serial interface.'''
    d = _find_device(args)
    for _retry in range(2):
        try:
            import serial
        except ImportError:
            if _retry == 1:
                sys.exit('Please run `pip install pyserial` to run this script')
            subprocess.run(f'{sys.executable} -m pip install pyserial', shell=True)

    with serial.Serial(d, 115200, timeout=1) as s:
        s.write('\r\n'.encode('latin1'))
        _wait_for_prompt(s)
        s.write('cold_boot 2\r\n'.encode('latin1'))
        _wait_for_prompt(s)


reset.add_argument(
    'index', nargs='?', default=None, type=int, help='Index of device if multiple devices found'
)

@_subcommand
def fan(args, fanspeed=100):
    '''Set the Fan speed'''
    print("Args = ",args)
    d = _find_device(args)
    for _retry in range(2):
        try:
            import serial
        except ImportError:
            if _retry == 1:
                sys.exit('Please run `pip install pyserial` to run this script')
            subprocess.run(f'{sys.executable} -m pip install pyserial', shell=True)

    with serial.Serial(d, 115200, timeout=1) as s:
        s.write('\r\n'.encode('latin1'))
        _wait_for_prompt(s)
        s.write('fan drive 0 50\r\n'.encode('latin1'))
        _wait_for_prompt(s)


fan.add_argument(
    'index', nargs='?', default=None, type=int, help='Index of device if multiple devices found'
)
#fan.add_argument(
#    'fanspeed', nargs='?', default=100, type=int, help='Fanspeed [0-100]'
#)

@_subcommand
def rescan_pci(args):
    '''Provoke a pci rescan.'''
    if os.path.exists(r'/sys/bus/pci/devices/0000\:01\:00.0/remove'):
        _run(
            args,
            r'sudo bash -c "echo 1 > /sys/bus/pci/devices/0000\:01\:00.0/remove"',
            check=False,
        )
    _run(args, 'sudo bash -c "echo 1 > /sys/bus/pci/rescan"')
    time.sleep(1)


@_subcommand
def start(args):
    '''Start the docker container.'''
    if not os.path.exists('voyager-sdk'):
        print("Extracting voyager-sdk from docker image")
        container = _run(args, 'docker create axelera-sdk-ubuntu-2204-arm64:1.1.0-rc2').strip()
        _run(args, f'docker cp {container}:/home/ubuntu/voyager-sdk .', capture=False)
        _run(args, f'docker rm {container}')
        print("Copying this script to voyager-sdk so it is available in the container")
        shutil.copy2(__file__, 'voyager-sdk/start_axelera.py')
    print("Starting container...")
    _run(
        args,
        'docker run --rm  -it --privileged '
        '-v voyager-sdk:/home/ubuntu/voyager-sdk/ '
        '-v /tmp/.X11-unix:/tmp/.X11-unix '
        '-v /dev/mali0:/dev/mali0 '
        '-v /usr/lib/libmali-hook.so.1:/usr/lib/libmali-hook.so.1 '
        '-v /usr/lib/libmali.so.1:/usr/lib/libmali.so.1 '
        '-v /etc/OpenCL:/etc/OpenCL '
        '-v /etc/ld.so.cache:/etc/ld.so.cache '
        '-v /usr/lib/libMaliOpenCL.so.1:/usr/lib/libMaliOpenCL.so.1 '
        '--device=/dev/mali0 '
        ' -e DISPLAY=$DISPLAY '
        '--name=software-platform-voyager-sdk '
        '--entrypoint=/bin/bash '
        '--network=host '
        'axelera-sdk-ubuntu-2204-arm64:1.1.0-rc2 '
        '-l -c "cd /home/ubuntu/voyager-sdk && . venv/bin/activate && make gst-operators && /bin/bash"',
        capture=False,
        check=False,
    )


def main(args):
    try:
        args.func(args)
        return 0
    except RuntimeError as e:
        if args.verbose:
            raise
        return str(e)
    except KeyboardInterrupt:
        return 'Interrupted'


if __name__ == '__main__':
    sys.exit(main(parser.parse_args()))
