@ECHO OFF

IF NOT EXIST "embedding_loss.vbs" (
  ECHO[
  ECHO File does not exist, or this batch was ran from another folder:
  ECHO embedding_loss.vbs
  ECHO[
  PAUSE
  GOTO endOfLine
)

IF NOT EXIST "inspect_embedding_training.py" (
  ECHO[
  ECHO File does not exist, or this batch was ran from another folder:
  ECHO inspect_embedding_training.py
  ECHO[
  PAUSE
  GOTO endOfLine
)


Set folderPath=NULL


:ROOT
Set afterFolderAsk=ROOT
cls
ECHO[
ECHO show loss / inspect training -^> ROOT MENU
ECHO[
ECHO log folder:
ECHO %folderPath%
ECHO[
ECHO f. Set/change the log folder where training data is
ECHO[
ECHO 1. Show Loss (find loss values below threshold)
ECHO 2. Create Graphs
ECHO 3. Inspect Training (strength values over 0.2 may mean overtrained)
ECHO[

Set Choice=
Set /p Choice=Type the option and press enter (exit to quit): 

IF /I "%Choice%"=="exit" GOTO endOfLine

IF /I "%Choice%"=="f" GOTO rootGetFolderPath
IF /I "%Choice%"=="1" GOTO showLoss
IF /I "%Choice%"=="2" GOTO createGraphs
IF /I "%Choice%"=="3" GOTO inspectTraining


ECHO[
ECHO "%Choice%" is invalid. Please try again.
ECHO[
PAUSE

GOTO ROOT


:rootGetFolderPath
cls
ECHO[
ECHO show loss / inspect training -^> GET LOG FOLDER PATH
ECHO[
ECHO Enter the full path to the log folder and press enter.
ECHO      ^*^*^*^*^* make sure there are no double-quotes! ^*^*^*^*^*
ECHO           enter x or ROOT to go to ROOT MENU
ECHO           enter exit to go to quit
ECHO[

Set /P Choice=: 

IF /I "%Choice%"=="x" GOTO ROOT
IF /I "%Choice%"=="root" GOTO ROOT
IF /I "%Choice%"=="exit" GOTO endOfLine

IF NOT EXIST "%Choice%\" GOTO rootNoFolder

IF NOT EXIST "%Choice%\textual_inversion_loss.csv" GOTO rootNoFile

Set folderPath=%Choice%
Set Choice=

GOTO %afterFolderAsk%

:rootNoFolder
ECHO[
ECHO ERROR: Folder does not exist, or it is not available:
ECHO %Choice%
Set Choice=
ECHO[
PAUSE
GOTO rootGetFolderPath

:rootNoFile
ECHO[
ECHO ERROR: The file, "textual_inversion_loss.csv" was not found in provided folder, or it is not available:
ECHO %Choice%
Set Choice=
ECHO[
PAUSE
GOTO rootGetFolderPath

REM *****************************************************************************

REM ***** SHOW LOSS *****
:showLoss
Set afterFolderAsk=showLoss
cls
ECHO[
ECHO show loss / inspect training -^> SHOW LOSS -^> ASK FOR THRESHOLD
ECHO[
ECHO log folder:
ECHO %folderPath%
ECHO[



IF /I "%folderPath%"=="NULL" GOTO rootGetFolderPath
IF "%folderPath%"=="" GOTO rootGetFolderPath

CLS
:showLossAskThreshold
cls
ECHO[
ECHO show loss / inspect training -^> SHOW LOSS -^> ASK FOR THRESHOLD
ECHO[
ECHO log folder:
ECHO %folderPath%
ECHO[
ECHO The default threshold is 0.06 loss, and the output will only show numbers below that.
ECHO type 'y' or to continue. Type a number to change the threshold.
ECHO      ^*^*^*^*^* press enter for the default or enter or a number! nothing else ^*^*^*^*^*
ECHO      ^*^*^*^*^* the number can be an integer, or have a decimal. examples:
ECHO                 0.08, 1, 0.03 (only enter one value)
ECHO           enter x to go to ROOT MENU
ECHO           enter exit to go to quit
ECHO[

Set var=
Set /P var=: 

IF /I "%var%"=="" GOTO showLossAskThresholdUseDefault

IF /I "%var%"=="x" GOTO ROOT
IF /I "%var%"=="exit" GOTO endOfLine

Set valid=true

for /f "delims=0123456789." %%i in ("%var%") do (
  set valid=false
)

If Not %valid% equ true (
  ECHO[
  ECHO "%var%" is not valid. Please try again.
  ECHO[
  PAUSE
  GOTO showLossAskThreshold
)

GOTO showLossAskRunNow

:showLossAskThresholdUseDefault
Set var=0.06

:showLossAskRunNow
ECHO[

cscript //NOLOGO embedding_loss.vbs "%folderPath%\textual_inversion_loss.csv" "%var%"

Set var=

ECHO[
PAUSE
GOTO ROOT

REM *****************************************************************************

REM ***** CREATE GRAPHS *****

:createGraphs
Set afterFolderAsk=createGraphs
cls
ECHO[
ECHO show loss / inspect training -^> CREATE GRAPHS
ECHO[
ECHO log folder:
ECHO %folderPath%

SET afterFolderAsk=createGraphs

IF /I "%folderPath%"=="NULL" GOTO rootGetFolderPath
IF "%folderPath%"=="" GOTO rootGetFolderPath

ECHO[
ECHO Working...

copy "inspect_embedding_training.py" "%folderPath%\inspect_embedding_training.py" /Y

@ECHO ON
python.exe "%folderPath%\inspect_embedding_training.py"

@ECHO OFF
DEL "%folderPath%\inspect_embedding_training.py" /F /Q
ECHO[
ECHO[
PAUSE

goto ROOT


REM *****************************************************************************

REM ***** INSPECT TRAINING *****

:inspectTraining
cls
Set afterFolderAsk=inspectTraining
ECHO[
ECHO show loss / inspect training -^> INSPECT TRAINING
ECHO[
ECHO log folder:
ECHO %folderPath%

SET afterFolderAsk=inspectTraining

IF /I "%folderPath%"=="NULL" GOTO rootGetFolderPath
IF "%folderPath%"=="" GOTO rootGetFolderPath


ECHO[
ECHO Working...
@ECHO ON
python.exe "inspect_embedding_training.py" --folder "%folderPath%\Embeddings"

@ECHO OFF
ECHO[
ECHO[
PAUSE

goto ROOT


:endOfLine
SET Choice=
SET folderPath=
SET var=
SET valid=
SET count=
SET afterFolderAsk=
@ECHO ON
