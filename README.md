# USD Windows Build

Help to build the USD project in Windows.


(TODO: add short description from Pixar site)
https://graphics.pixar.com/usd/docs/index.html

This repository aims at helping build [USD](https://github.com/PixarAnimationStudios/USD) from source in Windows.

The build process described here is based on the [USD Advanced Build Configuration](https://github.com/PixarAnimationStudios/USD/blob/release/BUILDING.md).

The process is aimed at version 21.08 of USD. Later versions might require changes, but the main process should remain the same.

Tested [versions for 3rd party libraries and applications](https://github.com/PixarAnimationStudios/USD/blob/release/VERSIONS.md) are listed.
However, even though USD is not part of the [VFX Reference Platform](https://vfxplatform.com/), the software and library versions used in the build process will try to follow the reference (when applicable).
CY2021 will be used as the annual reference.


Keep in mind that USD is not yet fully compatible with Windows, as indicated when executing the configure process:
```
CMake Warning at cmake/defaults/ProjectDefaults.cmake:34 (message):
  Building USD on Windows is currently experimental.
```
Some features of USD might not work as expected.


## Alternatives

### Build Script

Provided build script in "build_scripts\build_usd.py".
The script takes a number of arguments, and tries to resolve all dependencies and download + build the required components.

Using this script greatly simplifies the build process, however it doesn't allow to provide specific libraries or modules, making it less flexible.

More details about the script are provided in ["Build Script"](TODO: link to "build_script" page)


### NVIDIA Builds

(TODO: link)
But not fully featured (missing components such as OpenEXR).


### Python modules

Can find prebuilt binaries in Pypi package
(what about the dependencies?)
https://pypi.org/project/usd-core/


----

# Build Environment

## Tools

The software used for the build are the following:
* Windows 10 (64 bits)
* Visual Studio 2019 (MSVC142)
* NASM
* Python 3
  * PySide
  * PyOpenGL

Additional tools and libraries are required by the different modules as specified in the ["Dependencies"](https://github.com/PixarAnimationStudios/USD#dependencies) section of the documentation.
The process and tools required to build each library is described in the following sections.


### Visual Studio

C and C++ compilers are required for the build, and CMake should be used for building the makefiles.

Using Visual Studio 2019 (Community Edition).

The follwoing components should be installed (from the VS Installer tool):
* Desktop development with C++
  (default packages)
  * MSVC v142
  * Windows 10 SDK v10 (latest)
  * C++ CMake tools for Windows
  * ... (TODO: others required?)
(TODO: needed? or standalone Python is enough?
* Python Development
  * Python 3.7.8 (64 bits)
)


### NASM

Required by the "Imaging" and "USD Imaging" modules.

NASM version 2.15.05 (64bits).

- Download from:
  https://www.nasm.us/
  Latest when writing this:
  https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/win64/
- Extract to:
  C:\ProgramData\nasm
- Define "NASMPATH" environment variable (must end with "\" character):
  NASMPATH=C:\ProgramData\nasm\

(? - needed?
* VSNASM
  => To use the build customisation in Visual Studio
  - Download from:
    https://github.com/ShiftMediaProject/VSNASM
    Master branch head:
    https://github.com/ShiftMediaProject/VSNASM/archive/refs/heads/master.zip
  - Extract to:
    C:\ProgramData\vsnasm
  - Add location in VS2019:
    "Tools" -> "Options..."
      "Project and Solutions" -> "VC++ Project Settings"
        "Build Customization Search Path"
(TODO: ?
usage: look at readme on github if needed)
)


### Python

Version 3.7.9 (64 bits).
...

Additionally, some libraries require Python 2.7.
More details are provided in the sections related to the libraries requiring it.


#### PySide

Required by the "USD View" module.

Version 5.15.2.

Install using PIP (run CMD as admin)
(TODO: specify version)
```
pip install PySide2
```
or
```
python.exe -m pip install PySide2
```

(TODO: remove (per info purpose, not important here)
- For offline install:
  - On computer with Internet connection:
    - Download using PIP:
      <python-path>\python.exe -m pip download -d <download-location> PySide2
    - Copy to shared location (or external device)
  - On computer without Internet connection:
    - Get access to shared location (or external device) where the downloaded files are located
    - Install using PIP (offline):
      (run CMD as admin)
      <python-path>\python.exe -m pip install PySide2 --no-index --find-links <download-location>
)

The location of the PySide binaries also needs to be added to the "PATH" environment variable (additionally to Python's install location):
```
set PATH=%PYTHON_PATH%;%PYTHON_PATH%\Scripts;%PATH%
```
If the location is not in "PATH", the build process will not find "pyside-uic.exe" and fail.


#### PyOpenGL

Aslo required by the "USD View" module.

Version 3.1.5.

Install using PIP (run CMD as admin)
(TODO: specify version)
```
pip install PyOpenGL
```
or
```
python.exe -m pip install PyOpenGL
```


## Environment

With the tools installed, additional steps are required to configure the environment for the build.
The changes to the Windows environment variable "PATH" might not be necessary depending on each individual setup.


(TODO: the paths can be different, should not hardcode...)
* Visual Studio Compiler environment
  - In a cmd, run "vcvars64.bat" from:
    C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build

* Python
  (TODO: only Python 3 or both 2& 3?)
  Add paths to Python installation and "Scripts" directory to "PATH":
  ```
  set PATH=%PYTHON_PATH%;%PYTHON_PATH%\Scripts;%PATH%
  ```
  Where "PYTHON_PATH" is the install location of Python.
  For example:
    %USERPROFILE%\AppData\Local\Programs\Python\Python37

* NASM
  Add path to NASM installation to "PATH":
  ```
  set PATH=%NASM_PATH%;%PATH%
  ```
  Where "NASM_PATH" is the install location of NASM.
  For example:
    C:\ProgramData\nasm

* PySide2 binaries
  Add paths to PySide2 binaries (essentially "pyside2-uic.exe") to "PATH":
  ```
  set PATH=%PYTHON_PATH%\Lib\site-packages;%PATH%
  ```
  Typically, PySide2 is installed in Python's "site-packages" directory.

(TODO: needed?
- PyOpenGL
  ...
)


----

# Components

(TODO: rewrite...)
The different components of the USD build, as described in the ["build documentation"](https://github.com/PixarAnimationStudios/USD/blob/release/BUILDING.md).
More details can be found in "USD-21.08\BUILDING.md".


(TODO: check correct - still valid?)
During the build process, if some dependencies are not found they will be automatically downloaded and built.
(TODO: check/list which ones)

However, some download links seem to be broken or out of date (especially some links from "SourceForge"), resulting in the process failure.
A solution is to manually download the dependencies.
- get files from "build_downloads"
- copy files to <INSTALL_PATH>/src

! - Had problems downloading files from SourceForge, needed other source.


## USD Base

### Required Components

#### Boost

Requires "Boost.Python".

Boost 1.73.0.

(TODO: link to "boost" page)
=> Same as for Alembic and OIIO?


#### Jinja2

(Python install with pip)

(TODO: more info...)


#### TBB

Intel TBB 2020 Update 2.
(TODO: link to "tbb" page)


(files reorganised as for OIIO)
Found, but warning:
(TODO: related to TBB or is it a cmake thing?)
```
-- Found TBB: C:/Users/2-REC/Documents/USD/deps/tbb/x64/Release/include (found version "2020.2") found components: tbb
CMake Deprecation Warning at cmake/defaults/Packages.cmake:204 (cmake_policy):
  The OLD behavior for policy CMP0072 will be removed from a future version
  of CMake.

  The cmake-policies(7) manual explains that the OLD behaviors of all
  policies are deprecated and that a policy should be set to OLD only under
  specific short-term circumstances.  Projects should be ported to the NEW
  behavior and not rely on setting a policy to OLD.
Call Stack (most recent call first):
  CMakeLists.txt:23 (include)
```
(TODO: OK?)


### Optional Components

#### Python

Required for Python bindings and tests.
Build USD for both Python2 and Python3.

- Python 2.7 (.16?)
- Python 3.7 (3.7.9)


## Imaging and USD Imaging

### Required Components

#### OpenSubdiv

Version 3.4.4.

(TODO: link to "opensubdiv" page)


#### NASM

See above.


### Optional Components

#### OpenEXR

Required for OpenImageIO, OpenVDB or OSL support.

Version ... 3.4?

(TODO: link to "openexr" page)
=> Same as for Alembic? (and what about OIIO? OCIO?)


#### OpenImageIO

(debug lib name might have "_d" suffix => fix)

(TODO: link to "oiio" page)

In debug, lib has suffix "_d", not expected by USD.
=> changes (add "_d" suffix when "debug") in:
  USD-21.08\cmake\modules\FindOpenImageIO.cmake
(TODO: shouldn't it be automatic in Windows?)


#### OpenColorIO

(TODO: link to "ocio" page)

The library has version suffix, not expected by USD.
=> changes (add version suffix if not found) in:
  USD-21.08\cmake\modules\FindOpenColorIO.cmake
(windows only?)


#### OSL (OpenShadingLanguage)

****************************************************************************************************
(TODO: link to "osl" page)
TODO: EVERYTHING!!!!
https://github.com/AcademySoftwareFoundation/OpenShadingLanguage

=> Optional (untested Windows?)
https://github.com/AcademySoftwareFoundation/OpenShadingLanguage/blob/master/INSTALL.md
  => Not used?
    'In the (not-too-distant) future, it will contain "oso" files that provide OSL implementations of the Usd* shaders.'
    https://graphics.pixar.com/usd/docs/api/usd_shaders_page_front.html
****************************************************************************************************


### Ptex

(TODO: link to "ptex" page)


If building with static libraries, the process will raise linking errors such as:
```
ptexTextureObject.obj : error LNK2019: unresolved external symbol
 "__declspec(dllimport) public: static class Ptex::v2_3::PtexCache * __cdecl Ptex::v2_3::PtexCache::create(int,unsigned __int64,bool,class Ptex::v2_3::PtexInputHandler *,class Ptex::v2_3::PtexErrorHandler *)"
 (__imp_?create@PtexCache@v2_3@Ptex@@SAPEAV123@H_K_NPEAVPtexInputHandler@23@PEAVPtexErrorHandler@23@@Z)
 referenced in function "protected: virtual void __cdecl pxrInternal_v0_21__pxrReserved__::HdStPtexTextureObject::_Load(void)" (?_Load@HdStPtexTextureObject@pxrInternal_v0_21__pxrReserved__@@MEAAXXZ)
 [...\build\pxr\imaging\hdSt\hdSt.vcxproj]
```
(TODO: find way to specify use of static libraries)

Using the shared libraries removes the error and allow the build process to continue.


## USD View

### Required Components

#### PySide

PySide or PySide2.
See above.


#### PyOpenGL

See above.


----

# Additional libraries

The build process will download and build the required libraries.
(TODO: or build manually? how to provide?)


## Zlib

(TODO: link to OIIO/zlib?)



## Plugins

USD also supports various [3rd party plugins](https://graphics.pixar.com/usd/docs/USD-3rd-Party-Plugins.html).


### Alembic

Version 1.7.16.

(TODO: link to "alembic" page)


### Draco

(TODO)


### MaterialX

(TODO)


### Maya

(TODO)
(TODO: check links:
- How to build maya USD
  => Two great sources on how to build the Pixar and Animal Logic USD plugins for Maya.
  https://discourse.techart.online/t/how-to-build-usd/12227
  (outdated?)
  + CHECK THE COOKBOOK!
    https://discourse.techart.online/t/how-to-build-usd/12227
+
https://polycount.com/discussion/210698/building-pixars-usd-for-maya
)


### Katana

(TODO)


### Houdini

(TODO)


### RenderMan

(TODO)


### Metal

For MacOS builds, not relevant here.


### Vulkan

for 'hgiVulkan'?
(PXR_BUILD_GPU_SUPPORT or PXR_ENABLE_VULKAN_SUPPORT is OFF)




----

# BUILD

## Configuration

(TODO: rephrase)
Components can be included or omitted from the build process depending on needs.
The different configuration flags are:

```
Building                      Shared|static libraries
  Config                      Release|Debug
  Imaging                     On|Off
    Ptex support:             On|Off
    OpenVDB support:          On|Off
    OpenImageIO support:      On|Off
    OpenColorIO support:      On|Off
    PRMan support:            On|Off
  UsdImaging                  On|Off
    usdview:                  On|Off
  Python support              On|Off
    Python 3:                 On|Off
  Documentation               On|Off
  Tests                       On|Off
  Examples                    On|Off
  Tutorials                   On|Off
  Tools                       On|Off
  Alembic Plugin              On|Off
    HDF5 support:             On|Off
  Draco Plugin                On|Off
  MaterialX Plugin            On|Off

Dependencies
  zlib
  boost
  TBB
  OpenSubdiv
  PyOpenGL
```
)


### Configuration Options

(TODO: rephrase)
List of configuration options that can be provided to CMake.

(TODO: How to set:
- 32 vs 64 bits?
  (might not have 32 bits?)
- Debug or release:
  --debug (default: Release)?
)


Python support:
```
PXR_ENABLE_PYTHON_SUPPORT=ON|OFF
  # If "ON":
    PXR_USE_PYTHON_3=ON|OFF
    PYTHON_EXECUTABLE="{pyExecPath}"
    PYTHON_LIBRARY="{pyLibPath}"
    PYTHON_INCLUDE_DIR="{pyIncPath}"
```

Shared or static build:
```
BUILD_SHARED_LIBS=ON|OFF
  # If "ON":
    PXR_BUILD_MONOLITHIC=ON|OFF
```

If debug:
```
TBB_USE_DEBUG_BUILD=ON|OFF
```
(Should have the same value as the USD build type release/debug)

Safety build:
```
PXR_PREFER_SAFETY_OVER_SPEED=ON|OFF
```

Extras (doc, tests, etc.):
```
PXR_BUILD_DOCUMENTATION=ON|OFF
PXR_BUILD_TESTS=ON|OFF
PXR_BUILD_EXAMPLES=ON|OFF
PXR_BUILD_TUTORIALS=ON|OFF
PXR_BUILD_USD_TOOLS=ON|OFF
```

Imaging:
```
PXR_BUILD_IMAGING=ON|OFF
  # If "ON":
    PXR_ENABLE_PTEX_SUPPORT=ON|OFF
    PXR_ENABLE_OPENVDB_SUPPORT=ON|OFF

    # Plugins:
      PXR_BUILD_EMBREE_PLUGIN=ON|OFF
      PXR_BUILD_PRMAN_PLUGIN=ON|OFF
        # If "ON":
          RENDERMAN_LOCATION="{location}"
      PXR_BUILD_OPENIMAGEIO_PLUGIN=ON|OFF
      PXR_BUILD_OPENCOLORIO_PLUGIN=ON|OFF
```

USD Imaging:
```
PXR_BUILD_USD_IMAGING=ON|OFF
```

USD View:
```
PXR_BUILD_USDVIEW=ON|OFF
```

Plugins:
```
PXR_BUILD_ALEMBIC_PLUGIN=ON|OFF
  # If "ON":
    PXR_ENABLE_HDF5_SUPPORT=ON|OFF
      # If "ON":
        HDF5_ROOT="{instDir}"
PXR_BUILD_DRACO_PLUGIN=ON|OFF
  # If "ON":
    DRACO_ROOT="{}"
PXR_ENABLE_MATERIALX_SUPPORT=ON|OFF
```


(TODO: check required/used)
To make sure to use Boost installed by the build script and not any system installed boost
```
Boost_NO_BOOST_CMAKE=On
Boost_NO_SYSTEM_PATHS=True
```


!! (specific windows)
(TODO: check required/used)
```
CMAKE_CXX_FLAGS="/Zm150"
```


----

### Tests

(TODO: see which tests should make)
-- Skipping validation of gf generated code because PXR_VALIDATE_GENERATED_CODE=OFF
-- Skipping validation of sdf generated code because PXR_VALIDATE_GENERATED_CODE=OFF
-- Skipping alembic-based usddiff tests because PXR_BUILD_ALEMBIC_PLUGIN=OFF
-- Skipping Draco-based usddiff tests because PXR_BUILD_DRACO_PLUGIN=OFF
-- Skipping usdedit tests, could not find sed command.


----

## Build

(TODO: details + link to script)


## Warnings

(TODO: move below?)

Error during build, but seems normal, to be ignored:
```
TestPlugDsoUnloadable.obj : error LNK2019: unresolved external symbol
 "int __cdecl Unresolved_external_symbol_error_is_expected_Please_ignore(void)" (?Unresolved_external_symbol_error_is_expected_Please_ignore@@YAHXZ)
 referenced in function "void __cdecl pxrInternal_v0_21__pxrReserved__::`dynamic initializer for 'something''(void)" (??__Esomething@pxrInternal_v0_21__pxrReserved__@@YAXXZ)
 [...\build\pxr\base\plug\TestPlugDsoUnloadable.vcxproj]
...\build\pxr\base\plug\Release\TestPlugDsoUnloadable.dll : warning LNK4088: image being generated due to /FORCE option; image may not run [...\build\pxr\base\plug\TestPlugDsoUnloadable.vcxproj]
```

----

# RUN

SET PATHS! (for each dll: opensubdiv, tbb, boost, ptex?, zlib)
+ python (PyOpenGL, PySide2)
+ ADD runtime libs


## Runtime Errors

```
ERROR: Usdview encountered an error while rendering.No module named 'OpenGL'
```
=> Need PyOpenGL


-------------

!!!!
- Python Versions and DCC Plugins:
Some DCCs (most notably, Maya) may ship with and run using their own version of
Python. In that case, it is important that USD and the plugins for that DCC are
built using the DCC's version of Python and not the system version. This can be
done by running build_usd.py using the DCC's version of Python.
!!!!
=> Build DCC plugins on machine with DCC installed.
(eg: for Maya, can use 'mayapy')

