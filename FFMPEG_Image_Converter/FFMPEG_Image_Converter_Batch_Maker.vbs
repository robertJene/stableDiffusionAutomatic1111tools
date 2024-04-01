' VBScript to convert image files to a different format using FFmpeg

' Check if the required command line arguments are provided
If WScript.Arguments.Count <> 3 Then
    WScript.Echo()
    WScript.Echo "Usage: cscript ConvertImages.vbs <workingPath> <sourceExtension> <destinationExtension>"
    WScript.Echo "~this script should be called from FFMPEG_Image_Converter.bat"
    WScript.Echo()
    WScript.Quit
End If

Dim fileSys, WshShell, currentDirectory

' Check if the workingPath folder exists
Set fileSys = CreateObject("Scripting.FileSystemObject")

Set WshShell = WScript.CreateObject("WScript.Shell")
currentDirectory = WshShell.CurrentDirectory


If WScript.Arguments(1) = "duplicates" And WScript.Arguments(2) = "null" Then
  Dim oMD5:  Set oMD5 = CreateObject("System.Security.Cryptography.MD5CryptoServiceProvider")
  checkForDuplicates(WScript.Arguments(0))
  wscript.Quit
End If

If WScript.Arguments(1) = "extensions" And WScript.Arguments(2) = "null" Then
  listFileExtensions(WScript.Arguments(0))
  wscript.Quit
End If


Dim workingPath, sourceExtension, destinationExtension

' Get the command line arguments
workingPath = WScript.Arguments(0)
sourceExtension = WScript.Arguments(1)
destinationExtension = WScript.Arguments(2)


Dim extensionList

If sourceExtension = "all" And instr(destinationExtension, "png") Then

  Set extensionList = CreateObject("System.Collections.ArrayList")

  extensionList.Add "webp"
  extensionList.Add "avif"
  extensionList.Add "jpg"
  extensionList.Add "jpeg"
  extensionList.Add "bmp"
  extensionList.Add "tif"
  extensionList.Add "tiff"
  extensionList.Add "heic"
  extensionList.Add "jfif"

Else

  extensionList.Add sourceExtension

End If


If destinationExtension = "check:png" Then
  listTheFailures()
  wscript.quit
End If




If Not fileSys.FolderExists(workingPath) Then
    WScript.Echo()
    WScript.Echo "The folder at this path does not exist or is not available:"
    WScript.Echo workingPath
    WScript.Echo()
    WScript.Quit
End If

' Get a reference to the workingPath folder

Dim folder
Set folder = fileSys.GetFolder(workingPath)

' Check if there are any files with the sourceExtension
sourceFilesExist = False

If sourceExtension = "all" Then
  For Each extension in extensionList
    For Each file In folder.Files
      If LCase(fileSys.GetExtensionName(file.Name)) = LCase(extension) Then
        sourceFilesExist = True
        Exit For
      End If
    Next
    If sourceFilesExist = True Then
      Exit For
    End If
  Next
Else
  For Each file In folder.Files
    If LCase(fileSys.GetExtensionName(file.Name)) = LCase(sourceExtension) Then
        sourceFilesExist = True
        Exit For
    End If
  Next
End If

If Not sourceFilesExist Then
    WScript.Echo()
  If sourceExtension = "all" Then
    WScript.Echo "There are no files with those extensions in the folder:"
    WScript.echo "webp, avif, jpg, jpeg, bmp, tif, tiff, heic, jfif"
  Else
    WScript.Echo "There are no files with that extension in the folder:"
    WScript.Echo sourceExtension
  End If
    WScript.Echo workingPath
    WScript.Echo()
    WScript.Quit
End If

wscript.echo()

' Check if converting files to the destinationExtension would cause filename conflicts
destinationExtension = LCase(destinationExtension)
Dim badX, filesX, filesY
badX = int(0)
filesX = int(0)
filesY = int(0)

'PUT IT HERE
If sourceExtension = "all" Then

  For Each extension in extensionList
    countFiles(extension)
  Next
Else
  countFiles(sourceExtension)
End If

'msgbox badX & vbCrlf & filesY
'wscript.quit


If badX = 1 Then
  wscript.echo()
  wscript.echo vbTab & "A file already exists with the destination name."
  wscript.echo vbTab & "Please manually rename it first."
  wscript.echo()
  wscript.quit()
ElseIf badX > 1 Then
  wscript.echo()
  wscript.echo vbTab & "There are " & badX & " files that already exist with the destination names."
  wscript.echo vbTab & "Please manually rename them first."
  wscript.echo()
  wscript.quit()
End If


wscript.echo "Creating Batch file"
wscript.echo()

' Create a batch file to convert each file to the destinationExtension using FFmpeg
Set batchFile = fileSys.CreateTextFile("ConvertImages.bat", True)

batchFile.WriteLine()
batchFile.WriteLine("CD /D " & chr(34) & workingPath & chr(34))
batchFile.WriteLine()
batchFile.WriteLine("set /a convertedX=0")
batchFile.WriteLine("set /a errX=0")
batchFile.WriteLine()



For Each extension in extensionList

  For Each file In folder.Files
    If LCase(fileSys.GetExtensionName(file.Name)) = LCase(extension) Then

      filesX = filesX + 1

        ' Formulate the FFmpeg command for converting the file
'        sourceFile = fileSys.GetAbsolutePathName(file.Path)
'        destinationFile = Replace(sourceFile, "." & extension, "." & destinationExtension, 1, -1, vbTextCompare)

        fileName = Replace(filesys.GetBaseName(file.Name), "%", "%%")
        oldFile = fileName & "." & extension
        newFile = fileName & "." & destinationExtension

        command = chr(34) & currentDirectory & "\ffmpeg.exe" & chr(34) & " -hide_banner -i """ & oldFile & """ """ & newFile & """"

' command = chr(34) & currentDirectory & "\ffmpeg.exe" & chr(34) & " -hide_banner -i """ & file.Name & """ """ & newFile & """"


        command2 = "If Exist " & Chr(34) & newFile & chr(34) & " set /a convertedX=%convertedX%+1"
        command3 = "If Not Exist " & Chr(34) & newFile & chr(34) & " set /a errX=%errX%+1"
        command4 = "If Exist " & Chr(34) & newFile & chr(34) & " DEL " & chr(34) & oldFile & chr(34)

        ' Write the command to the batch file

        batchFile.WriteLine "TITLE [" & filesX & " of " & filesY & "] " & oldFile
        batchFile.WriteLine "ECHO [" & filesX & " of " & filesY & "] " & oldFile
        batchFile.WriteLine command
        batchFile.WriteLine command2
        batchFile.WriteLine command3
        batchFile.WriteLine command4

        batchFile.WriteLine "ECHO["
        batchFile.WriteLine()

    End If
  Next
Next

batchFile.WriteLine()
batchFile.WriteLine("ECHO[")
batchFile.WriteLine("set /a totalX=%convertedX%+%errX%")
batchFile.WriteLine("ECHO     Successfully converted: %convertedX%")
batchFile.WriteLine("ECHO                     Errors: %errX%")
batchFile.WriteLine("ECHO                      Total: %totalX%")
batchFile.WriteLine("ECHO[")

batchFile.WriteLine()



REM batchFile.WriteLine("@ECHO ON")
batchFile.WriteLine("If " & chr(34) & "%errX%" & chr(34) & "==" & chr(34) & "0" & chr(34) & " " & chr(40))
batchFile.WriteLine("     REM say nothing")
batchFile.WriteLine(chr(41) & " else if " & chr(34) & "%errX%" & chr(34) & "==" & chr(34) & "1" & chr(34) & " " & chr(40))
batchFile.WriteLine("   ECHO     Error converting 1 file:")
batchFile.WriteLine("   ECHO[")
'COMMENTED OUT to support all extensions option, so has to be listed later by calling this script again with different argument
'batchFile.WriteLine("   DIR /B " & chr(34) & workingPath & "\*." & sourceExtension & chr(34))
batchFile.WriteLine(chr(41) & " else " & chr(40))
batchFile.WriteLine("   ECHO     Error converting %errX% files:")
batchFile.WriteLine("   ECHO[")
'COMMENTED OUT to support all extensions option, so has to be listed later by calling this script again with different argument
'batchFile.WriteLine("   DIR /B " & chr(34) & workingPath & "\*." & sourceExtension & chr(34))
batchFile.WriteLine(chr(41))
batchFile.WriteLine("ECHO[")

batchFile.WriteLine("Set convertedX=")
batchFile.WriteLine("Set errX=")
batchFile.WriteLine("Set totalX=")
batchFile.WriteLine("ECHO[")


batchFile.WriteLine()
batchFile.WriteLine("CD /D " & chr(34) & currentDirectory & chr(34))
batchFile.WriteLine()


' Close the batch file
batchFile.Close

wscript.Quit

Function countFiles(theExtension)

  
  For Each file In folder.Files

    If LCase(fileSys.GetExtensionName(file.Name)) = theExtension Then

       If filesys.FileExists(workingPath & "\" & filesys.GetBaseName(file.Name) & "." & destinationExtension) Then


         badX = badX + 1
         WScript.Echo "File already exists: '" & filesys.GetBaseName(file.Name) & "." & destinationExtension & "'."

       End If

    End If

    'count all of the files
    If LCase(fileSys.GetExtensionName(file.Name)) = LCase(theExtension) Then

       filesY = filesY + 1

    End If

  Next

End Function




Sub checkForDuplicates(folderPath)

    ' Check if the folder exists
    If Not fileSys.FolderExists(folderPath) Then
        WScript.Echo "Folder not found: " & folderPath
        Exit Sub
    End If
    
    ' Get a reference to the folder

    Set folder = fileSys.GetFolder(folderPath)

    ' Create a dictionary to store MD5 hashes and corresponding file paths

  Set md5List = CreateObject("System.Collections.ArrayList")
  Set fileList = CreateObject("System.Collections.ArrayList")
    

  dX = int(0)

  ' Iterate through all files in the folder
  For Each file In folder.Files
    ' Check if the file is a JPG or PNG image
    If LCase(fileSys.GetExtensionName(file.Path)) = "jpg" Or LCase(fileSys.GetExtensionName(file.Path)) = "png" Then
        ' Calculate the MD5 hash of the file
        md5Hash = GetMD5Hash(file.Path)
        ' Check if the hash already exists in the list
        duplicateIndex = -1
        For i = 0 To md5List.Count - 1
            If md5List(i) = md5Hash Then
                duplicateIndex = i
                Exit For
            End If
        Next
        
        If duplicateIndex <> -1 Then
            dX = dX + 1
            ' Duplicate found
            WScript.Echo 
            WScript.Echo "Duplicate hash found:"
            WScript.Echo "  Hash: " & md5Hash
            WScript.Echo "  File 1: " & fileList(duplicateIndex)
            WScript.Echo "  File 2: " & file.Name
        Else
            ' Add the hash and file name to the lists
            md5List.Add md5Hash
            fileList.Add file.Name
        End If
    End If
  Next

  wscript.echo()
  If dX = 0 Then
    wscript.echo("     No duplicate hashes were found")
  ElseIf dX = 1 Then
    wscript.echo("     One duplicate hash was found")
  Else
    wscript.echo("     " & dX & " duplicate hashes were found")
  End If
  wscript.echo()

End Sub


Function GetMD5Hash(filename)

    ' Read file content as binary data
    Set oStream = CreateObject("ADODB.Stream")
    oStream.Type = 1 ' Binary
    oStream.Open
    oStream.LoadFromFile filename
    fileBytes = oStream.Read
    oStream.Close

    ' Compute MD5 hash
    oMD5.ComputeHash_2(fileBytes)

    ' Get hash bytes
    hashBytes = oMD5.Hash


    ' Convert hash bytes to hex string
    hashHex = ""
    For i = 1 To LenB(hashBytes)
        hashHex = hashHex & Right("0" & Hex(AscB(MidB(hashBytes, i, 1))), 2)
    Next

    ' Return hash
    GetMD5Hash = hashHex
End Function


Sub listFileExtensions(folderPath)

    ' Create a dictionary to store extension counts
    Set extensionCounts = CreateObject("Scripting.Dictionary")

    ' Create a FileSystemObject
    Set fileSys = CreateObject("Scripting.FileSystemObject")

    ' Check if the folder exists
    If Not fileSys.FolderExists(folderPath) Then
        WScript.Echo "Folder not found:", folderPath
        Exit Sub
    End If

    ' Get the folder object
    Set folder = fileSys.GetFolder(folderPath)

    ' Loop through all files in the folder
    For Each file In folder.Files
        ' Get the file extension
        extension = LCase(fileSys.GetExtensionName(file.Path))
        
        ' Check if the extension already exists in the dictionary
        If extensionCounts.Exists(extension) Then
            ' Increment the count for this extension
            extensionCounts(extension) = extensionCounts(extension) + 1
        Else
            ' Add the extension to the dictionary with a count of 1
            extensionCounts.Add extension, 1
        End If
    Next

    totalX = int(0)
    ' Display the count for each extension
    For Each extension In extensionCounts.Keys
        WScript.Echo "     ", extension, "- Count:", extensionCounts(extension)
        totalX = totalX + extensionCounts(extension)
    Next
    WScript.Echo()
    WScript.Echo "     Total files:" & vbTab & totalX


End Sub

Sub listTheFailures()

Set folder = fileSys.GetFolder(workingPath)

' Check if there are any files with the sourceExtension

  For Each extension in extensionList
    For Each file In folder.Files
      If LCase(fileSys.GetExtensionName(file.Name)) = LCase(extension) Then
        wscript.echo file.Name
      End If
    Next
  Next

End Sub

