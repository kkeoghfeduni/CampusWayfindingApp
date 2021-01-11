:: ===== SETUP =====
@echo off
CLS
echo Starting SVG conversion...
echo.

:: setup working directory (if different)
REM set "_work_dir=%~dp0"
set "_work_dir=%CD%"

:: setup counter
set "count=1"

:: setup file search and save string
set "_work_x1=pdf"
set "_work_x2=svg"
set "_work_file_str=*.%_work_x1%"

:: setup inkscape commands
set "_inkscape_path=B:\pdf2geoJason\inkscape\"
set "_inkscape_cmd=%_inkscape_path%inkscape.exe"

:: ===== FIND FILES IN WORKING DIRECTORY =====
:: Output from DIR last element is single  carriage return character. 
:: Carriage return characters are directly removed after percent expansion, 
:: but not with delayed expansion.

pushd "%_work_dir%"
FOR /f "tokens=*" %%A IN ('DIR /A:-D /O:N /B %_work_file_str%') DO (
    CALL :subroutine "%%A"
)
popd

:: ===== CONVERT PDF TO SVG WITH INKSCAPE =====

:subroutine
echo.
IF NOT [%1]==[] (

    echo %count%:%1
    set /A count+=1

    start "" /D "%_work_dir%" /W "%_inkscape_cmd%" --without-gui --file="%~n1.%_work_x1%" --export-dpi=300 --export-plain-svg="%~n1.%_work_x2%"

) ELSE (
    echo End of output
)
echo.

GOTO :eof

:: ===== INKSCAPE REFERENCE =====

:: print inkscape help
REM "%_inkscape_cmd%" --help > "%~dp0\inkscape_help.txt"
REM "%_inkscape_cmd%" --verb-list > "%~dp0\inkscape_verb_list.txt"