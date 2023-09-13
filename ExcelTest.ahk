Obj := InputBox("Entre o codigo de barras do produto"
, "Encontra PMC by TheBrunoCA")
try {
    oWorkbook := ComObjGet(A_ScriptDir . "\pmc_teste.xls")
    found := oWorkbook.ActiveSheet.Range("A:AZ").Find(Obj.Value)
    MsgBox(found.Offset(0, 27).Value)
} catch Error as e {
    MsgBox(e.Message)
}

