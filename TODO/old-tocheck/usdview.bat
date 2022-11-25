:: Example script to start USD View with an sample file

:: Set NVIDIA USD directory here
set USD_PATH=E:\USD\install\x64\Release


REM set PATH=%USD_PATH%\lib;%USD_PATH%\bin;%PATH%
set PATH=%USD_PATH%\lib;%USD_PATH%\bin;%PATH%
set PATH=E:\USD\deps\tbb\x64\Release\lib;%PATH%
set PATH=E:\boost\boost_src\stage\lib;%PATH%
set PATH=E:\USD\deps\ptex\x64\Release\bin;%PATH%
set PATH=Z:\shared_folder\usd\usd_TODO\temp;%PATH%

set PYTHONPATH=%USD_PATH%\lib\python

REM - TODO: to remove (& install PyQt in Python 3.9)
:: PyQt is required (currently only installed in Python 3.6)
set PATH=%USERPROFILE%\AppData\Local\Programs\Python\Python37;%USERPROFILE%\AppData\Local\Programs\Python\Python37\Scripts;%PATH%

echo PATH: %PATH%


REM set PXR_USD_WINDOWS_DLL_PATH=%USD_PATH%\lib

REM %USD_PATH%\bin\usdview.cmd test.usd
%USD_PATH%\bin\usdview.cmd
