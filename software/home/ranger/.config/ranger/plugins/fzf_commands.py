import os
import ranger.api.commands
from subprocess import PIPE

ROOT_DIR = os.getcwd()
RG_OPTS = "--delimiter : --preview 'fzf-preview {1} {2}'"


def _select(fm, cwd, source, opts=""):
    cmd = f'cd "{cwd}" && {source} | fzf {opts}'.strip()
    proc = fm.execute_command(cmd, stdout=PIPE)
    stdout, _ = proc.communicate()

    if proc.returncode != 0:
        return None

    result = stdout.decode("utf-8").strip()
    return os.path.normpath(os.path.join(cwd, result)) if result else None


def _select_match(fm, cwd, source):
    cmd = f'cd "{cwd}" && {source} | fzf {RG_OPTS}'
    proc = fm.execute_command(cmd, stdout=PIPE)
    stdout, _ = proc.communicate()

    if proc.returncode != 0:
        return None

    result = stdout.decode("utf-8").strip().split(":")[0]
    return os.path.normpath(os.path.join(cwd, result)) if result else None


class fzf_project_files(ranger.api.commands.Command):
    """
    :fzf_project_files

    Fuzzy find files from the directory where ranger was opened.
    """
    def execute(self):
        path = _select(self.fm, ROOT_DIR, "find . -type f")
        if path:
            self.fm.select_file(path)


class fzf_project_rg(ranger.api.commands.Command):
    """
    :fzf_project_rg

    Ripgrep from the directory where ranger was opened, jump to file.
    """
    def execute(self):
        path = _select_match(self.fm, ROOT_DIR, "rg --line-number .")
        if path:
            self.fm.select_file(path)


class fzf_project_dirs(ranger.api.commands.Command):
    """
    :fzf_project_dirs

    Fuzzy find directories from the directory where ranger was opened.
    """
    def execute(self):
        path = _select(self.fm, ROOT_DIR, "find . -type d")
        if path:
            self.fm.cd(path)


class fzf_dir_files(ranger.api.commands.Command):
    """
    :fzf_dir_files

    Fuzzy find files from the current directory.
    """
    def execute(self):
        path = _select(self.fm, self.fm.thisdir.path, "find . -type f")
        if path:
            self.fm.select_file(path)


class fzf_dir_dirs(ranger.api.commands.Command):
    """
    :fzf_dir_dirs

    Fuzzy find directories from the current directory.
    """
    def execute(self):
        path = _select(self.fm, self.fm.thisdir.path, "find . -type d")
        if path:
            self.fm.cd(path)


class fzf_dir_rg(ranger.api.commands.Command):
    """
    :fzf_dir_rg

    Ripgrep from the current directory, jump to file.
    """
    def execute(self):
        path = _select_match(self.fm, self.fm.thisdir.path, "rg --line-number .")
        if path:
            self.fm.select_file(path)


class fzf_z(ranger.api.commands.Command):
    """
    :fzf_z

    Interactive zoxide jump with fzf.
    """
    def execute(self):
        path = _select(self.fm, self.fm.thisdir.path, "zoxide query -l")
        if path:
            self.fm.cd(path)
