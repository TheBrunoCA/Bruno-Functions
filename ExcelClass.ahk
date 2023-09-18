

class ExcelClass{
    __New(pWorkSheet := "") {
        if pWorkSheet != ""{
            this.path := pWorkSheet
            try{
                this.COM := ComObjGet(pWorkSheet)
            }catch Error as e{
                if InStr(e.Message, "(0x80004005)"){
                    throw Error("Could not open the worksheet", "ExcelClass", "Possibly corrupt")
                }
            }
            
            this.sheet := this.COM.ActiveSheet
            this.rowCount := this.sheet.Rows.Count
        }
        else{
            this.path := ""
            this.sheet := ""
            this.COM := ComObject("Excel.Application")
        }
        this.defaultRange := "A:AZ"
    }

    save(){
        this.sheet.Save()
    }

    saveAs(pPath){
        this.sheet.SaveAs(pPath)
    }

    copyToClipboard(cell){
        this.sheet.Range(cell).Copy
    }

    addWorkbook(){
        this.COM.Workbooks.Add
        this.sheet := this.COM.ActiveSheet
    }

    openWorkbook(pPath){
        this.COM.Workbooks.Open(pPath)
        this.sheet := this.COM.ActiveSheet
    }

    setVisible(state){
        this.COM.Visible := state
    }

    getValue(cell){
        test := this.sheet.Range(StrUpper(cell)).Value
        return this.sheet.Range(StrUpper(cell)).Value
    }

    getValueColumn(value, range := this.defaultRange){
        return this._numToLetter(this.sheet.Range(range).Find(value).Column)
    }

    getValueRow(value, range := this.defaultRange){
        try{
            return this.sheet.Range(range).Find(value).Row
        } catch Error as e{
            if InStr(e.Message, 'This value of type "String" has no property named "Row".'){
                return false
            }
        }
        
    }

    getValuePosition(value, range := this.defaultRange){
        return this.getValueColumn(value) . this.getValueRow(value)
    }

    _numToLetter(num){
        if num < 1
            return "A"
    
        l := Map(1, "A", 2, "B", 3, "C", 4, "D", 5, "E", 6, "F", 7, "G", 8, "H", 9, "I", 10, "J", 11, "K", 
        12, "L", 13, "M", 14, "N", 15, "O", 16, "P", 17, "Q", 18, "R", 19, "S", 20, "T", 21, "U", 22, "V", 23, "W", 24, "X", 25, "Y", 26, "Z")
    
        full := Floor(num / l.Count)
        remainder := Mod(num, l.Count)
        letters := ""
        if full <= 0 or num == l.Count
            return l[num]
        loop full{
            letters .= "A"
        }
        if remainder == 0{
            letters := SubStr(letters, StrLen(-1))
            letters .= "Z"
            return letters
        }
        return letters . l[remainder]
    
    
    }

    close(){
        this.COM.Close()
    }
}