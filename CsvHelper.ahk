Class CsvHelper{
    __New(path, separator := ",") {
        if path == "" or not FileExist(path)
            throw Error("Path is empty or does not exist.", "CsvHelper")
        this.path := path
        if separator == ""
            throw Error("Separator must not be empty.", "CsvHelper")
        this.separator := separator
        this.file := FileRead(this.path, "UTF-8")
        this.headers := this._getHeaders()
        this.file := this._noHeaders()
    }

    _getHeaders(){
        h := StrSplit(this.file, "`n")
        h := StrReplace(h[1], '"', "")
        return StrSplit(h, this.separator)
    }

    _noHeaders(){
        return SubStr(this.file, InStr(this.file, "`n") +1)
    }

    findItem(whatToSearch, header := "", exactMatch := false){
        if whatToSearch == ""
            throw Error("whatToSearch must no be empty.", "CsvHelper.findItem()")
        if header != ""{
            headerExist := false
            for i, head in this.headers{
                if head == header{
                    headerExist := true
                    break
                }
            }
            if not headerExist
                throw Error("Header does not exist.", "CsvHelper.findItem()")
        }

        lines := StrSplit(this.file, "`n")
        for line in lines{

            ;line := StrSplit(A_LoopField, this.separator)
            if header == ""{
                loop parse line, "CSV"{
                    if A_LoopField == ""
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        continue
                    return this._getItemMap(line)
                }
            } else{
                loop parse line, "CSV"{
                ;for i, entry in line{
                    if A_LoopField == ""
                        continue
                    if this.headers[A_Index] != header
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        break
                    return this._getItemMap(line)
                }
            }
        }
        throw Error("No item found with such attributes.", "CsvHelper/findItem()")
    }

    getArrayOfItems(whatToSearch, header := "", exactMatch := false){
        if whatToSearch == ""
            throw Error("whatToSearch must no be empty.", "CsvHelper.getAllItems()")
        if header != ""{
            headerExist := false
            for i, head in this.headers{
                if head == header{
                    headerExist := true
                    break
                }
            }
            if not headerExist
                throw Error("Header does not exist.", "CsvHelper.getAllItems()")
        }
        items := Array()
        lines := StrSplit(this.file, "`n")
        for line in lines{
            if header == ""{
                loop parse line, "CSV"{
                    if A_LoopField == ""
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        continue
                    items.Push(this._getItemMap(line))
                    break
                }
            } else{
                loop parse line, "CSV"{
                    if A_LoopField == ""
                        continue
                    if this.headers[A_Index] != header
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        break
                    items.Push(this._getItemMap(line))
                    break
                }
            }
        }
        if items.Has(1)
            return items
        throw Error("No item found with such attributes.", "CsvHelper/getAllItems()")
    }

    getMapOfItems(whatToSearch, key := this.headers[1], header := "", exactmatch := false){
        if whatToSearch == ""
            throw Error("whatToSearch must no be empty.", "CsvHelper.getMapOfItems()")
        if header != ""{
            headerExist := false
            for i, head in this.headers{
                if head == header{
                    headerExist := true
                    break
                }
            }
            if not headerExist
                throw Error("Header does not exist.", "CsvHelper.getMapOfItems()")
        }
        keyIsHeader := false
            for i, head in this.headers{
                if head == key{
                    keyIsHeader := true
                    break
                }
            }
            if not keyIsHeader
                throw Error("Key must be a Header.", "CsvHelper.getMapOfItems()")

        items := Map()
        lines := StrSplit(this.file, "`n")
        for line in lines{
            if header == ""{
                loop parse line, "CSV"{
                    if A_LoopField == ""
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        continue
                    item := this._getItemMap(line)
                    items[item[key]] := item
                    break
                }
            } else{
                loop parse line, "CSV"{
                    if A_LoopField == ""
                        continue
                    if this.headers[A_Index] != header
                        continue
                    if (exactMatch and A_LoopField != whatToSearch) or ( not exactMatch and not InStr(A_LoopField, whatToSearch))
                        break
                    item := this._getItemMap(line)
                    items[item[key]] := item
                    break
                }
            }
        }
        if items.Count
            return items
        throw Error("No item found with such attributes.", "CsvHelper/getMapOfItems()")
    }

    _getItemMap(item){
        nMap := Map()
        loop parse item, "CSV"{
            header := this.headers[A_Index]
            field := A_LoopField
            nMap[header] := field
        }
        return nMap
    }
}