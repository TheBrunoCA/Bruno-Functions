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
        return StrSplit(h[1], this.separator)
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

        loop parse this.file, "`n"{
            line := StrSplit(A_LoopField, this.separator)
            if header == ""{
                for i, entry in line{
                    if entry == ""
                        continue
                    if (exactMatch and entry != whatToSearch) or ( not exactMatch and not InStr(entry, whatToSearch))
                        continue
                    return this._getItemMap(A_LoopField)
                }
            } else{
                for i, entry in line{
                    if entry == ""
                        continue
                    if this.headers[i] != header
                        continue
                    if (exactMatch and entry != whatToSearch) or ( not exactMatch and not InStr(entry, whatToSearch))
                        break
                    return this._getItemMap(A_LoopField)
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
        loop parse this.file, "`n"{
            line := StrSplit(A_LoopField, this.separator)
            if header == ""{
                for i, entry in line{
                    if entry == ""
                        continue
                    if (exactMatch and entry != whatToSearch) or ( not exactMatch and not InStr(entry, whatToSearch))
                        continue
                    items.Push(this._getItemMap(A_LoopField))
                    break
                }
            } else{
                for i, entry in line{
                    if entry == ""
                        continue
                    if this.headers[i] != header
                        continue
                    if (exactMatch and entry != whatToSearch) or ( not exactMatch and not InStr(entry, whatToSearch))
                        break
                    items.Push(this._getItemMap(A_LoopField))
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
        loop parse this.file, "`n"{
            line := StrSplit(A_LoopField, this.separator)
            if header == ""{
                for i, entry in line{
                    if entry == ""
                        continue
                    if (exactMatch and entry != whatToSearch) or ( not exactMatch and not InStr(entry, whatToSearch))
                        continue
                    item := this._getItemMap(A_LoopField)
                    items[item[key]] := item
                    break
                }
            } else{
                for i, entry in line{
                    if entry == ""
                        continue
                    if this.headers[i] != header
                        continue
                    if (exactMatch and entry != whatToSearch) or ( not exactMatch and not InStr(entry, whatToSearch))
                        break
                    item := this._getItemMap(A_LoopField)
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
        loop parse item, this.separator{
            header := this.headers[A_Index]
            field := A_LoopField
            nMap[header] := field
        }
        return nMap
    }
}