Class CsvHelper {
    __New(path) {
        if path == "" or not FileExist(path)
            throw Error("Path is empty or does not exist.", "CsvHelper")
        this.path := path
        this.file := FileRead(this.path, "UTF-8")
        this.file := this.Sanify(this.file)
        this.headers := this._GetHeaders()
        this.file := this._NoHeaders()
        this.length := this._getLength()
    }

    _getLength(){
        lines := 0
        loop parse this.file, "`n"{
            lines += 1
        }
        return lines
    }

    Sanify(what_to, show_progress := false){
        csv := what_to
        c := 0
        csv := StrReplace(csv, ' "', '"', , &c)
        while c > 0
            csv := StrReplace(csv, ' "', '"', , &c)
        c := 0
        csv:= StrReplace(csv, '"," ', '","', , &c)
        while c > 0
            csv := StrReplace(csv, '"," ', '","', , &c)
        c := 0
        csv := StrReplace(csv, '" ', '"', , &c)
        while c > 0
            csv := StrReplace(csv, '" ', '"', , &c)
        csv := StrReplace(csv, "`r", "`n")
        c := 0
        csv := StrReplace(csv, "`n ", "`n", , &c)
        while c > 0
            csv := StrReplace(csv, "`n ", "`n", , &c)
        c := 0
        csv := StrReplace(csv, " `n", "`n", , &c)
        while c > 0
            csv := StrReplace(csv, " `n", "`n", , &c)

        newfile := ""
        loop parse csv, "`n"{
            line := A_LoopField
            loop parse line, "CSV"{
                if A_LoopField == ""{
                    newfile .= ","
                }
                else
                    newfile .= '"' A_LoopField '",'
            }
            newfile .= "`n"
        }
        csv := StrReplace(newfile, ",`n", "`n")
        c := 0
        csv := StrReplace(csv, ",`n", "`n", , &c)
        while c > 0
            csv := StrReplace(csv, ",`n", "`n", , &c)
        c := 0
        csv := StrReplace(csv, ' "', '"', , &c)
        while c > 0
            csv := StrReplace(csv, ' "', '"', , &c)
        c := 0
        csv := StrReplace(csv, ' "', '"', , &c)
        while c > 0
            csv := StrReplace(csv, ' "', '"', , &c)
        c := 0
        csv := StrReplace(csv, '"," ', '","', , &c)
        while c > 0
            csv := StrReplace(csv, '"," ', '","', , &c)
        c := 0
        csv := StrReplace(csv, '" ', '"', , &c)
        while c > 0
            csv := StrReplace(csv, '" ', '"', , &c)
        c := 0
        csv := StrReplace(csv, "`n ", "`n", , &c)
        while c > 0
            csv := StrReplace(csv, "`n ", "`n", , &c)
        c := 0
        csv := StrReplace(csv, " `n", "`n", , &c)
        while c > 0
            csv := StrReplace(csv, " `n", "`n", , &c)

        return csv
    }

    _GetHeaders() {
        h := StrSplit(this.file, "`n")
        headers := []
        loop parse h[1], "CSV" {
            headers.Push(A_LoopField)
        }
        return headers
    }

    _NoHeaders() {
        return SubStr(this.file, InStr(this.file, "`n") + 1)
    }

    _IsHeader(header) {
        if header == ""
            return false
        for head in this.headers {
            if header == head
                return true
        }
        return false
    }

    FindItem(whatToSearch, header := "", exactMatch := false, show_progess := false) {
        if whatToSearch == ""
            throw Error("whatToSearch must no be empty.", "CsvHelper.findItem()")

        if not this._IsHeader(header) and header != ""
            throw Error("Header does not exist.")

        lines := StrSplit(this.file, "`n")
        if show_progess{
            p := 0
            l := __LoadingScreen("Searching", "Searching...", &p, lines.Length)
            l.start()
        }
        for i, line in lines {
            if show_progess
                p := i
            if header == "" {
                loop parse line, "CSV" {
                    if A_LoopField == ""
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        continue
                    item := this._GetItemMap(line)
                    if show_progess{
                        l.stop()
                    }
                    if item == false
                        break
                    return item
                }
            } else {
                loop parse line, "CSV" {
                    if A_LoopField == ""
                        continue
                    if this.headers[A_Index] != header
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        break
                    item := this._GetItemMap(line)
                    if show_progess{
                        l.stop()
                    }
                    if item == false
                        break
                    return item
                }
            }
        }
        if show_progess{
            l.stop()
        }
        throw Error("No item found with such attributes.", "CsvHelper/findItem()")
    }

    GetArrayOfItems(whatToSearch, header := "", exactMatch := false, show_progess := false) {
        if whatToSearch == ""
            throw Error("whatToSearch must no be empty.", "CsvHelper.getAllItems()")

        if not this._IsHeader(header) and header != ""
            throw Error("Header does not exist.")

        items := Array()
        lines := StrSplit(this.file, "`n")
        if show_progess{
            p := 0
            l := __LoadingScreen("Searching", "Searching...", &p, lines.Length)
            l.start(50)
        }
        for i, line in lines {
            if show_progess
                p := i
            if header == "" {
                loop parse line, "CSV" {
                    if A_LoopField == ""
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        continue
                    item := this._GetItemMap(line)
                    if item == false
                        break
                    items.Push(item)
                    break
                }
            } else {
                loop parse line, "CSV" {
                    if A_LoopField == ""
                        continue
                    if this.headers[A_Index] != header
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        break
                    item := this._GetItemMap(line)
                    if item == false
                        break
                    items.Push(item)
                    break
                }
            }
        }
        if show_progess{
            l.stop()
        }
        if items.Has(1)
            return items
        throw Error("No item found with such attributes.", "CsvHelper/getAllItems()")
    }

    GetMapOfItems(whatToSearch, key := this.headers[1], header := "", exactmatch := false, show_progess := false) {
        if whatToSearch == ""
            throw Error("whatToSearch must no be empty.", "CsvHelper.getMapOfItems()")

        if not this._IsHeader(header) and header != ""
            throw Error("Header does not exist.")
        
        keyIsHeader := this._IsHeader(key)

        if not keyIsHeader
            throw Error("Key must be a Header.", "CsvHelper.getMapOfItems()")

        items := Map()
        lines := StrSplit(this.file, "`n")
        if show_progess{
            p := 0
            l := __LoadingScreen("Searching", "Searching...", &p, lines.Length)
            l.start()
        }
        for i, line in lines {
            if show_progess
                p := i
            if header == "" {
                loop parse line, "CSV" {
                    if A_LoopField == ""
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        continue
                    item := this._GetItemMap(line)
                    if item == false
                        break
                    items[item[key]] := item
                    break
                }
            } else {
                loop parse line, "CSV" {
                    if A_LoopField == ""
                        continue
                    if this.headers[A_Index] != header
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        break
                    item := this._GetItemMap(line)
                    if item == false
                        break
                    items[item[key]] := item
                    break
                }
            }
        }
        if show_progess{
            l.stop()
        }
        if items.Count
            return items
        throw Error("No item found with such attributes.", "CsvHelper/getMapOfItems()")
    }

    _GetItemMap(item) {
        nMap := Map()
        loop parse item, "CSV" {
            if A_Index > this.headers.length
                return false
            header := this.headers[A_Index]
            field := A_LoopField
            nMap[header] := field
        }
        return nMap
    }

    Save(path := this.path, overwrite := true){
        local file := ""
        for head in this.headers
            file .= '"' head '",'
        file .= "`n"
        file := StrReplace(file, ",`n", "`n")
        file .= this.file

        try{
            FileDelete(path)
        }
        FileAppend(file, path, "UTF-8")

    }

    TrimHeaders(headers*){
        newfile := ""
        loop parse this.file, "`n"{
            line := A_LoopField
            loop parse line, "CSV"{
                index := A_Index
                pass := true
                for head in headers{
                    if head == this.headers[index]{
                        pass := false
                        break
                    }
                }
                if pass == false{
                    if A_Index == this.headers.Length
                        newfile .= "`n"
                    continue
                }
                    

                if A_Index == this.headers.Length{
                    if A_LoopField == ""{
                        newfile .=  A_LoopField '`n'
                        continue
                    }
                    newfile .= '"' A_LoopField '"`n'
                    continue
                }
                if A_LoopField == ""{
                    newfile .=  A_LoopField ','
                    continue
                }
                newfile .= '"' A_LoopField '",'
            }
        }
        this.file := this.Sanify(newfile)

        for head in headers{
            for header in this.headers{
                if head == header{
                    this.headers.RemoveAt(A_Index)
                    break
                }
            }
        }
    }
}

class __LoadingScreen{
    __New(text, title, &progressVar, maxProgress, color := "BackgroundGray cGreen", onCloseCallback := this._exitAappCallback) {
        this.progressVar    := &progressVar
        this.maxProgress    := maxProgress
        this.gLoading       := Gui("-MaximizeBox -MinimizeBox -Caption -Border")
        this.gLoading.Title := title
        this.gLoading.OnEvent("Close", onCloseCallback)
        this.gTxt           := this.gLoading.AddText(, text)
        this.gBar           := this.gLoading.AddProgress(color " w150", 0)
        this.gPercent       := this.gLoading.AddText("w50", "0%")
        this.fUpdateProgress:= ObjBindMethod(this, "_progressUpdate")
    }

    start(updateInterval := 100){
        SetTimer(this.fUpdateProgress, updateInterval)
        this.gLoading.Show()
    }

    stop(){
        SetTimer(this.fUpdateProgress, 0)
        this.gLoading.Destroy()
        
    }

    _progressUpdate(args*){
        progress            := %this.progressVar%
        maxProgress         := this.maxProgress
        if progress >= maxProgress{
            return
        }
        percent             := Round(progress/maxProgress*100)
        this.gBar.Value     := percent
        this.gPercent.Value := percent "%"
    }

    _exitAappCallback(){
        ExitApp()
    }
}