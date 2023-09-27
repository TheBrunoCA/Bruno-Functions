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

    Sanify(what_to){
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

    FindItem(whatToSearch, header := "", exactMatch := false) {
        if whatToSearch == ""
            throw Error("whatToSearch must no be empty.", "CsvHelper.findItem()")

        if not this._IsHeader(header) and header != ""
            throw Error("Header does not exist.")

        lines := StrSplit(this.file, "`n")
        for line in lines {
            if header == "" {
                loop parse line, "CSV" {
                    if A_LoopField == ""
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        continue
                    return this._GetItemMap(line)
                }
            } else {
                loop parse line, "CSV" {
                    if A_LoopField == ""
                        continue
                    if this.headers[A_Index] != header
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        break
                    return this._GetItemMap(line)
                }
            }
        }
        throw Error("No item found with such attributes.", "CsvHelper/findItem()")
    }

    GetArrayOfItems(whatToSearch, header := "", exactMatch := false) {
        if whatToSearch == ""
            throw Error("whatToSearch must no be empty.", "CsvHelper.getAllItems()")

        if not this._IsHeader(header) and header != ""
            throw Error("Header does not exist.")

        items := Array()
        lines := StrSplit(this.file, "`n")
        for line in lines {
            if header == "" {
                loop parse line, "CSV" {
                    if A_LoopField == ""
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        continue
                    items.Push(this._GetItemMap(line))
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
                    items.Push(this._GetItemMap(line))
                    break
                }
            }
        }
        if items.Has(1)
            return items
        throw Error("No item found with such attributes.", "CsvHelper/getAllItems()")
    }

    GetMapOfItems(whatToSearch, key := this.headers[1], header := "", exactmatch := false) {
        if whatToSearch == ""
            throw Error("whatToSearch must no be empty.", "CsvHelper.getMapOfItems()")

        if not this._IsHeader(header) and header != ""
            throw Error("Header does not exist.")
        
        keyIsHeader := this._IsHeader(key)

        if not keyIsHeader
            throw Error("Key must be a Header.", "CsvHelper.getMapOfItems()")

        items := Map()
        lines := StrSplit(this.file, "`n")
        for line in lines {
            if header == "" {
                loop parse line, "CSV" {
                    if A_LoopField == ""
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        continue
                    item := this._GetItemMap(line)
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
                    items[item[key]] := item
                    break
                }
            }
        }
        if items.Count
            return items
        throw Error("No item found with such attributes.", "CsvHelper/getMapOfItems()")
    }

    _GetItemMap(item) {
        nMap := Map()
        loop parse item, "CSV" {
            header := this.headers[A_Index]
            field := A_LoopField
            nMap[header] := field
        }
        return nMap
    }

    Save(path := this.path, overwrite := true){
        file := ""
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