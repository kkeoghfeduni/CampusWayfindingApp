' Name: svg-sanitizer (via web) CScript Version 0.1
' File: svg-sanitizer.vbs
' Licence: N/A
' Author: Mark
' Date: 17 June 2020
' Version: 0.1
' Release: 1
' Language: VBScript
' Compiler: N/A
' Notes: This script can only be run from cscript.exe command line. This script is intended as a work around to an issue with the svg-sanitizer package found here:
'		 https://github.com/darylldoyle/svg-sanitizer, 
'		 See the issue here: 
'		 https://github.com/darylldoyle/svg-sanitizer/issues/43, 
'		 by using the demo version found here: http://svg.enshrined.co.uk/ it is possible to automate the process of sending our SVG files to the server
'		 and having it processed and sent back rather than try and fix the issue with XPath when trying to run the Standalone CLI version of the script via PHP.
'		 The parameters are [input.svg] [output.svg]
'		 Note: the script work even if [output.svg] is null; it will default to [input]_cleaned.svg
'        
' Usage: Save as "svg-sanitizer.vbs"
'        Run this from command line using cscript.exe, eg: cscript C:\path\to\script\svg-sanitizer.vbs input.svg output.svg

'Set oWSH = CreateObject("WScript.Shell")
Set objStdOut = WScript.StdOut
Set objStdIn = WScript.StdIn
Set objFSO = Createobject("Scripting.FileSystemObject")
Set objShell = wscript.createobject("wscript.shell")

Select Case WScript.Arguments.Count
Case 0
	objStdOut.Write "Please specify an input SVG file:"
    InputSVGfile = objStdIn.ReadLine 
	OutputSVGfile = replace(InputSVGfile,".svg","_cleaned.svg") 
Case 1
	InputSVGfile = WScript.Arguments(0)
	OutputSVGfile = replace(InputSVGfile,".svg","_cleaned.svg") 
Case 2
	InputSVGfile = WScript.Arguments(0)
	OutputSVGfile = WScript.Arguments(1)
Case Else
		InputSVGfile = WScript.Arguments(0)
		'OutputSVGfile = WScript.Arguments(1)
		OutputSVGfile = replace(InputSVGfile,".svg","_cleaned.svg") 
End Select

' read svg input to string
Set inFile = objFSO.OpenTextFile(objShell.CurrentDirectory & "\" & InputSVGfile, 1)
inputSVGfileContents = inFile.ReadAll
inFile.Close

Result=URLPost("http://svg.enshrined.co.uk/","activity=submit&dirty=" & inputSVGfileContents)
strOutput = split(Result,"<label>Cleaned SVG</label>")(1)
strOutput = split(strOutput,"</textarea>")(0)
strOutput = split(strOutput,"<textarea>")(1)
'strOutput = replace(replace(strOutput,vbcr,""),vblf,"")

'Debug output:
'objStdOut.Write "Result: " & strOutput
objStdOut.Write Result

objStdOut.Write "SVG File sanitized, Writing: " & OutputSVGfile

Set outFile = objFSO.OpenTextFile(objShell.CurrentDirectory & "\" & OutputSVGfile, 2, True)
outFile.Write strOutput
outFile.Close


Function URLPost(URL,FormData)
  Set Http = CreateObject("Microsoft.XMLHTTP")
  Http.Open "POST",URL,True
  Http.setRequestHeader "Content-Type","application/x-www-form-urlencoded"
  Http.send FormData
  for n = 1 to 9
   If Http.readyState = 4 then exit for
	WScript.Sleep 1000
  next
  If Http.readyState <> 4 then
    URLPost = "Failed"
  else
    URLPost = Http.responseText
  end if
End Function