Set oClipboard = New clsClipboard
Set objShell = wscript.createobject("wscript.shell")
Set objFSO = Createobject("Scripting.FileSystemObject")
Set objStdOut = WScript.StdOut
Set objStdIn = WScript.StdIn

Const ForReading = 1
Const ForWriting = 2
TemplateFile = (objShell.CurrentDirectory & "\svg-to-geojson\svg-to-geojson-temp.html")

Select Case WScript.Arguments.Count
Case 0
    objStdOut.Write "Not enough arguments..."
    wscript.quit
Case 1
    	If LCase(WScript.Arguments(0)) = "-compile" then
		'objStdOut.Write "Debug: Good Arguments. "
		Call compileFile()
		wscript.quit
	End if
    wscript.quit
Case 2
	If LCase(WScript.Arguments(0)) = "-append" then
		SVGfiein = WScript.Arguments(1)
		'objStdOut.Write "Debug: Good Arguments. "
		Call appendFile(SVGfiein)
		wscript.quit
	End if
	
Case Else
		objStdOut.Write "Not enough arguments..."
		wscript.quit
End Select

Function qq(str)
qq = Chr(34) & str & Chr(34)
End Function

Sub appendFile(SVGfiein)
	'Copy template file
	If objFSO.FileExists(TemplateFile) = True Then
		If objFSO.FileExists(objShell.CurrentDirectory & "\svg-to-geojson-temp.html") = False Then
			objStdOut.Write "Copy Template file..." & vbCrLf
			objFSO.CopyFile TemplateFile, objShell.CurrentDirectory & "\svg-to-geojson-temp.html"
		Else 
			objStdOut.Write "Skip copying of Template file..." & vbCrLf
		End if
	Else 
		objStdOut.Write "Template file missing..." & vbCrLf
		wscript.quit
	End if
	
	'Load the template file in to read
	Set objFile = objFSO.OpenTextFile(objShell.CurrentDirectory & "\svg-to-geojson-temp.html", ForReading)
	svg2geojsontempStr = objFile.ReadAll
	objFile.Close
	
	'Load the SVG file in to added it to the template
	Set objFile = objFSO.OpenTextFile(objShell.CurrentDirectory & "\" & SVGfiein, ForReading)
	SVGfieContents = objFile.ReadAll
	objFile.Close
	
	'Remove spaces from filename
	tempfileNameforID = Replace(SVGfiein, " ", "")
	tempfileNameforID = Replace(tempfileNameforID, "_cleaned.svg", "")
	
	'Add a unique ID to the files SVG tag.
	SVGfieContents = Replace(SVGfieContents, "<svg ", "<svg id='" & tempfileNameforID & "' ")
	
	'Edit the template strings...
	svg2geojsontempStr = Replace(svg2geojsontempStr, "<!-- svg file here <svg id=""mysvg""-->", SVGfieContents & vbCrLf & "<!-- svg file here <svg id=""mysvg""-->")
	
	'JS file name Part...
	svg2geojsontempStr = Replace(svg2geojsontempStr, "*INPUTFILENAME*", tempfileNameforID)
	
	'JS Tag part...
	'LongJsString = "var temp = null;" & vbCrLf & "var temp = svgtogeojson.svgToGeoJson([[143.891121, -37.626194],[144.891121, -38.626194]], document.getElementById('*INPUTFILENAME*'), 3);" & vbCrLf & "document.getElementById('output').innerHTML = document.getElementById('output').innerHTML + '%Split%*INPUTFILENAME*|' + JSON.stringify(temp);" & vbCrLf & vbCrLf & "/*NEXTTAG*/"
	
	LongJsString = "var temp = null;" & vbCrLf & "var temp = svgtogeojson.svgToGeoJson([[-37.626194, 143.891121], [-38.626194, 144.891121]], document.getElementById('*INPUTFILENAME*'), 3);" & vbCrLf & "document.getElementById('output').innerHTML = document.getElementById('output').innerHTML + '%Split%*INPUTFILENAME*|' + JSON.stringify(temp);" & vbCrLf & vbCrLf & "/*NEXTTAG*/"
	svg2geojsontempStr = Replace(svg2geojsontempStr, "/*NEXTTAG*/", LongJsString)
	
	'objStdOut.Write svg2geojsontempStr
	Set outFile = objFSO.OpenTextFile(objShell.CurrentDirectory & "\svg-to-geojson-temp.html", ForWriting, True)
	outFile.Write svg2geojsontempStr
	outFile.Close
End Sub

Sub compileFile()

	If objFSO.FileExists(objShell.CurrentDirectory & "\svg-to-geojson-temp.html") = True Then
		If objFSO.FileExists("C:\Program Files\zMozilla Firefox\firefox.exe") = True Then
			objStdOut.Write "Found Firefox... " & vbCrLf
			FirefoxProfile = " "
			FirefoxPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
			webappurl = "file:///" & objShell.CurrentDirectory & "\svg-to-geojson-temp.html"
			Height = "700"
			Width = "920"
			Status ="0"
			Toolbar = "0"
			Menubar = "0"

			objShell.run qq(FirefoxPath) & " -p " & qq(FirefoxProfile) _
			& " -status " & qq(status) & " -Toolbar " & qq(toolbar) & " -menubar " & qq(menubar) _
			& " -Height " & qq(Height) & " -Width " & qq(Width) _
			& " -foreground -new-tab -private-window " & webappurl

			'Set objShell = Nothing
			
			'objShell.Run("""C:\Program Files\Mozilla Firefox\firefox.exe -profilemanager -foreground -new-tab -private-window file:///" & objShell.CurrentDirectory & "\svg-to-geojson-temp.html" & "")
			'Set objShell = Nothing
			
		ElseIf objFSO.FileExists("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe") = True Then
			objStdOut.Write "Found Google Chrome... " & vbCrLf
			
			GoogleChromeProfile = "/incognito"
			GoogleChromePath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
			webappurl = objShell.CurrentDirectory & "\svg-to-geojson-temp.html"

			'objStdOut.Write qq(GoogleChromePath) & " " & GoogleChromeProfile & " " & webappurl
			'objShell.run qq(GoogleChromePath) & " " & GoogleChromeProfile & " " & webappurl
			objShell.run qq(GoogleChromePath) & " " & webappurl
			
		Else
			objStdOut.Write "No supported browser found... " & vbCrLf
		End if
	Else 
		objStdOut.Write "svg-to-geojson-temp.html file missing..." & vbCrLf
		wscript.quit
	End if
	
	objStdOut.Write "Click the button on the web-page that just oped up and then press enter..." & vbCrLf
	tempLine = objStdIn.ReadLine

	strClipboardText = oClipboard.GetText
	
    'If strClipboardText = Nothing Then
	'	objStdOut.Write "Could not access text from clipboard, try again?" & vbCrLf
	'	tempLine = objStdIn.ReadLine
	'	
	'	strClipboardText = oClipboard.GetText
	'End if

	'tempstr=Split(strClipboardText,"%Split%")
	'objStdOut.Write strClipboardText
	
	'listLines = Split(listFile, vbCrLf)
	
	Set outFile = objFSO.OpenTextFile(objShell.CurrentDirectory & "\tempgeojson.json", ForWriting, True)
	outFile.Write strClipboardText
	outFile.Close
	
	Set inFile = objFSO.OpenTextFile(objShell.CurrentDirectory & "\tempgeojson.json", ForReading)
	geoJsonfieContents = inFile.ReadAll
	inFile.Close

	listLines = Split(geoJsonfieContents, "%Split%")


	For i = 1 To Ubound(listLines)
     	'objStdOut.Write Ubound(listLines)
		filename=Split(listLines(i),"|")
		'objStdOut.Write " FileName: " & filename(0)
		'objStdOut.Write " content: " & filename(1)
		Set outFile = objFSO.OpenTextFile(objShell.CurrentDirectory & "\" & filename(0) & ".json", ForWriting, True)
		outFile.Write filename(1)
		objStdOut.Write "Writing: " & filename(1)
		outFile.Close
    Next

	'objStdOut.Write Ubound(listLines)
	'filename =Split(listLines(1),"|")
	'objStdOut.Write " FileName: " & filename(0)
	'objStdOut.Write " content: " & filename(1)

	'For Each line In listLines
		'Dim arr
		'arr = Split(line,"|")
		'objStdOut.Write line
		'objStdOut.Write CStr(i) + " FileName: " + arr(1)+ " content: " + arr(0)
	'Next
	
End Sub

Class clsClipboard

    Private oHTML
    
    Private Sub Class_Initialize
        Set oHTML = CreateObject("InternetExplorer.Application")
        oHTML.Navigate ("about:blank")
    End Sub

    ' Clear Clipboard
    Public Sub Clear()
        oHTML.Document.ParentWindow.ClipboardData.ClearData()
    End Sub
    
    ' Get text from Clipboard   
    Public Property Get GetText()
        GetText = oHTML.Document.ParentWindow.ClipboardData.GetData("Text")
    End Property
    
    ' Set text to Clipboard 
    Public Property Let PutText(Value)
        oHTML.Document.ParentWindow.ClipboardData.SetData "Text", Value
    End Property
    
    Private Sub Class_Terminate
        oHTML.Quit
        Set oHTML = Nothing
    End Sub
    
End Class
