Sub ProcessSurveyData()
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim lastCol As Long
    Dim i As Long, j As Long
    Dim className As String
    Dim ratingSum As Double
    Dim ratingCount As Long
    Dim avgRating As Double
    Dim json As String
    Dim fso As Object
    Dim jsonFile As Object
    Dim filePath As String

    ' Set reference to the active sheet (assuming CSV is opened)
    Set ws = ActiveSheet

    ' Find the last row and column
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column

    ' Start building JSON string
    json = "["

    ' Loop through columns (assuming first column is Student ID, so start from 2)
    For j = 2 To lastCol
        className = ws.Cells(1, j).Value

        ' Escape backslashes and double quotes for JSON
        className = Replace(className, "\", "\\")
        className = Replace(className, """", "\""")

        ratingSum = 0
        ratingCount = 0

        ' Loop through rows to calculate sum and count
        For i = 2 To lastRow
            If IsNumeric(ws.Cells(i, j).Value) And ws.Cells(i, j).Value <> "" Then
                ratingSum = ratingSum + ws.Cells(i, j).Value
                ratingCount = ratingCount + 1
            End If
        Next i

        ' Calculate average
        If ratingCount > 0 Then
            avgRating = ratingSum / ratingCount
        Else
            avgRating = 0
        End If

        ' Format average with dot separator regardless of locale
        Dim avgStr As String
        avgStr = Format(avgRating, "0.00")
        avgStr = Replace(avgStr, ",", ".")

        ' Append to JSON string
        json = json & "{"
        json = json & """className"": """ & className & ""","
        json = json & """averageRating"": " & avgStr & ","
        json = json & """studentCount"": " & ratingCount
        json = json & "}"

        ' Add comma if not the last item
        If j < lastCol Then
            json = json & ","
        End If
    Next j

    json = json & "]"

    ' Define file path for JSON output
    filePath = ActiveWorkbook.Path & "\data.json"

    ' Write JSON to file
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set jsonFile = fso.CreateTextFile(filePath, True)
    jsonFile.Write json
    jsonFile.Close

    MsgBox "Data processed and exported to " & filePath
End Sub
