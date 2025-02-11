# The default UID and GID when useradd is called is 1000 (or the next closest number.)
# However, in our use case, we need to ensure the axelera group and user have UID and GID
# 1000. As such, we manually set the UID and GID here of the Weston user.
USERADD_PARAM:${PN} = " --uid 2000 --home /home/weston --shell /bin/sh --user-group -G video,input weston"
GROUPADD_PARAM:${PN} = " --gid 2000 --system weston-launch"
