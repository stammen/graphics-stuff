@echo off
set ARGS=-DBUILD_DEMOS:BOOL="0" -DBUILD_SHARED:BOOL="0"
set CMAKE10="c:\CMake10\bin\cmake.exe"
set SOURCE_DIR=Chipmunk-6.2.2

pushd %SOURCE_DIR%
	if exist bin (
		rm -rf bin
	)
	mkdir bin
	cd bin
	mkdir Windows_10
	cd Windows_10
	mkdir arm
	mkdir x86
	cd arm
	set INSTALL=%CD%\install 
	%CMAKE10% -G"Visual Studio 14 2015 ARM" -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DCMAKE_INSTALL_PREFIX:PATH=%INSTALL% %ARGS% ../../../
	cd ..\
	cd x86
	set INSTALL=%CD%\install 
	%CMAKE10% -G"Visual Studio 14 2015" -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 -DCMAKE_INSTALL_PREFIX:PATH=%INSTALL% %ARGS%  ../../../
popd


echo./*
echo. * Check VC++ environment...
echo. */
echo.

set FOUND_VC=0

if defined VS140COMNTOOLS (
    set VSTOOLS="%VS140COMNTOOLS%"
    set FOUND_VC=1
)

set VSTOOLS=%VSTOOLS:"=%
set "VSTOOLS=%VSTOOLS:\=/%"

set VSVARS="%VSTOOLS%vsvars32.bat"

if not defined VSVARS (
    echo Can't find VC2015 installed!
    goto ERROR
)


echo./*
echo. * Building freetype...
echo. */
echo.


call %VSVARS%
if %FOUND_VC%==1 (
	msbuild %SOURCE_DIR%\bin\Windows_10\x86\INSTALL.vcxproj /p:ForceImportBeforeCppTargets=%cd%\winrt.props /p:Configuration="Release" /p:Platform="Win32"
	msbuild %SOURCE_DIR%\bin\Windows_10\arm\INSTALL.vcxproj /p:ForceImportBeforeCppTargets=%cd%\winrt.props /p:Configuration="Release" /p:Platform="ARM"
) else (
    echo Script error.
    goto ERROR
)

goto EOF

:ERROR

:EOF