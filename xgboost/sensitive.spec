# -*- mode: python ; coding: utf-8 -*-

from pathlib import Path
import xgboost, os
import gurobipy

xgb_dir = Path(xgboost.__file__).parent
xgb_lib_dir =  xgb_dir / "lib"
libxgb = next(xgb_lib_dir.glob("libxgboost*.so"))  # handles possible suffixes
xgb_version_file = xgb_dir / "VERSION"

gurobi_dir = Path(gurobipy.__file__).parent




data_files = [(str(xgb_version_file), 'xgboost')]

a = Analysis(
    ['src/sensitive.py'],
    pathex=[],
    binaries=[(str(libxgb), "xgboost/lib")],
    datas=data_files,
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='sensitive',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
