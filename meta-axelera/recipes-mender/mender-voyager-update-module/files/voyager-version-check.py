#!/usr/bin/env python3
import sys

OS_RELEASE_PATH = "/usr/lib/os-release"
ARTIFACT_PREFIX = "voyager-"

# We expect os-release to contain a line like this:
# VERSION="2.0.0-rc2"
# or
# VERSION="2.0.0"
def get_current_version(path: str) -> str:
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line.startswith("VERSION="):
                return line.split("=", 1)[1].strip().strip('"').strip("'")
    raise ValueError(f"VERSION key not found in {path}")


# Can parse distro versions into comparable int arrays.
# input "2.0.0"     ==> output [2, 0, 0, 1]
# input "2.0.0-rc5" ==> output [2, 0, 0, 0, 5]
# We expect distro versions to always be either releases or release candidates.
def parse_version(raw: str):
    v = raw.strip()
    has_hyphen = "-" in v # is rc

    # Fourth integer in the array determines if it's release (1) or rc (0)
    # so that releases always compare higher than rc with equal prefix
    v = v.replace("-rc", ".0.")

    try:
        numeric = [int(p) for p in v.split(".")] # We need numeric comparison
    except ValueError:
        raise ValueError(f"Invalid or unsupported version format: '{raw}'")

    # We expect format: X.X.X<-rcX>
    expected_len = 5 if has_hyphen else 3
    if len(numeric) != expected_len:
        raise ValueError(f"Invalid semantic version format: '{raw}'")

    if not has_hyphen: # No hyphen, release. Append 1 > 0
        numeric.append(1)

    return numeric


def main() -> int:
    if len(sys.argv) != 2 or not sys.argv[1].strip():
        print("Usage: voyager-version-check.py <incoming_artifact_name>", file=sys.stderr)
        return 1

    # Set in voyager-updateimg.bbclass by mender-artifact command (-n "voyager-${DISTRO_VERSION}")
    # as the artifact_name in header-info
    incoming_raw = sys.argv[1].strip()

    if incoming_raw.startswith(ARTIFACT_PREFIX):
        incoming_raw = incoming_raw[len(ARTIFACT_PREFIX):]

    try:
        current_raw = get_current_version(OS_RELEASE_PATH)
        incoming_ver = parse_version(incoming_raw)
        current_ver = parse_version(current_raw)
    except Exception as exc:
        print(f"Version check failed: {exc}", file=sys.stderr)
        return 1

    print(f"Current OS version: {current_raw}")
    print(f"Incoming artifact:  {incoming_raw}")

    if incoming_ver >= current_ver:
        print("Version check passed: incoming version is newer or equal.")
        return 0

    print(
        f"CRITICAL: Rejecting downgrade ({incoming_raw} is older than {current_raw}).",
        file=sys.stderr,
    )
    return 1


if __name__ == "__main__":
    sys.exit(main())
