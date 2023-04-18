Dim args, filepath, fso, file, ts, line, values, threshold

threshold = 0.06

' Check if a command line argument was provided
If WScript.Arguments.Count > 0 Then

    ' Use the command line argument as the file path
    filepath = WScript.Arguments.Item(0)

    If WScript.Arguments.Count > 1 Then
      threshold = WScript.Arguments.Item(1)
    End If

    lenNoDots = Len(threshold) - Len(Replace(threshold, ".", ""))

    difference = Len(lenNoDots)

    If difference > 1 Then
      wscript.echo("***** ERROR: the threshold can only have one '.' *****")
      wscript.echo("      EXAMPLES:")
      wscript.echo("      0.08, 1, 0.03 " & Chr(40) & "only enter one value" & Chr(41))
      wscript.echo("      value provided: " & threshold)
      wscript.Quit
    End If

    If Not IsNumeric(threshold) Then
      wscript.echo("***** ERROR: the threshold has to be numeric *****")
      wscript.echo("      EXAMPLES:")
      wscript.echo("      0.08, 1, 0.03 " & Chr(40) & "only enter one value" & Chr(41))
      wscript.echo("      value provided: " & threshold)
      wscript.Quit
    End If

Else
    ' Prompt the user for the file path
    filepath = InputBox("Please enter the path to the CSV file:")
End If

wscript.echo()
wscript.echo(vbTab & "threshold: " & threshold)
wscript.echo()

' Create a file system object
Set fso = CreateObject("Scripting.FileSystemObject")

' Check if the file exists
x = 0
y = 0
If fso.FileExists(filepath) Then
    ' Open the file for reading
    Set file = fso.OpenTextFile(filepath, 1)

    ' Read and discard the first line (header)
    file.ReadLine

    ' Loop through the rest of the lines
    Do While Not file.AtEndOfStream
        ' Read the line and split it into an array of values
        line = file.ReadLine
        y = y + 1
        values = Split(line, ",")

        ' Check if the loss is less than threshold
        If CDbl(values(3)) < CDbl(threshold) Then
            x = x + 1
            ' Display the step and loss values
            WScript.Echo "Step: " & values(0) & ", Loss: " & values(3)
        End If
    Loop

    ' Close the file
    file.Close

    wscript.echo()
    wscript.echo "Total lines found: " & y
    wscript.echo "Values found below " & threshold & " : " & x
    wscript.echo()

Else
    ' Display an error message if the file does not exist
    WScript.Echo "File not found, or it was not available:"
    WScript.Echo filepath
End If
