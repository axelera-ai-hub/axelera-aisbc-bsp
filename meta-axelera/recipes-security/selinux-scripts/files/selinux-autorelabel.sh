#!/usr/bin/env bash

/usr/sbin/selinuxenabled 2>/dev/null || exit 0

FIXFILES=/sbin/fixfiles
SETENFORCE=/usr/sbin/setenforce

for i in "${FIXFILES}" "${SETENFORCE}"; do
  test -x "${i}" && continue
  echo "${i} is missing in the system."
  echo "Please add \"selinux=0\" in the kernel command line to disable SELinux."
  exit 1
done

# Reset the boot count if this is a relabel after an update.
# If this isn't done, mender performs a rollback after a relabel
# and a reboot because the update is not yet commited.
reset_mender_ubootenv() {
  upgrade_check="$(fw_printenv upgrade_available || true)"
  if [[ "${upgrade_check}" == "upgrade_available=1" ]]; then
    fw_setenv bootcount 0
  fi
}

check_autorelabel() {
  if [[ -f /.autorelabel ]]; then
    setenforce 0
    mount -oremount,rw,seclabel /
    sleep 2
    fixfiles -Ff relabel
    restorecon -rF /
    rm -f /.autorelabel
    reset_mender_ubootenv
    reboot -f
  fi
}

main() {
  check_autorelabel
}

main "${@}"

exit 0
