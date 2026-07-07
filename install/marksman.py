#! /usr/bin/env python3

import os
import subprocess
import tempfile
import urllib.request
from pathlib import Path

from util import has_sudo, fish_add_paths


VERSION = "2026-02-08"
BINARY_NAME = "marksman-linux-x64"
URL = f"https://github.com/artempyanykh/marksman/releases/download/{VERSION}/{BINARY_NAME}"


def main():
    with tempfile.TemporaryDirectory() as workdir:
        binary_path = Path(workdir) / BINARY_NAME
        print(f"fetching {URL}")
        urllib.request.urlretrieve(URL, binary_path)
        binary_path.chmod(0o755)

        if has_sudo():
            print("sudo detected... install to the system")
            install_cmd = ["install"] if os.geteuid() == 0 else ["sudo", "install"]
            subprocess.run(
                [*install_cmd, "-m", "755", binary_path, "/usr/local/bin/marksman"],
                check=True,
            )
            marksman_bin = Path("/usr/local/bin/marksman")
        else:
            print("not a sudoer. installing to local...")
            local_bin = Path.home() / ".local" / "bin"
            local_bin.mkdir(parents=True, exist_ok=True)

            subprocess.run(
                ["install", "-m", "755", binary_path, local_bin / "marksman"],
                check=True,
            )
            marksman_bin = local_bin / "marksman"

            fish_add_paths(local_bin)

    env = os.environ.copy()
    env["PATH"] = f"{marksman_bin.parent}:{env.get('PATH', '')}"
    subprocess.run([marksman_bin, "--version"], check=True, env=env)


if __name__ == "__main__":
    main()
