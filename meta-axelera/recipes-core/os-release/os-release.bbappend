OS_RELEASE_FIELDS = "\
    ID NAME VERSION BUILD_ID PRETTY_NAME BOARD_TYPE GIT_HASH \
"
OS_RELEASE_UNQUOTED_FIELDS:append = " BOARD_TYPE"

BOARD_TYPE = "${MACHINE}"
BUILD_ID = "${@d.getVar('JENKINS_BUILD_ID') or d.getVar('DATETIME')}"

python do_compile:prepend:axelera-device () {
    import git
    bblayers = d.getVar('BBLAYERS').split()
    index = [idx for idx, s in enumerate(bblayers) if 'meta-axelera' in s][0]
    try:
        repo = git.Repo(os.path.dirname(bblayers[index]))
        d.setVar('GIT_HASH', str(repo.head.object.hexsha))
    except git.InvalidGitRepositoryError:
        d.setVar('GIT_HASH', "NONE")
}

# Recompile every time to ensure the git hash is correct.
do_compile[nostamp] = "1"
