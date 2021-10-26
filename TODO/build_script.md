
# BUILD SCRIPT

(! - Must be connected to Internet (?))

python <PATH_TO_USD_RELEASE>\build_scripts\build_usd.py <INSTALL_PATH> --verbose --python --usd-imaging --ptex --openvdb --usdview --embree --prman --openimageio --opencolorio --alembic --draco --materialx

An example of command line using the script:
python c:\Users\default\Documents\usd_setup\USD-release\build_scripts\build_usd.py "C:\Users\default\Documents\usd\usd_build" --verbose --python --usd-imaging --ptex --openvdb --usdview --embree --prman --openimageio --opencolorio --alembic --draco --materialx


"Dry-run", to check before making the build:
python <PATH_TO_USD_RELEASE>\build_scripts\build_usd.py <INSTALL_PATH> --dry_run --verbose --python --usd-imaging --ptex --openvdb --usdview --embree --prman --openimageio --opencolorio --alembic --draco --materialx

----

COMMAND ARGUMENTS:
(in parenthesis are set by default)

Optional:
  --dry_run
  --verbose 3

Build:
!?
  --build-args
    => need specific args?
  --force-all
    => Try install to have everything

USD
  (--build-shared)
  ?
  --debug
  ?
  --tests
    => to validate?
  (later)
  --no-examples
  --no-turorials
    => if want "light/clean" install
  (--tools)
  --docs
    => should build it?
  (--python)
  (--prefer-safety-over-speed)

!
Imaging and USD Imaging:
  (--usd-imaging)
  --ptex
  --openvdb
  (--usdview)

!
Imaging:
  --embree
  --prman
  --openimageio
  --opencolorio

!
Alembic:
  --alembic
  ?
  --hdf5
    => If not, uses Ogawa? Or if allow have both?

!
Draco:
  --draco
!
MaterialX:
  --materialx


Try with:
--force-all



Summary (script):
```
set PYTHON_PATH=C:\Users\2-REC\AppData\Local\Programs\Python\Python37

"C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"

set PATH=%PYTHON_PATH%;%PATH%
set PATH=%PYTHON_PATH%\Scripts;%PATH%
set PATH=C:\ProgramData\nasm;%PATH%

# For PySide2
set PATH=%PYTHON_PATH%\Lib\site-packages;%PATH%

python c:\Users\2-REC\Documents\usd_setup\USD-release\build_scripts\build_usd.py "C:\Users\2-REC\Documents\usd\usd_build" --verbose --python --usd-imaging --ptex --openvdb --usdview --embree --prman --openimageio --opencolorio --alembic --draco --materialx
```
