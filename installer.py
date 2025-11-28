#!/usr/bin/env python3
"""Unified installer for fish, gh, node, nvim, pyenv, rust, rbenv, and ruff."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Callable


def run(cmd: list[str], **kwargs):
    """Run a shell command, echoing it for transparency."""
    printable = " ".join(str(part) for part in cmd)
    print(f"$ {printable}")
    subprocess.run([str(part) for part in cmd], check=True, **kwargs)


def has_command(*names: str) -> bool:
    """Return True if all provided commands are discoverable in PATH."""
    return all(shutil.which(name) for name in names)


@dataclass
class Context:
    force: bool
    workdir: Path


@dataclass
class PackageInstaller:
    name: str
    description: str
    check_installed: Callable[[], bool]
    install: Callable[[Context], None]


def install_fish(ctx: Context):
    version = "4.1.2"
    archive_name = f"fish-{version}.tar.xz"
    url = f"https://github.com/fish-shell/fish-shell/releases/download/{version}/{archive_name}"
    archive_path = ctx.workdir / archive_name
    source_dir = ctx.workdir / f"fish-{version}"

    if archive_path.exists():
        archive_path.unlink()
    if source_dir.exists():
        shutil.rmtree(source_dir)

    run(["curl", "-Lo", str(archive_path), url])
    run(["tar", "-xvf", str(archive_path)], cwd=ctx.workdir)
    run(["cmake", "."], cwd=source_dir)
    run(["make"], cwd=source_dir)
    run(["sudo", "make", "install"], cwd=source_dir)


def install_gh(ctx: Context):
    version = "2.83.0"
    archive_name = f"gh_{version}_linux_amd64.tar.gz"
    url = f"https://github.com/cli/cli/releases/download/v{version}/{archive_name}"
    archive_path = ctx.workdir / archive_name
    extract_dir = ctx.workdir / f"gh_{version}_linux_amd64"

    if archive_path.exists():
        archive_path.unlink()
    if extract_dir.exists():
        shutil.rmtree(extract_dir)

    run(["curl", "-Lo", str(archive_path), url])
    run(["tar", "-xzvf", str(archive_path)], cwd=ctx.workdir)
    gh_binary = extract_dir / "bin" / "gh"
    run(["sudo", "install", "-m", "755", str(gh_binary), "/usr/local/bin/gh"])


def install_node(ctx: Context):
    script_path = ctx.workdir / "nodesource_setup.sh"

    if script_path.exists():
        script_path.unlink()

    run(
        [
            "curl",
            "-fsSL",
            "https://deb.nodesource.com/setup_22.x",
            "-o",
            str(script_path),
        ]
    )
    run(["sudo", "-E", "bash", str(script_path)])
    run(["sudo", "apt-get", "install", "-y", "nodejs"])
    if script_path.exists():
        script_path.unlink()
    run(["node", "-v"])
    run(["sudo", "npm", "install", "-g", "pyright"])


def install_nvim(ctx: Context):
    archive_name = "nvim-linux-x86_64.tar.gz"
    url = f"https://github.com/neovim/neovim/releases/latest/download/{archive_name}"
    archive_path = ctx.workdir / archive_name

    if archive_path.exists():
        archive_path.unlink()

    run(["curl", "-Lo", str(archive_path), url])
    run(["sudo", "rm", "-rf", "/opt/nvim"])
    run(["sudo", "tar", "-C", "/opt", "-xzf", str(archive_path)])


def install_pyenv(ctx: Context):
    pyenv_root = Path.home() / ".pyenv"
    if ctx.force and pyenv_root.exists():
        shutil.rmtree(pyenv_root)

    env = os.environ.copy()
    env["PYENV_ROOT"] = str(pyenv_root)
    env["PATH"] = f"{pyenv_root / 'bin'}:{pyenv_root / 'shims'}:{env.get('PATH','')}"

    run(["bash", "-c", "curl https://pyenv.run | bash"], env=env)
    pyenv_bin = pyenv_root / "bin" / "pyenv"
    run([str(pyenv_bin), "install", "-s", "3.12.4"], env=env)
    run([str(pyenv_bin), "global", "3.12.4"], env=env)


def install_rust(_: Context):
    run(["bash", "-c", "curl https://sh.rustup.rs -sSf | sh -s -- -y"])


def install_rbenv(ctx: Context):
    target = Path.home() / ".rbenv"
    if target.exists():
        if ctx.force:
            shutil.rmtree(target)
        else:
            raise RuntimeError("rbenv already exists; use --force to reinstall.")
    run(["git", "clone", "https://github.com/rbenv/rbenv.git", str(target)])
    shell_path = os.environ.get("SHELL") or "/bin/bash"
    shell_name = Path(shell_path).name
    run([str(target / "bin" / "rbenv"), "init", "-", shell_name])


def install_ruff(_: Context):
    run(["bash", "-c", "curl -LsSf https://astral.sh/ruff/install.sh | sh"])


PACKAGES = {
    "fish": PackageInstaller(
        name="fish",
        description="Fish shell 4.1.2 from source",
        check_installed=lambda: has_command("fish"),
        install=install_fish,
    ),
    "gh": PackageInstaller(
        name="gh",
        description="GitHub CLI 2.83.0",
        check_installed=lambda: has_command("gh"),
        install=install_gh,
    ),
    "node": PackageInstaller(
        name="node",
        description="Node.js 22.x via NodeSource (includes global pyright)",
        check_installed=lambda: has_command("node", "npm") and has_command("pyright"),
        install=install_node,
    ),
    "nvim": PackageInstaller(
        name="nvim",
        description="Neovim latest prebuilt",
        check_installed=lambda: has_command("nvim")
        or (Path("/opt/nvim/bin/nvim")).exists(),
        install=install_nvim,
    ),
    "pyenv": PackageInstaller(
        name="pyenv",
        description="pyenv with Python 3.12.4",
        check_installed=lambda: has_command("pyenv")
        or (Path.home() / ".pyenv" / "bin" / "pyenv").exists(),
        install=install_pyenv,
    ),
    "rust": PackageInstaller(
        name="rust",
        description="Rust toolchain via rustup",
        check_installed=lambda: has_command("rustup") or has_command("rustc"),
        install=install_rust,
    ),
    "rbenv": PackageInstaller(
        name="rbenv",
        description="rbenv from GitHub",
        check_installed=lambda: has_command("rbenv")
        or (Path.home() / ".rbenv" / "bin" / "rbenv").exists(),
        install=install_rbenv,
    ),
    "ruff": PackageInstaller(
        name="ruff",
        description="Ruff via official install script",
        check_installed=lambda: has_command("ruff"),
        install=install_ruff,
    ),
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Install developer tools. Defaults to installing everything."
    )
    parser.add_argument(
        "packages",
        nargs="*",
        choices=sorted(PACKAGES.keys()),
        help="Subset of packages to install (default: all)",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Reinstall even if the package already appears to be installed",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    targets = args.packages or list(PACKAGES.keys())

    with tempfile.TemporaryDirectory(prefix="installer-") as temp_dir:
        ctx = Context(force=args.force, workdir=Path(temp_dir))

        for name in targets:
            installer = PACKAGES[name]
            try:
                if not args.force and installer.check_installed():
                    print(
                        f"{name}: already installed, skipping (use --force to reinstall)."
                    )
                    continue
                print(f"==> Installing {name} ({installer.description})")
                installer.install(ctx)
                print(f"==> Completed {name}")
            except subprocess.CalledProcessError as exc:
                print(f"{name}: command failed with exit code {exc.returncode}")
                sys.exit(exc.returncode)
            except Exception as exc:  # noqa: BLE001
                print(f"{name}: {exc}")
                sys.exit(1)


if __name__ == "__main__":
    main()

