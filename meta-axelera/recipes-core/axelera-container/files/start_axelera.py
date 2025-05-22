#!/usr/bin/env python3
import argparse
import os
import re
import shutil
import subprocess
import sys
import time

version = '1.2.0-rc2'

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


def _run(args, cmd, check=True, capture=True):
    if args.verbose:
        print(cmd)
    p = subprocess.run(
        cmd, check=check, shell=True, capture_output=capture, universal_newlines=True
    )
    return p.stdout if check else None


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
        container = _run(args, f'docker create axelera-sdk-ubuntu-2204-arm64:{version}').strip()
        _run(args, f'docker cp {container}:/home/ubuntu/voyager-sdk .', capture=False)
        _run(args, f'docker rm {container}')
        print("Copying this script to voyager-sdk so it is available in the container")
        shutil.copy2(__file__, 'voyager-sdk/start_axelera.py')
    if set(["XDG_RUNTIME_DIR", "WAYLAND_DISPLAY"]).issubset(os.environ):
        print("Setting permissions for external weston access...")
        _run(args, 'chmod o=x ${XDG_RUNTIME_DIR}')
        _run(args, 'chmod o=rwx ${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}')
    print("Starting container...")
    _run(
        args,
        'docker run --rm  -it --privileged '
        '-v voyager-sdk:/home/ubuntu/voyager-sdk/ '
        '-v $(pwd)/shared:/home/ubuntu/shared/ '
        '-v /tmp/.X11-unix:/tmp/.X11-unix '
        '-v /dev/mali0:/dev/mali0 '
        '-v /usr/lib/libmali-hook.so.1:/usr/lib/libmali-hook.so.1 '
        '-v /usr/lib/libmali.so.1:/usr/lib/libmali.so.1 '
        '-v /etc/OpenCL:/etc/OpenCL '
        '-v /etc/ld.so.cache:/etc/ld.so.cache '
        '-v /usr/lib/libMaliOpenCL.so.1:/usr/lib/libMaliOpenCL.so.1 '
        '-v /usr/lib/gstreamer-1.0/:/opt/axelera/runtime-1.2.0-rc2-1/lib/gstreamer-1.0 '
        '-v /usr/lib/librockchip_mpp.so.1:/usr/lib/librockchip_mpp.so.1 '
        '-v /usr/lib/librga.so.2:/usr/lib/librga.so.2 '
        '-v /usr/lib/liba52.so.0:/usr/lib/liba52.so.0 '
        '-v /usr/lib/libjpeg.so.62:/usr/lib/libjpeg.so.62 '
        '-v /usr/lib/libgstvulkan-1.0.so.0:/usr/lib/libgstvulkan-1.0.so.0 '
        '-v /usr/lib/libavfilter.so.9:/usr/lib/libavfilter.so.9 '
        '-v /usr/lib/libavformat.so.60:/usr/lib/libavformat.so.60 '
        '-v /usr/lib/libvulkan.so.1:/usr/lib/libvulkan.so.1 '
        '-v /usr/lib/libavcodec.so.60:/usr/lib/libavcodec.so.60 '
        '-v /usr/lib/libavutil.so.58:/usr/lib/libavutil.so.58 '
        '-v /usr/lib/libswscale.so.7:/usr/lib/libswscale.so.7 '
        '-v /usr/lib/libswresample.so.4:/usr/lib/libswresample.so.4 '
        '--device=/dev/mali0 '
        ' -e DISPLAY=$DISPLAY '
        ' -e XDG_RUNTIME_DIR=/tmp '
        ' -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY '
        ' -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY '
        '--name=software-platform-voyager-sdk '
        '--entrypoint=/bin/bash '
        '--network=host '
        f'axelera-sdk-ubuntu-2204-arm64:{version} '
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
