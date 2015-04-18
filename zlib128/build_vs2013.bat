@echo off
set ARGS=-""

set SOURCE_DIR=zlib-1.2.8

pushd %SOURCE_DIR%
	set SRC=%CD%
	rmdir /s /q bin
	mkdir bin
	pushd bin
		mkdir WindowsPhone_8.1
		pushd WindowsPhone_8.1
			mkdir arm
			mkdir win32
			pushd arm
				set INSTALL=%CD%\install
				cmake -G"Visual Studio 12 2013 ARM" -DCMAKE_SYSTEM_NAME=WindowsPhone -DCMAKE_SYSTEM_VERSION=8.1 -DCMAKE_INSTALL_PREFIX:PATH=%INSTALL% %ARGS% %SRC%
			popd
			pushd win32
				set INSTALL=%CD%\install
				cmake -G"Visual Studio 12 2013" -DCMAKE_SYSTEM_NAME=WindowsPhone -DCMAKE_SYSTEM_VERSION=8.1 -DCMAKE_INSTALL_PREFIX:PATH=%INSTALL% %ARGS% %SRC%
			popd
		popd
		mkdir WindowsStore_8.1
		pushd WindowsStore_8.1
			mkdir arm
			mkdir win32
			pushd arm
				set INSTALL=%CD%\install
				cmake -G"Visual Studio 12 2013 ARM" -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=8.1 -DCMAKE_INSTALL_PREFIX:PATH=%INSTALL% %ARGS% %SRC%
			popd
			pushd win32
				set INSTALL=%CD%\install
				cmake -G"Visual Studio 12 2013" -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=8.1 -DCMAKE_INSTALL_PREFIX:PATH=%INSTALL% %ARGS% %SRC%
			popd
		popd
	popd
popd


echo./*
echo. * Check VC++ environment...
echo. */
echo.

set FOUND_VC=0

if defined VS120COMNTOOLS (
    set VSTOOLS="%VS120COMNTOOLS%"
    set VC_VER=120
    set FOUND_VC=1
) 

set VSTOOLS=%VSTOOLS:"=%
set "VSTOOLS=%VSTOOLS:\=/%"

set VSVARS="%VSTOOLS%vsvars32.bat"

if not defined VSVARS (
    echo Can't find VC2013 installed!
    goto ERROR
)


echo./*
echo. * Building %SOURCE_DIR%..
echo. */
echo.


call %VSVARS%
if %FOUND_VC%==1 (

    msbuild  %SOURCE_DIR%\bin\WindowsPhone_8.1\win32\INSTALL.vcxproj /p:Configuration="MinSizeRel"  /p:Platform="Win32" /p:ForceImportBeforeCppTargets=%cd%\winrt.props /m
    msbuild  %SOURCE_DIR%\bin\WindowsPhone_8.1\arm\INSTALL.vcxproj /p:Configuration="MinSizeRel"  /p:Platform="ARM" /p:ForceImportBeforeCppTargets=%cd%\winrt.props /m
    msbuild  %SOURCE_DIR%\bin\WindowsStore_8.1\win32\INSTALL.vcxproj /p:Configuration="MinSizeRel"  /p:Platform="Win32" /p:ForceImportBeforeCppTargets=%cd%\winrt.props /m
    msbuild  %SOURCE_DIR%\bin\WindowsStore_8.1\arm\INSTALL.vcxproj /p:Configuration="MinSizeRel"  /p:Platform="ARM" /p:ForceImportBeforeCppTargets=%cd%\winrt.props /m

) else (
    echo Script error.
    goto ERROR
)


goto EOF

:ERROR

:EOF
