import os
import sys
import ranger.api
import ranger.api.commands
from subprocess import PIPE

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "plugins"))
# `X as X` signals intentional re-export to ruff (PEP 484)
from fzf_commands import (
    fzf_project_files as fzf_project_files,
    fzf_project_rg as fzf_project_rg,
    fzf_project_dirs as fzf_project_dirs,
    fzf_dir_files as fzf_dir_files,
    fzf_dir_rg as fzf_dir_rg,
    fzf_dir_dirs as fzf_dir_dirs,
    fzf_z as fzf_z,
)


class z(ranger.api.commands.Command):
    """
    :z

    Jump around with zoxide (cd)
    """
    def execute(self):
        results = self.query(self.args[1:])

        input_path = ' '.join(self.args[1:])
        if not results and os.path.isdir(input_path):
            self.fm.cd(input_path)
            return

        if not results:
            return

        if os.path.isdir(results[0]):
            self.fm.cd(results[0])

    def query(self, args):
        try:
            zoxide = self.fm.execute_command(f"zoxide query {' '.join(args)}",
                                             stdout=PIPE
                                             )
            stdout, stderr = zoxide.communicate()

            if zoxide.returncode == 0:
                output = stdout.decode("utf-8").strip()
                return output.splitlines()
            elif zoxide.returncode == 1:  # nothing found
                return None
            elif zoxide.returncode == 130:  # user cancelled
                return None
            else:
                output = stderr.decode("utf-8").strip() or f"zoxide: unexpected error (exit code {zoxide.returncode})"
                self.fm.notify(output, bad=True)
        except Exception as e:
            self.fm.notify(e, bad=True)


class enter_dir(ranger.api.commands.Command):
    """
    :enter_dir

    Enter the directory under the cursor.
    Do not open file.
    """
    def execute(self):
        target = self.fm.thisfile
        if target and target.is_directory:
            self.fm.move(right=1)


class ripdrag(ranger.api.commands.Command):
    """
    :ripdrag

    Drag and drop files using ripdrag.
    """
    def execute(self):
        if self.fm.thistab.get_selection():
            files = [f.path for f in self.fm.thistab.get_selection()]
        else:
            files = [self.fm.thisfile.path]

        self.fm.execute_command(['ripdrag', '--and-exit'] + files, flags='f')
        self.fm.notify(f"Ripdrag started with {len(files)} file(s)")


class quitallcd(ranger.api.commands.Command):
    def execute(self):
        if self.arg(1):
            tmp_file = self.rest(1)
            cur_dir = self.fm.thisdir.path
            with open(tmp_file, "w") as f:
                f.write(cur_dir)
            self.fm.execute_console("quitall")
