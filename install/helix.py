#! /usr/bin/env python3

import os
import shutil
import subprocess
import tarfile
import urllib.request
import tempfile
from pathlib import Path

from util import has_sudo, fish_add_paths


VERSION = "25.07.1"
ARCHIVE_NAME = f"helix-{VERSION}-x86_64-linux.tar.xz"
URL = (
    f"https://github.com/helix-editor/helix/releases/download/{VERSION}/{ARCHIVE_NAME}"
)
EXTRACT_DIR = f"helix-{VERSION}-x86_64-linux"
RUNTIME_DIR = Path.home() / ".config" / "helix" / "runtime"

def main():
    with tempfile.TemporaryDirectory() as workdir:
        archive_path = Path(workdir) / ARCHIVE_NAME
        urllib.request.urlretrieve(URL, archive_path)

        with tarfile.open(archive_path, "r:xz") as tar:
            tar.extractall(path=workdir, filter="data")

        extracted_base = Path(workdir) / EXTRACT_DIR
        hx_source = extracted_base / "hx"
        runtime_source = extracted_base / "runtime"
        assert hx_source.exists()
        assert runtime_source.exists()

        if has_sudo():
            subprocess.run(["sudo", "install", "-m", "755", hx_source, "/usr/local/bin/hx"])
            hx_bin = Path("/usr/local/bin/hx")
        else:
            local_bin = Path.home() / ".local" / "bin"
            local_bin.mkdir(parents=True, exist_ok=True)

            subprocess.run(["install", "-m", "755", hx_source, local_bin / "hx"])
            hx_bin = local_bin / "hx"

            fish_add_paths(local_bin)


        if RUNTIME_DIR.exists():
            shutil.rmtree(RUNTIME_DIR)

        RUNTIME_DIR.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(runtime_source, RUNTIME_DIR)


    env = os.environ.copy()
    env["PATH"] = f"{hx_bin.parent}:{env.get('PATH', '')}"
    subprocess.run([hx_bin, "--version"], env=env)


if __name__ == "__main__":
    main()
