@echo off
setlocal enabledelayedexpansion

set BUILD_TYPE=Debug
set ARCH=x64
REM set BUILD_SHARED_LIBS=OFF

REM - TODO: find way to automate (dir with lib name (parent dir) in it?
set LIB_DIR=USD-21.08
set LIB_PATH=%cd%

:: Python
set PYTHON=ON
set PYTHON3=ON
REM set PYTHON_PATH=C:\Program Files (x86)\Microsoft Visual Studio\Shared\Python37_64
set PYTHON_PATH=%USERPROFILE%\AppData\Local\Programs\Python\Python37




set LIB_SRC_PATH=%LIB_PATH%\%LIB_DIR%
set BUILD_PATH=%LIB_PATH%\build
set INSTALL_PATH=%LIB_PATH%\install\%ARCH%\%BUILD_TYPE%


:: Third party libraries paths.
set DEPS_PATH=%LIB_PATH:\=/%/deps
:: ! - Each one needs to be set independently!
REM - TODO: get from input arguments and set defaults if not set
:: Boost (required)
REM set BOOST_PATH=%USERPROFILE:\=/%/Documents/boost/boost_src
set BOOST_PATH=e:/boost/boost_src
:: TBB (optional)
set TBB_PATH=%DEPS_PATH%/tbb/%ARCH%/%BUILD_TYPE%
:: OpenSubdiv
set OSD_PATH=%DEPS_PATH%/opensubdiv/%ARCH%/%BUILD_TYPE%
:: PTEX
set PTEX_PATH=%DEPS_PATH%/ptex/%ARCH%/%BUILD_TYPE%


if "%LIB_DIR%" == "" (
    echo 'LIB_DIR' is not set!
    pause
    exit /b
)


echo Build path: %BUILD_PATH%
if not exist %BUILD_PATH% (
    mkdir %BUILD_PATH%
)
cd %BUILD_PATH%


:: Set default build configuration Release|64 (if not set)
if not "%ARCH%" == "Win32" (
    set ARCH=x64
)
if not "%BUILD_TYPE%" == "Debug" (
    set BUILD_TYPE=Release
)

:: Build Options
set "BUILD_OPTIONS="

if not "%BUILD_SHARED_LIBS%" == "" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DBUILD_SHARED_LIBS=%BUILD_SHARED_LIBS%
)


if "%PYTHON%" == "ON" (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DPXR_ENABLE_PYTHON_SUPPORT=ON
    set BUILD_OPTIONS=!BUILD_OPTIONS! -DPXR_USE_PYTHON_3=%PYTHON3%
    REM if "%PYTHON3%" == "ON" (
        REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DPython3_ROOT="%PYTHON_PATH%"
    REM ) else (
        REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DPython2_ROOT="%PYTHON_PATH%"
    REM )

    REM - TODO: no need to set variables, will be set if python is found
    REM - TODO: exec could have a different name than "python.exe"!
    REM - TODO: handle debug (?)
    REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DPYTHON_EXECUTABLE="%PYTHON_PATH%/python.exe"
    REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DPYTHON_LIBRARY="%PYTHON_PATH%/Lib"
    REM set BUILD_OPTIONS=!BUILD_OPTIONS! -DPYTHON_INCLUDE_DIR="%PYTHON_PATH%/include"
) else (
    set BUILD_OPTIONS=%BUILD_OPTIONS% -DPXR_ENABLE_PYTHON_SUPPORT=OFF
)

REM - TODO: Add 'else' cases to set libraries to 'OFF'
REM - TODO: ADAPT FOR EACH CASE WITH STATIC/SHARED + DEBUG/RELEASE LIBRARIES!
set BUILD_OPTIONS=%BUILD_OPTIONS% -DBOOST_ROOT="%BOOST_PATH%"
set BUILD_OPTIONS=%BUILD_OPTIONS% -DTBB_ROOT="%TBB_PATH%"
set BUILD_OPTIONS=%BUILD_OPTIONS% -DOpenSubdiv_ROOT="%OSD_PATH%"
set BUILD_OPTIONS=%BUILD_OPTIONS% -DPTex_ROOT="%PTEX_PATH%"


REM - TODO: get path from input argument
if "%VCVARS_PATH%" == "" (
    set VCVARS_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build"
)
:: ~Hack to remove quotes (will be added later)
set VCVARS_PATH=%VCVARS_PATH:"=%

if "%ARCH%" == "x64" (
    set VCVARS=vcvars64.bat
) else (
    set VCVARS=vcvars32.bat
)


:: Initialise VC environment
call "%VCVARS_PATH%\%VCVARS%"

REM - TODO: should be in "if python" block?
:: Force specified Python to be executed (as first in PATH)
:: ('Scripts' directory for 'pyside-uic.exe'
set PATH=%PYTHON_PATH%;%PYTHON_PATH%\Scripts;%PATH%

echo Build Options: %BUILD_OPTIONS%

echo.
echo Configure
cmake -G "Visual Studio 16 2019" -A %ARCH% ^
 -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
 -DCMAKE_INSTALL_PREFIX="%INSTALL_PATH%" ^
 %BUILD_OPTIONS% ^
 "%LIB_SRC_PATH%"

REM - TODO: add check for error

echo.
echo Build
cmake --build . --target install --config %BUILD_TYPE%

pause
exit /b