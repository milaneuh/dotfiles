import os
import ranger.api.commands
from subprocess import PIPE

ROOT_DIR = os.getcwd()


def _fzf_cmd():
    if os.environ.get("FZF_TMUX") == "1":
        opts = os.environ.get("FZF_TMUX_OPTS", "")
        return f"fzf-tmux {opts}".strip()
    return "fzf"


class fzf_project_files(ranger.api.commands.Command):
    """
    :fzf_project_files

    Fuzzy find files from the directory where ranger was opened.
    """
    def execute(self):
        fzf = _fzf_cmd()
        cmd = f"cd \"{ROOT_DIR}\" && find . -type f | {fzf} --preview 'bat --color=always \"{ROOT_DIR}\"/{{}}'"
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
        cmd = f"cd \"{ROOT_DIR}\" && rg --line-number . | {fzf} --delimiter : --preview 'bat --color=always \"{ROOT_DIR}\"/{{1}} --highlight-line {{2}}'"
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
        cmd = f"cd \"{ROOT_DIR}\" && find . -type d | {fzf} --preview 'tree -C \"{ROOT_DIR}\"/{{}} | head -50'"
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
        cmd = f"cd \"{cur}\" && find . -type f | {fzf} --preview 'bat --color=always \"{cur}\"/{{}}'"
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
        cmd = f"cd \"{cur}\" && find . -type d | {fzf} --preview 'tree -C \"{cur}\"/{{}} | head -50'"
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
        cmd = f"cd \"{cur}\" && rg --line-number . | {fzf} --delimiter : --preview 'bat --color=always \"{cur}\"/{{1}} --highlight-line {{2}}'"
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
        cmd = f"zoxide query -l | {fzf} --preview 'tree -C {{}} | head -50'"
        proc = self.fm.execute_command(cmd, stdout=PIPE)
        stdout, _ = proc.communicate()
        if proc.returncode == 0:
            self.fm.cd(stdout.decode("utf-8").strip())
