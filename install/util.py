import shutil
import subprocess
import os

def has_sudo():
    if os.geteuid() == 0:
        return True
    try:
        subprocess.run(["sudo", "-n", "true"], check=True, capture_output=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def fish_add_paths(*paths):
    args = ["fish_add_path"]
    for p in paths:
        args.append(f"'{p}'")

    cmd = " ".join(args)

    if shutil.which("fish"):
        print("adding fish paths")
        subprocess.run(["fish", "-lc", cmd])
        return

    print("no fish detected")
