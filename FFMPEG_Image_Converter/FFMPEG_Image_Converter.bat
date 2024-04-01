@ECHO OFF
Set workingPath=NULL
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
TITLE FFMPEG_Image_Converter

:ROOT
cls

ECHO FFMPEG Image Convertor: ROOT MENU
ECHO[
ECHO Working Path:
ECHO %workingPath%
ECHO[
ECHO F. Change the working path ^(folder^)
ECHO[
ECHO D. Check for duplicate hashes in files
ECHO E. List extensions in the folder
ECHO[
ECHO 1. Convert webp to png
ECHO 2. Convert avif to png
ECHO 3. Convert jpg to png
ECHO 4. Convert jpeg to png
ECHO 5. Convert bmp to png
ECHO 6. Convert tif to png
ECHO 7. Convert tiff to png
ECHO 8. Convert heic to png
ECHO 9. Convert jfif to png
ECHO[
ECHO P. Convert all 8 types to png
ECHO[
ECHO exit = exit this batch
ECHO[

Set Choice=
Set /P Choice=Type the choice and press enter: 

IF /I "%Choice%"=="EXIT" goto endOfLine

IF /I "%Choice%"=="f" goto getWorkingPath

IF /I "%Choice%"=="d" goto checkWorkingPath
IF /I "%Choice%"=="e" goto checkWorkingPath

IF /I "%Choice%"=="1" goto checkWorkingPath
IF /I "%Choice%"=="2" goto checkWorkingPath
IF /I "%Choice%"=="3" goto checkWorkingPath
IF /I "%Choice%"=="4" goto checkWorkingPath
IF /I "%Choice%"=="5" goto checkWorkingPath
IF /I "%Choice%"=="6" goto checkWorkingPath
IF /I "%Choice%"=="7" goto checkWorkingPath
IF /I "%Choice%"=="8" goto checkWorkingPath
IF /I "%Choice%"=="9" goto checkWorkingPath

IF /I "%Choice%"=="p" goto checkWorkingPath

ECHO[
ECHO "%Choice%" is invalid. Please try again.
ECHO[
PAUSE
GOTO ROOT

:checkWorkingPath

IF /I "%workingPath%"=="NULL" goto askForWorkingPath
IF /I "%workingPath%"=="" goto askForWorkingPath

IF /I "%Choice%"=="d" goto checkForDuplicates
IF /I "%Choice%"=="e" goto listExtensions


IF /I "%Choice%"=="1" goto convert1
IF /I "%Choice%"=="2" goto convert2
IF /I "%Choice%"=="3" goto convert3
IF /I "%Choice%"=="4" goto convert4
IF /I "%Choice%"=="5" goto convert5
IF /I "%Choice%"=="6" goto convert6
IF /I "%Choice%"=="7" goto convert7
IF /I "%Choice%"=="8" goto convert8
IF /I "%Choice%"=="9" goto convert9

IF /I "%Choice%"=="p" goto convertAll


:askForWorkingPath
cls
ECHO FFMPEG Image Convertor: Change the working path
ECHO[
ECHO Please provide the working path ^(folder^) first.
ECHO[
PAUSE

:getWorkingPath
cls
ECHO FFMPEG Image Convertor: Change the working path
ECHO[
ECHO Please type or paste in the full path to the folder, without quotes
ECHO x/cancel = cancel, exit = exit batch
ECHO[

Set /P askPath=: 

IF /I "%askPath%"=="EXIT" goto endOfLine
IF /I "%askPath%"=="x" GOTO ROOT
IF /I "%askPath%"=="cancel" GOTO ROOT

IF Not Exist "%askPath%\*" (
  ECHO[
  ECHO The path provided is not a folder. Please try again.
  ECHO[
  PAUSE
  GOTO getWorkingPath
)

Set workingPath=%askPath%
GOTO ROOT

:checkForDuplicates
ECHO[
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "duplicates" "null"
ECHO[
PAUSE
GOTO ROOT

:listExtensions
ECHO[
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "extensions" "null"
ECHO[
PAUSE
GOTO ROOT

:convert1
ECHO[
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "webp" "png"
Set ext=webp
GOTO afterVbscriptConvert

:convert2
ECHO[
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "avif" "png"
Set ext=avif
GOTO afterVbscriptConvert

:convert3
ECHO[
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "jpg" "png"
Set ext=jpg
GOTO afterVbscriptConvert

:convert4
ECHO[
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "jpeg" "png"
Set ext=jpeg
GOTO afterVbscriptConvert

:convert5
ECHO[
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "bmp" "png"
Set ext=bmp
GOTO afterVbscriptConvert

:convert6
ECHO[
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "tif" "png"
Set ext=tif
GOTO afterVbscriptConvert

:convert7
ECHO[
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "tiff" "png"
Set ext=tiff
GOTO afterVbscriptConvert

:convert8
ECHO[
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "heic" "png"
Set ext=heic
GOTO afterVbscriptConvert

:convert9
ECHO[
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "jfif" "png"
Set ext=jfif
GOTO afterVbscriptConvert

:convertAll
ECHO[
IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat">NUL
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "all" "png"
Set ext=all
GOTO afterVbscriptConvert



:afterVbscriptConvert
ECHO[

IF EXIST "ConvertImages.bat" CALL "ConvertImages.bat"
REM start notepad.exe ConvertImages.bat

PAUSE
cscript //NOLOGO FFMPEG_Image_Converter_Batch_Maker.vbs "%workingPath%" "all" "check:png"

IF EXIST "ConvertImages.bat" DEL "ConvertImages.bat"

ECHO[
PAUSE
TITLE FFMPEG_Image_Converter
GOTO ROOT



:endOfLine
Set Choice=
Set askPath=
Set workingPath=


