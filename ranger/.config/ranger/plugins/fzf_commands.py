import os
import ranger.api.commands
from subprocess import PIPE

ROOT_DIR = os.getcwd()


def _fzf_cmd():
    if os.environ.get("FZF_TMUX") == "1":
        opts = os.environ.get("FZF_TMUX_OPTS", "")
        return f"fzf-tmux {opts}".strip()
    return "fzf"


def _preview(base=None, field="{}", line=None):
    target = f'"{base}"/{field}' if base else field
    line_arg = f" {line}" if line else ""
    return f"--preview 'fzf-preview {target}{line_arg}'"


class fzf_project_files(ranger.api.commands.Command):
    """
    :fzf_project_files

    Fuzzy find files from the directory where ranger was opened.
    """
    def execute(self):
        fzf = _fzf_cmd()
        cmd = f"cd \"{ROOT_DIR}\" && find . -type f | {fzf} {_preview(ROOT_DIR)}"
        proc = self.fm.execute_command(cmd, stdout=PIPE)
        stdout, _ = proc.communicate()
        if proc.returncode == 0:
            result = stdout.decode("utf-8").strip()
            self.fm.select_file(os.path.normpath(os.path.join(ROOT_DIR, result)))


class fzf_project_rg(ranger.api.commands.Command):
    """
    :fzf_project_rg

    Ripgrep from the directory where ranger was opened, jump to file.
    """
    def execute(self):
        fzf = _fzf_cmd()
        preview = _preview(ROOT_DIR, "{1}", "{2}")
        cmd = f"cd \"{ROOT_DIR}\" && rg --line-number . | {fzf} --delimiter : {preview}"
        proc = self.fm.execute_command(cmd, stdout=PIPE)
        stdout, _ = proc.communicate()
        if proc.returncode == 0:
            result = stdout.decode("utf-8").strip().split(":")[0]
            self.fm.select_file(os.path.normpath(os.path.join(ROOT_DIR, result)))


class fzf_project_dirs(ranger.api.commands.Command):
    """
    :fzf_project_dirs

    Fuzzy find directories from the directory where ranger was opened.
    """
    def execute(self):
        fzf = _fzf_cmd()
        cmd = f"cd \"{ROOT_DIR}\" && find . -type d | {fzf} {_preview(ROOT_DIR)}"
        proc = self.fm.execute_command(cmd, stdout=PIPE)
        stdout, _ = proc.communicate()
        if proc.returncode == 0:
            result = stdout.decode("utf-8").strip()
            self.fm.cd(os.path.normpath(os.path.join(ROOT_DIR, result)))


class fzf_dir_files(ranger.api.commands.Command):
    """
    :fzf_dir_files

    Fuzzy find files from the current directory.
    """
    def execute(self):
        fzf = _fzf_cmd()
        cur = self.fm.thisdir.path
        cmd = f"cd \"{cur}\" && find . -type f | {fzf} {_preview(cur)}"
        proc = self.fm.execute_command(cmd, stdout=PIPE)
        stdout, _ = proc.communicate()
        if proc.returncode == 0:
            result = stdout.decode("utf-8").strip()
            self.fm.select_file(os.path.normpath(os.path.join(cur, result)))


class fzf_dir_dirs(ranger.api.commands.Command):
    """
    :fzf_dir_dirs

    Fuzzy find directories from the current directory.
    """
    def execute(self):
        fzf = _fzf_cmd()
        cur = self.fm.thisdir.path
        cmd = f"cd \"{cur}\" && find . -type d | {fzf} {_preview(cur)}"
        proc = self.fm.execute_command(cmd, stdout=PIPE)
        stdout, _ = proc.communicate()
        if proc.returncode == 0:
            result = stdout.decode("utf-8").strip()
            self.fm.cd(os.path.normpath(os.path.join(cur, result)))


class fzf_dir_rg(ranger.api.commands.Command):
    """
    :fzf_dir_rg

    Ripgrep from the current directory, jump to file.
    """
    def execute(self):
        fzf = _fzf_cmd()
        cur = self.fm.thisdir.path
        preview = _preview(cur, "{1}", "{2}")
        cmd = f"cd \"{cur}\" && rg --line-number . | {fzf} --delimiter : {preview}"
        proc = self.fm.execute_command(cmd, stdout=PIPE)
        stdout, _ = proc.communicate()
        if proc.returncode == 0:
            result = stdout.decode("utf-8").strip().split(":")[0]
            self.fm.select_file(os.path.normpath(os.path.join(cur, result)))


class fzf_z(ranger.api.commands.Command):
    """
    :fzf_z

    Interactive zoxide jump with fzf.
    """
    def execute(self):
        fzf = _fzf_cmd()
        cmd = f"zoxide query -l | {fzf} {_preview()}"
        proc = self.fm.execute_command(cmd, stdout=PIPE)
        stdout, _ = proc.communicate()
        if proc.returncode == 0:
            self.fm.cd(stdout.decode("utf-8").strip())
