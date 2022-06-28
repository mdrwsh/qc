@echo off
setlocal enableDelayedExpansion
if "%1" == "" echo no input file specified. & exit/b
if not exist "%~1" echo the file specified does not exist. & exit/b
set file="%~1"
set filetype="%~x1"
set filedebug="%~1.temp"
cls

:main
set errorcode=0
set filesize=%~z1
timeout 2 /nobreak >nul
rem TODO: interpreted program needs some sort of error-checker (.py .bat)

if !filesize! neq %~z1 (
  if !filetype! == ".py" (
    (python !file!) >!filedebug! 2>&1
    set errorcode=!errorlevel!
  ) else if !filetype! == ".c" (
    (gcc !file!) >!filedebug! 2>&1
    set errorcode=!errorlevel!
  ) else if !filetype! == ".cpp" (
    (g++ !file!) >!filedebug! 2>&1
    set errorcode=!errorlevel!
  ) else if !filetype! == ".rs" (
    (rustc !file!) >!filedebug! 2>&1
    set errorcode=!errorlevel!
  ) else if !filetype! == ".bat" (
    (!file!) >!filedebug! 2>&1
    set errorcode=!errorlevel!
  ) else if !filetype! == ".box" (
    (call box -c !file!) >!filedebug! 2>&1
    set errorcode=!errorlevel!
  ) else echo !filetype! is not supported & exit/b
  if !errorcode! == 0 (
    cls
    echo No errors.
  ) else (
    cls
    type !filedebug!
  )
)
goto main
