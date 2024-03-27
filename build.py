#!/usr/bin/env python3

import argparse
import subprocess
import sys
from pathlib import Path
from subprocess import CalledProcessError, CompletedProcess
from typing import Sequence, TypeAlias


PROJECT_DIR: Path = Path.home() / 'Projects' / 'personal-zig-notes-archive'
Process: TypeAlias = CompletedProcess | CalledProcessError

def pass_filename(filename: str) -> Path:
    if not filename.endswith(".zig"):
        filename += ".zig"
    src_file: Path = PROJECT_DIR / 'src' / filename
    if not src_file.exists():
        raise FileNotFoundError(f"{src_file} not found")
    return src_file


def zig_build_exe_repr(captured_output: Process) -> tuple[int, tuple[str, str]]:
    returncode: int = captured_output.returncode
    stdout: str = (captured_output.stdout).decode()
    stderr: str = (captured_output.stderr).decode()
    return returncode, (stdout, stderr)


def zig_build_exe(src_file: Path) -> tuple[int, tuple[str, str]]:
    try:
        exe: Process = subprocess.run(['zig', 'build-exe', src_file], capture_output=True, check=True)
    except CalledProcessError as e:
        return zig_build_exe_repr(e)
    else:
        return zig_build_exe_repr(exe)


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Build Zig source code.")
    parser.add_argument('filename', help="Zig source code filename", metavar="FILE")
    # If argv is None, then parser.parse_args(argv) will check sys.argv[1:] automatically.
    args = parser.parse_args(argv)

    # In case main() is called without an argument in the REPL.
    if not args.filename:
        print("FILE cannot be empty", file=sys.stderr)
        return 1

    src_file: Path = pass_filename(args.filename)
    result: tuple[int, tuple[str, str]] = zig_build_exe(src_file)
    print(*(_ for _ in result[1] if _ != ''), sep='\n')

    # Unsure if Zig compiler can return exit codes other than 0 and 1.
    if result[0] != 0:
        return result[0]

    # Undecided on whether a build script should handle building and setting up the project
    # or, if a different setup file should be created.
    # Since this is a personal project and the scope is small, manual setup is okay for now.
    old_bin_file = src_file.parent / src_file.stem
    new_bin_file = PROJECT_DIR / 'zig-out' / 'bin' / src_file.stem

    old_obj_file = src_file.parent / (src_file.stem + '.o')
    new_obj_file = PROJECT_DIR / 'zig-out' / 'shared' / (src_file.stem + '.o')

    # .replace() preferred over .rename() because overwriting is not a concern.
    old_bin_file.replace(new_bin_file)
    old_obj_file.replace(new_obj_file)

    return 0


if __name__ == "__main__":
    exit(main())
