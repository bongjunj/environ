#! /usr/bin/env python3

import tarfile
import shutil
import sys
import hashlib
import urllib.request
import tempfile
import subprocess
import os
from pathlib import Path

from util import has_sudo, fish_add_paths


VERSION="1.26.3"
ARCHIVE_NAME=f"go{VERSION}.linux-amd64.tar.gz"
CHECKSUM="2b2cfc7148493da5e73981bffbf3353af381d5f93e789c82c79aff64962eb556"
URL=f"https://go.dev/dl/{ARCHIVE_NAME}"

def checksum(filepath, expected):
    sha256 = hashlib.sha256()
    with open(filepath, "rb") as f:
        while chunk := f.read(8192):
            sha256.update(chunk)

    return sha256.hexdigest() == expected


def main():
    with tempfile.TemporaryDirectory() as workdir:
        arc_path = os.path.join(workdir, ARCHIVE_NAME)
        print(f"fetching {URL}")
        urllib.request.urlretrieve(URL, arc_path)

        if not checksum(arc_path, CHECKSUM):
            sys.exit(1)

        print("checksum checked...")

        if has_sudo():
            print("sudo detected... install to the system")
            subprocess.run(["sudo", "rm", "-rf", "/usr/local/go"])
            subprocess.run(["sudo", "tar", "-C", "/usr/local", "-xzf", arc_path])
            go_bin_dir = Path("/usr/local/go/bin")
        else:
            print("not a sudoer. installing to local...")
            local_share = Path("~/.local/share").expanduser()
            go_dir = local_share / "go"
            local_share.mkdir(exist_ok=True)

            if go_dir.exists():
                shutil.rmtree(go_dir)
            with tarfile.open(arc_path, "r:gz") as tar:
                tar.extractall(path=local_share, filter="data")
            go_bin_dir = go_dir / "bin"


    go_exe = go_bin_dir / "go"
    gopath = Path(subprocess.run([go_exe, "env", "GOPATH"], check=True, capture_output=True, text=True).stdout.strip())
    print(f"gopath: {gopath}")
    go_tools_dir = gopath / "bin"
    go_tools_dir.mkdir(parents=True, exist_ok=True)

    curr_env = os.environ.copy()
    curr_env["PATH"] = f"{go_bin_dir}:{go_tools_dir}:{curr_env.get("PATH", "")}"

    subprocess.run([go_exe, "version"], env=curr_env)

    fish_add_paths(go_bin_dir, go_tools_dir)

    subprocess.run([go_exe, "install", "github.com/jesseduffield/lazygit@latest"], env=curr_env)

    lazygit_exe = shutil.which("lazygit", path=curr_env["PATH"])
    assert lazygit_exe
    subprocess.run([lazygit_exe, "--version"])

if __name__ == "__main__":
    main()

