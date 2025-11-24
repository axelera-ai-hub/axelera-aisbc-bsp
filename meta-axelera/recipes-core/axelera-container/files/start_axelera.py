#!/usr/bin/env python3
import argparse
import os
import subprocess
import sys
import time


# Color codes for terminal output
class Colors:
    RED = "\033[91m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    MAGENTA = "\033[95m"
    CYAN = "\033[96m"
    BOLD = "\033[1m"
    RESET = "\033[0m"


def print_info(message):
    print(f"{Colors.CYAN}[INFO]{Colors.RESET} {message}")


def print_warning(message):
    print(f"{Colors.YELLOW}[WARNING]{Colors.RESET} {message}")


def print_error(message):
    print(f"{Colors.RED}[ERROR]{Colors.RESET} {message}")


def print_critical(message):
    print(
        f"{Colors.RED}{Colors.BOLD}[CRITICAL]{Colors.RESET} {Colors.BOLD}{message}{Colors.RESET}"
    )


def print_debug(message):
    print(f"{Colors.MAGENTA}[DEBUG]{Colors.RESET} {message}")


# Custom parser to improve error messaging
class CustomArgumentParser(argparse.ArgumentParser):
    def error(self, message):
        sys.stderr.write(f"\n{Colors.RED}ERROR:{Colors.RESET} {message}\n")
        sys.stderr.write(
            "\nUSAGE: python3 start_axelera.py start --container-name <name> --version <tag>\n"
            "For detailed usage information, run: python3 start_axelera.py --help\n"
        )
        sys.exit(2)


parser = CustomArgumentParser(
    description="Axelera AI - Metis Compute Board Utility\n\n",
    formatter_class=argparse.RawTextHelpFormatter,
    add_help=False,
)

CUSTOM_HELP = """
AXELERA AI - METIS COMPUTE BOARD UTILITY
========================================

DESCRIPTION:
  Command-line utility for managing Voyager SDK containers on Axelera AI Metis
  Compute Boards. Supports automated display detection and configuration for
  optimal GUI application performance.

USAGE:
  start_axelera.py <command> [options]

COMMANDS:
  start       Launch a Voyager SDK container with automatic display configuration
  rescan-pci  Perform PCIe bus rescan to detect hardware changes (root required)

COMMAND: start
  --container-name   Docker container identifier (alphanumeric, hyphens, periods, underscores)
  --detach           Start container in detach mode to allow to run command using exec (Mostly used for testing)
  --version          Voyager SDK version tag (e.g., 1.4.0)

  Example:
    python3 start_axelera.py start --container-name axelera-voyager-sdk --version 1.4.0

COMMAND: rescan-pci
  Performs a complete PCIe bus rescan to detect hardware topology changes.
  Requires root privileges for direct hardware access.

  Example:
    python3 start_axelera.py rescan-pci

GLOBAL OPTIONS:
  -v, --verbose      Enable verbose logging (use -vv for detailed diagnostics)
  -h, --help         Display this help information and exit
"""

parser.add_argument("-v", "--verbose", action="count", default=0, help="Verbose output")
parser.add_argument(
    "-h", "--help", action="store_true", help="Show this help message and exit"
)
subparsers = parser.add_subparsers(dest="command", help="Available commands")


def _subcommand(func):
    name = func.__name__.replace("_", "-")
    subparser = subparsers.add_parser(
        name, help=func.__doc__, formatter_class=argparse.RawTextHelpFormatter
    )
    subparser.set_defaults(func=func)
    subparser.func = func

    # Add verbose flag to all subcommands
    subparser.add_argument(
        "-v", "--verbose", action="count", default=0, help="Verbose output"
    )

    if name == "start":
        subparser.add_argument(
            "--container-name",
            required=True,
            help="Name of the docker container (alphanumeric, hyphens, periods, underscores)",
        )
        subparser.add_argument(
            "--version",
            required=True,
            help="Version tag of the Voyager SDK container (e.g., 1.4.0)",
        )
        subparser.add_argument(
            "--detach",
            required=False,
            action="store_true",
            help="Start container in detach mode",
        )

    return subparser


def _run(args, cmd, check=True, capture=True):
    if args.verbose:
        print_debug(f"Executing: {cmd}")
    try:
        p = subprocess.run(
            cmd,
            check=check,
            shell=True,
            capture_output=capture,
            universal_newlines=True,
        )
        if args.verbose and p.stdout:
            print_debug(f"Output: {p.stdout.strip()}")
        return p.stdout if check else None
    except subprocess.CalledProcessError as e:
        print_error(f"Command failed: {cmd}")
        if e.stderr:
            print_error(f"{e.stderr.strip()}")
        if not check:
            return None
        raise


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
        print_error(f"Failed to check container existence: {e}")
        return False


def is_ssh_connection():
    """Detect if we're running in an SSH session."""
    return (
        os.getenv("SSH_CLIENT") is not None
        or os.getenv("SSH_TTY") is not None
        or os.getenv("SSH_CONNECTION") is not None
    )


def detect_local_display():
    """Detect and configure local physical display on the host."""

    # Check for Wayland display first (modern Linux systems)
    if set(["XDG_RUNTIME_DIR", "WAYLAND_DISPLAY"]).issubset(os.environ):
        print_info("Wayland display server detected on host system.")
        return {
            "display_type": "wayland",
            "display_args": (
                "-e DISPLAY=$DISPLAY "
                "-e XDG_RUNTIME_DIR=/tmp "
                "-e WAYLAND_DISPLAY=$WAYLAND_DISPLAY "
                "-v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY "
                "-v /tmp/.X11-unix:/tmp/.X11-unix"
            ),
            "setup_commands": [
                "chmod o+x ${XDG_RUNTIME_DIR} 2>/dev/null || true",
                "chmod o+rwx ${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY} 2>/dev/null || true",
                "command -v xhost >/dev/null 2>&1 && DISPLAY=$DISPLAY xhost +local:docker 2>/dev/null || true",
            ],
        }

    # Check for X11 display on physical host
    if check_physical_x_server():
        display = detect_x_display()
        print_info(f"X11 display server detected on host system ({display}).")
        return {
            "display_type": "x11_physical",
            "display_args": (
                f"-e DISPLAY={display} "
                f"-e QT_X11_NO_MITSHM=1 "
                f"-e XDG_RUNTIME_DIR=/tmp "
                f"-v /tmp/.X11-unix:/tmp/.X11-unix "
                f"--device=/dev/mali0"
            ),
            "setup_commands": [
                f"command -v xhost >/dev/null 2>&1 && DISPLAY={display} xhost +local:docker 2>/dev/null || true"
            ],
        }

    # Always configure for display support - users may connect displays later for debugging
    return {
        "display_type": "ready",
        "display_args": (
            "-e DISPLAY=:0 "
            "-e QT_X11_NO_MITSHM=1 "
            "-e XDG_RUNTIME_DIR=/tmp "
            "-v /tmp/.X11-unix:/tmp/.X11-unix:rw "
            "--device=/dev/mali0"
        ),
        "setup_commands": [
            "mkdir -p /tmp/.X11-unix 2>/dev/null || true",
            "command -v xhost >/dev/null 2>&1 && xhost +local:docker 2>/dev/null || true",
        ],
    }


def has_physical_display_connected():
    """Check if a physical display is actually connected (not just X server running)."""
    # Check for active display connections through various methods

    # Method 1: Check DRM/KMS connections (most reliable for physical displays)
    # Exclude Writeback connectors as they're virtual, not physical displays
    drm_paths = [
        "/sys/class/drm/card0-HDMI-A-1/status",
        "/sys/class/drm/card0-DP-1/status",
        "/sys/class/drm/card0-LVDS-1/status",
        "/sys/class/drm/card0-eDP-1/status",
    ]
    for drm_path in drm_paths:
        try:
            if os.path.exists(drm_path):
                with open(drm_path, "r") as f:
                    status = f.read().strip()
                    if status == "connected":
                        return True
        except (IOError, OSError):
            continue

    # Method 2: Check for EDID data (indicates connected monitor)
    edid_paths = [
        "/sys/class/drm/card0-HDMI-A-1/edid",
        "/sys/class/drm/card0-DP-1/edid",
    ]
    for edid_path in edid_paths:
        try:
            if os.path.exists(edid_path):
                with open(edid_path, "rb") as f:
                    edid_data = f.read()
                    if len(edid_data) > 0:  # EDID data present = display connected
                        return True
        except (IOError, OSError):
            continue

    return False


def check_physical_x_server():
    """Check if there's a physical X server running with actual display connected."""
    # First check if X server is running
    x_server_running = False

    # Check for X11 sockets
    x11_socket_paths = ["/tmp/.X11-unix/X0", "/tmp/.X11-unix/X1", "/tmp/.X11-unix/X2"]
    for socket_path in x11_socket_paths:
        if os.path.exists(socket_path):
            x_server_running = True
            break

    # Check for X server processes if no socket found
    if not x_server_running:
        try:
            result = subprocess.run(
                ["pgrep", "-f", "Xorg|Xwayland|X "],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
            )
            if result.returncode == 0 and result.stdout.strip():
                x_server_running = True
        except FileNotFoundError:
            # Fallback to pidof
            try:
                for x_server in ["Xwayland", "Xorg"]:
                    result = subprocess.run(
                        ["pidof", x_server],
                        stdout=subprocess.PIPE,
                        stderr=subprocess.DEVNULL,
                    )
                    if result.returncode == 0 and result.stdout.strip():
                        x_server_running = True
                        break
            except FileNotFoundError:
                pass

    # Only return True if both X server is running AND physical display is connected
    return x_server_running and has_physical_display_connected()


def detect_x_display():
    """Detect the correct DISPLAY variable for physical X server."""
    # If DISPLAY is already set, validate it if possible
    current_display = os.getenv("DISPLAY")
    if current_display:
        # For SSH sessions, DISPLAY might be set but not usable for physical display
        # Skip validation and use socket-based detection instead
        if not is_ssh_connection():
            return current_display

    # Check for available X11 sockets in priority order
    for display_num in ["0", "1", "2"]:
        socket_path = f"/tmp/.X11-unix/X{display_num}"
        if os.path.exists(socket_path):
            return f":{display_num}"

    # Return default display for container usage
    return ":0"


def setup_display_environment(args):
    """Setup display environment for container to use host's physical display."""
    is_ssh = is_ssh_connection()
    local_display_config = detect_local_display()

    if local_display_config["display_type"] in ["wayland", "x11_physical"]:
        if is_ssh:
            print_info(
                "SSH connection detected - container configured for host's physical display."
            )
            print_info(
                "GUI applications will appear on the display connected to the host machine."
            )
        else:
            print_info(
                "Local session detected - container configured for direct display access."
            )
    elif local_display_config["display_type"] == "ready":
        if is_ssh:
            print_info(
                "SSH connection detected - container ready for display hot-plug."
            )
            print_info(
                "Connect a display to the host machine to enable GUI applications."
            )
        else:
            print_info(
                "Console/terminal access detected - container ready for display hot-plug when needed for GUI debugging."
            )

    return local_display_config


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


def validate_prerequisites():
    """Validate system prerequisites before starting container."""
    errors = []

    # Check Docker is available
    try:
        subprocess.run(
            ["docker", "--version"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        errors.append("Docker is not installed or not available in PATH")

    # Check Docker daemon is running
    try:
        subprocess.run(
            ["docker", "info"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=True,
        )
    except subprocess.CalledProcessError:
        errors.append("Docker daemon is not running")

    return errors


@_subcommand
def start(args):
    """Start the docker container."""

    # Validate prerequisites
    errors = validate_prerequisites()
    if errors:
        print_error("System prerequisites validation failed:")
        for error in errors:
            print(f"  * {error}")
        print("\nPlease resolve these system requirements before proceeding.")
        sys.exit(1)

    image_tag = f"axelera-sdk-ubuntu-2204-arm64:{args.version}"
    if not image_exists_locally(image_tag):
        print_error(f"Required Docker image '{image_tag}' is not available locally.")
        print_info(
            "Please ensure the Voyager SDK image is properly installed before proceeding."
        )
        sys.exit(1)

    print_info(
        f"Initializing Voyager SDK container '{args.container_name}' (Version {args.version})"
    )

    # Setup display environment based on connection type
    display_config = setup_display_environment(args)

    # Execute any required setup commands
    for cmd in display_config["setup_commands"]:
        try:
            _run(args, cmd)
        except subprocess.CalledProcessError as e:
            print_warning(f"Failed to execute display setup command: {cmd}")
            if args.verbose:
                print_debug(f"Error details: {e}")

    startup_command = (
        "cd /home/ubuntu/voyager-sdk && source venv/bin/activate && /bin/bash"
    )

    if container_exists(args.container_name):
        print_info(f"Existing container '{args.container_name}' detected.")

        # Check container status first
        try:
            result = subprocess.run(
                ["docker", "inspect", "-f", "{{.State.Status}}", args.container_name],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True,
            )
            container_status = result.stdout.strip()

            if container_status == "running":
                print_info("Container is running. Attaching to existing session...")
                subprocess.run(
                    ["docker", "exec", "-it", args.container_name, startup_command],
                    check=True,
                )
            elif container_status == "exited":
                print_info("Container has exited. Restarting container session...")
                subprocess.run(
                    ["docker", "start", "-ai", args.container_name], check=True
                )
            else:
                print_warning(
                    f"Container is in '{container_status}' state. Attempting to restart..."
                )
                subprocess.run(
                    ["docker", "start", "-ai", args.container_name], check=True
                )

        except subprocess.CalledProcessError:
            print_error(f"Unable to resume container '{args.container_name}'.")
            print_info("You can manually check container status with: docker ps -a")
            print_info(
                f"To remove the problematic container: docker rm {args.container_name}"
            )
            sys.exit(1)
        return

    # Display critical setup instructions prominently
    print()
    print("=" * 80)
    print_critical("CRITICAL SETUP REQUIRED AFTER CONTAINER STARTS")
    print("=" * 80)
    print()
    print(f"{Colors.BOLD}{Colors.YELLOW}REQUIRED COMMAND:{Colors.RESET}")
    print(
        f"{Colors.BOLD}{Colors.GREEN}make clobber-libs && make operators{Colors.RESET}"
    )
    print()
    print("IMPORTANT NOTES:")
    print("   * This command must be executed once after container startup")
    print("   * Internet connection is required for package downloads")
    print("   * Command execution may take several minutes to complete")
    print("   * Do not interrupt the process once started")
    print()
    print("=" * 80)
    print()

    docker_param = '-it'
    if args.detach:
        docker_param = '-itd'

    # Build Docker run command with appropriate display configuration
    docker_cmd = (
        f"docker run {docker_param} --privileged "
        "-v $(pwd)/shared:/home/ubuntu/shared/ "
        "-v /usr/lib/libmali-hook.so.1:/usr/lib/libmali-hook.so.1 "
        "-v /usr/lib/libmali.so.1:/usr/lib/libmali.so.1 "
        "-v /etc/OpenCL:/etc/OpenCL "
        "-v /data/sdk/container/volumes/usr/lib/aarch64-linux-gnu/mali:/usr/lib/aarch64-linux-gnu/mali:ro "
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
        f"{display_config['display_args']} "
        f"--name={args.container_name} "
        "--entrypoint=/bin/bash "
        "--ulimit core=0 "
        "--network=host "
        f"{image_tag} "
        f'-c "{startup_command}"'
    )

    _run(args, docker_cmd, capture=False, check=False)


@_subcommand
def rescan_pci(args):
    """Perform a PCIe bus rescan to detect hardware changes."""
    if os.geteuid() != 0:
        print_error("Root privileges required for PCIe bus operations.")
        print_info("Please run: python3 start_axelera.py rescan-pci")
        sys.exit(1)

    print_info("Initiating PCIe bus rescan...")

    # Remove specific device if it exists
    device_path = "/sys/bus/pci/devices/0000:01:00.0/remove"
    if os.path.exists(device_path):
        print_info("Removing PCIe device 0000:01:00.0")
        try:
            _run(
                args,
                'bash -c "echo 1 > /sys/bus/pci/devices/0000:01:00.0/remove"',
                check=True,
            )
        except subprocess.CalledProcessError:
            print_warning("Failed to remove PCIe device, continuing with rescan")

    # Perform bus rescan
    print_info("Rescanning PCIe bus...")
    try:
        _run(args, 'bash -c "echo 1 > /sys/bus/pci/rescan"', check=True)
        time.sleep(2)  # Allow time for device detection
        print_info("PCIe bus rescan completed successfully.")
    except subprocess.CalledProcessError:
        print_error("PCIe bus rescan failed.")
        sys.exit(1)


def validate_arguments(args):
    """Validate command line arguments."""
    if hasattr(args, "container_name"):
        import re

        # Allow alphanumeric, hyphens, periods, and underscores
        # Cannot start with hyphen, period, or underscore
        if not re.match(r"^[a-zA-Z0-9][a-zA-Z0-9._-]*$", args.container_name):
            print_error(
                "Invalid container name. Use alphanumeric characters, hyphens, periods, and underscores."
            )
            print_info(
                "Container name cannot start with hyphen, period, or underscore."
            )
            return False

    if hasattr(args, "version"):
        # Basic version format validation
        if not args.version or len(args.version.strip()) == 0:
            print_error("Version cannot be empty.")
            return False

    return True


def main(args):
    try:
        if args.help:
            print(CUSTOM_HELP)
            return 0

        # Check if a subcommand was provided
        if not hasattr(args, "func") or args.func is None:
            if not args.help:
                print_error("No command specified.")
            print(CUSTOM_HELP)
            return 1

        if not validate_arguments(args):
            return 1

        args.func(args)
        return 0
    except RuntimeError as e:
        print_error(f"Runtime error: {e}")
        if args.verbose:
            raise
        return 1
    except KeyboardInterrupt:
        print_info("\nOperation cancelled by user.")
        return 1
    except Exception as e:
        print_error(f"Unexpected error: {e}")
        if args.verbose:
            raise
        return 1


if __name__ == "__main__":
    sys.exit(main(parser.parse_args()))
