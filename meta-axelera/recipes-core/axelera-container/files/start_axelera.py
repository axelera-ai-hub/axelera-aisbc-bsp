#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys
import time


# Custom parser to improve error messaging
class CustomArgumentParser(argparse.ArgumentParser):
    def error(self, message):
        sys.stderr.write(f"\n❌ Error: {message}\n")
        sys.stderr.write(
            "👉 Try: python3 start_axelera.py start --container-name <name> --version <tag>\n"
        )
        sys.exit(2)


parser = CustomArgumentParser(
    description="🛠️ Axelera AI - Metis Compute Board Utility\n\n",
    formatter_class=argparse.RawTextHelpFormatter,
    add_help=False,
)

CUSTOM_HELP = """
🛠️ Axelera AI - Metis Compute Board Utility
A command-line tool to manage and launch Voyager SDK containers on the Metis Compute Board.

📌 Usage:
  start_axelera.py <command> [options]

📂 Available Commands:
  start       Start a new or existing Voyager SDK container.
  rescan-pci  Perform a PCIe bus rescan (requires root privileges).

🔧 Command: start
  --container-name   Name of the docker container
  --version          Voyager SDK version tag (e.g., 1.3.3)
  Example:
    👉 python3 start_axelera.py start --container-name axelera-voyager-sdk --version 1.3.3 👈

🔧 Command: rescan-pci
  Rescan the PCIe bus to detect hardware changes. Must be run as root.
  Example:
    👉 sudo python3 start_axelera.py rescan-pci 👈

🗨️ Global Options:
  -v, --verbose      Increase output verbosity (use -vv for more)
  -h, --help         Show this help message and exit
"""

parser.add_argument("-v", "--verbose", action="count", default=0, help="Verbose output")
parser.add_argument(
    "-h", "--help", action="store_true", help="Show this help message and exit"
)
subparsers = parser.add_subparsers()


def _subcommand(func):
    name = func.__name__.replace("_", "-")
    subparser = subparsers.add_parser(
        name, help=func.__doc__, formatter_class=argparse.RawTextHelpFormatter
    )
    subparser.set_defaults(func=func)
    subparser.func = func

    if name == "start":
        subparser.add_argument(
            "--container-name", required=True, help="Name of the docker container"
        )
        subparser.add_argument(
            "--version",
            required=True,
            help="Version tag of the Voyager SDK container version to be used",
        )

    return subparser


def _run(args, cmd, check=True, capture=True):
    if args.verbose:
        print(f"[DEBUG] Running command: {cmd}")
    p = subprocess.run(
        cmd, check=check, shell=True, capture_output=capture, universal_newlines=True
    )
    return p.stdout if check else None


def container_exists(name):
    try:
        result = subprocess.run(
            [
                "docker",
                "ps",
                "-a",
                "--filter",
                f"name=^{name}$",
                "--format",
                "{{.Names}}",
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        )
        return name in result.stdout.strip().splitlines()
    except Exception as e:
        print(f"[ERROR] Failed to check container existence: {e}")
        return False


def image_exists_locally(image_tag):
    try:
        subprocess.run(
            ["docker", "image", "inspect", image_tag],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )
        return True
    except subprocess.CalledProcessError:
        return False


@_subcommand
def start(args):
    """Start the docker container."""
    image_tag = f"axelera-sdk-ubuntu-2204-arm64:{args.version}"
    if not image_exists_locally(image_tag):
        print(
            f"❌ Docker image '{image_tag}' not found locally. Please load or pull the image first."
        )
        sys.exit(1)

    print(f"""
🔧 Creating container: {args.container_name}
🚀 Voyager SDK version: {args.version}
    """)

    if container_exists(args.container_name):
        print(f"""
⚠️ Note: Container {args.container_name} already exists. Attempting to start it...
✅ If the container starts successfully, you're good to go!
        """)
        subprocess.run(["docker", "start", "-ai", args.container_name], check=True)
        return
    if set(["XDG_RUNTIME_DIR", "WAYLAND_DISPLAY"]).issubset(os.environ):
        print("Setting permissions for external weston access...")
        _run(args, "chmod o=x ${XDG_RUNTIME_DIR}")
        _run(args, "chmod o=rwx ${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}")
        _run(args, "xhost +local:docker")

    mount_wayland_display = ""
    if os.getenv("WAYLAND_DISPLAY") is not None:
        mount_wayland_display = (
            "-v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY"
        )

    print("""
    ✅ Container created successfully.
    📦 Final Step: Set up the required libraries
    🔧 Run this command **exactly as shown**:

        👉  make clobber-libs && make operators  👈

    📌 Notes:
    - This step requires an active internet connection.
    - It only needs to be run once after the container is created.
    - For more information, please refer to our documentation.
    """)

    setup_command = (
        "cd /home/ubuntu/voyager-sdk && source venv/bin/activate && /bin/bash"
    )

    _run(
        args,
        "docker run -it --privileged "
        "-v $(pwd)/shared:/home/ubuntu/shared/ "
        "-v /tmp/.X11-unix:/tmp/.X11-unix "
        "-v /usr/lib/libmali-hook.so.1:/usr/lib/libmali-hook.so.1 "
        "-v /usr/lib/libmali.so.1:/usr/lib/libmali.so.1 "
        "-v /etc/OpenCL:/etc/OpenCL "
        "-v /usr/lib/aarch64-linux-gnu/mali:/usr/lib/aarch64-linux-gnu/mali:ro "
        "-v /usr/lib/libMaliOpenCL.so.1:/usr/lib/libMaliOpenCL.so.1 "
        f"-v /usr/lib/gstreamer-1.0/:/opt/axelera/runtime-{args.version}-1/lib/gstreamer-1.0 "
        "-v /usr/lib/librockchip_mpp.so.1:/usr/lib/librockchip_mpp.so.1 "
        "-v /usr/lib/librga.so.2:/usr/lib/librga.so.2 "
        "-v /usr/lib/liba52.so.0:/usr/lib/liba52.so.0 "
        "-v /usr/lib/libjpeg.so.62:/usr/lib/libjpeg.so.62 "
        "-v /usr/lib/libgstvulkan-1.0.so.0:/usr/lib/libgstvulkan-1.0.so.0 "
        "-v /usr/lib/libavfilter.so.9:/usr/lib/libavfilter.so.9 "
        "-v /usr/lib/libavformat.so.60:/usr/lib/libavformat.so.60 "
        "-v /usr/lib/libvulkan.so.1:/usr/lib/libvulkan.so.1 "
        "-v /usr/lib/libavcodec.so.60:/usr/lib/libavcodec.so.60 "
        "-v /usr/lib/libavutil.so.58:/usr/lib/libavutil.so.58 "
        "-v /usr/lib/libswscale.so.7:/usr/lib/libswscale.so.7 "
        "-v /usr/lib/libswresample.so.4:/usr/lib/libswresample.so.4 "
        "--device=/dev/mali0 "
        " -e DISPLAY=$DISPLAY "
        " -e XDG_RUNTIME_DIR=/tmp "
        " -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY "
        f"{mount_wayland_display} "
        f"--name={args.container_name} "
        "--entrypoint=/bin/bash "
        "--ulimit core=0 "
        "--network=host "
        f"{image_tag} "
        f'-c "{setup_command}"',
        capture=False,
        check=False,
    )


@_subcommand
def rescan_pci(args):
    """Invoke a PCIe bus rescan."""
    if os.geteuid() != 0:
        print("[ERROR] Please invoke this command as superuser (root)")
        sys.exit(1)

    if os.path.exists(r"/sys/bus/pci/devices/0000:01:00.0/remove"):
        _run(
            args,
            'bash -c "echo 1 > /sys/bus/pci/devices/0000:01:00.0/remove"',
            check=False,
        )
    _run(args, 'bash -c "echo 1 > /sys/bus/pci/rescan"')
    time.sleep(1)
    print("[INFO] PCIe bus rescan completed.")


def main(args):
    try:
        if args.help:
            print(CUSTOM_HELP)
            return 0

        args.func(args)
        return 0
    except RuntimeError as e:
        if args.verbose:
            raise
        return str(e)
    except KeyboardInterrupt:
        return "Interrupted"


if __name__ == "__main__":
    sys.exit(main(parser.parse_args()))
