ExcelToCsv(originalFilePath, csvFilePath, separator := ",", normalized := false, firstHeader := "", toUpper := false){
    excelClose(){
        loop{
            RunAs()
            RunWait("taskkill.exe /f /im EXCEL.EXE", , "Hide")
            ProcessClose("excel.exe")
            ProcessWaitClose("excel.exe")
            if not ProcessExist("Excel.exe")
                break
        }
    }
    normalizeString(str, toUpper := false){
        chars := Map( "a" , "áàâǎăãảạäåāąấầẫẩậắằẵẳặǻ"
        , "c" , "ćĉčċç"
        , "d" , "ďđð"
        , "e" , "éèêěĕẽẻėëēęếềễểẹệ"
        , "g" , "ğĝġģ"
        , "h" , "ĥħ"
        , "i" , "íìĭîǐïĩįīỉịĵ"
        , "k" , "ķ"
        , "l" , "ĺľļłŀ"
        , "n" , "ńňñņ"
        , "o" , "óòŏôốồỗổǒöőõøǿōỏơớờỡởợọộ"
        , "s" , "ṕṗŕřŗśŝšş"
        , "t" , "ťţŧ"
        , "u" , "úùŭûǔůüǘǜǚǖűũųūủưứừữửựụ"
        , "w" , "ẃẁŵẅýỳŷÿỹỷỵ"
        , "z" , "źžż")
    
        newText := str
        if toUpper
            newText := StrUpper(newText)
    
        for a, b in chars{
            upperA := StrUpper(a)
            upperB := StrUpper(b)
            newText := RegExReplace(newText, "[" b "]", a)
            newText := RegExReplace(newText, "[" upperB "]", upperA)
        }
        return newText
    }
    excelClose()
    if not FileExist(originalFilePath){
        throw Error("originalFilePath does not exist.", "ExcelToCsv")
    }
    obj := ComObjGet(originalFilePath)
    try{
        FileDelete(csvFilePath)
    }
    obj.SaveAs(csvFilePath, 42)
    obj.Close()

    txtFile := FileRead(csvFilePath, "UTF-8")
    if firstHeader != ""
        txtFile := SubStr(txtFile, InStr(txtFile, firstHeader))
    txtFile := normalizeString(txtFile, toUpper)

    ; My specific usecase
    txtFile := StrReplace(txtFile, "%", "")
    txtFile := StrReplace(txtFile, "`r", "`n")
    txtFile := StrReplace(txtFile, "`n`n", "`n")
    txtFile := StrReplace(txtFile, ";", " + ")
    ;txtFile := StrReplace(txtFile, ",", ".")
    txtFile := StrReplace(txtFile, " - ", " *_* ")
    txtFile := StrReplace(txtFile, "*_*", "")
    txtFile := StrReplace(txtFile, "   ", "")
    ; End of my usecase

    txtFile := StrReplace(txtFile, '"', "")
    txtFile := '"' txtFile
    txtFile := StrReplace(txtFile, "`t", '"' separator '"')
    txtFile := StrReplace(txtFile, '"' separator '"`n', '"' separator "`n")
    txtFile := StrReplace(txtFile, '`n', '"`n"')
    txtFile := SubStr(txtFile, 1, -2)
    txtFile := StrReplace(txtFile, '""', "")

    try{
        FileDelete(csvFilePath)
    }
    FileAppend(txtFile, csvFilePath)
}