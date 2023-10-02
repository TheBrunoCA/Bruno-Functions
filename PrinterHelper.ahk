; A little class to help access the printers without having to use the registry
Class PrinterHelper{
    __New() {
        this._Load()
    }
    _Load(){
        this.printers   := this._GetPrinters()
        this.default    := this._GetDefaultPrinter()
    }

    _GetPrinters(){
        local log_path := A_Temp "\printers_log.txt"
        RunWait(A_ComSpec ' /c wmic.exe printer get name > "' log_path '"', , "Hide")
    
        local printers := []
    
        loop read log_path{
            if A_Index == 1
                continue
            local line := A_LoopReadLine
            if line == ""
                continue
    
            local c := 0
            line := StrReplace(line, "  ", " ", , &c)
            while c
                line := StrReplace(line, "  ", " ", , &c)
            
            if line == "Name"
                continue
    
            line := StrReplace(line, "`r", "")
            line := StrReplace(line, "`n", "")
            line := "&&&" line "&&&"
            line := StrReplace(line, "&&& ", "")
            line := StrReplace(line, " &&&", "")
            line := StrReplace(line, "&&&", "")
    
            printers.Push(line)
        }
    
        return printers
    }

    _GetDefaultPrinter(){
        local log_path := A_Temp "\printers_log.txt"
        RunWait(A_ComSpec ' /c wmic.exe printer where default="TRUE" get name > "' log_path '"', , "Hide")
    
        local printers := []
    
        loop read log_path{
            ret := false
            if A_Index == 1
                continue
            ret := A_LoopReadLine
        }
        ret .= "&&&"
        c := 1
        while c
            ret := StrReplace(ret, " &&&", "&&&", , &c)
        ret := StrReplace(ret, "&&&", "")
        return ret
    }
    
    GetPrinterMap(){
        local log_path := A_Temp "\printers_log.txt"
        RunWait(A_ComSpec ' /c wmic.exe printer get name,default > "' log_path '"', , "Hide")
    
        local printers := []
    
        loop read log_path{
            if A_Index == 1
                continue
        
            local line := A_LoopReadLine
            if line == ""
                continue
    
            local c := 0
            line := StrReplace(line, "  ", " ", , &c)
            while c
                line := StrReplace(line, "  ", " ", , &c)
    
            if line == "Default" or line == "Name"
                continue
    
            if InStr(line, "TRUE"){
                local name := SubStr(line, InStr(line, " "))
                name := StrReplace(name, "`r", "")
                name := StrReplace(name, "`n", "")
                name := "&&&" name "&&&"
                name := StrReplace(name, "&&& ", "")
                name := StrReplace(name, " &&&", "")
                name := StrReplace(name, "&&&", "")    
    
                printers.Push(Map("Name", name, "Default", true))
            } else {
                local name := SubStr(line, InStr(line, " "))
                name := StrReplace(name, "`r", "")
                name := StrReplace(name, "`n", "")
                name := "&&&" name "&&&"
                name := StrReplace(name, "&&& ", "")
                name := StrReplace(name, " &&&", "")
                name := StrReplace(name, "&&&", "")    
    
                printers.Push(Map("Name", name, "Default", false))
            }
        }
        return printers
    }

    SetDefaultPrinter(name){
        n := name
        n := StrReplace(n, "\\", "&&double&&")
        n := StrReplace(n, "\", "&&single&&")
    
        n := StrReplace(n, "&&double&&", "\\\\")
        n := StrReplace(n, "&&single&&", "\\")
    
        local log_path := A_Temp "\set_printer_log.txt"
        RunWait(A_ComSpec ' /c wmic printer where name="' n '" call setdefaultprinter > "' log_path '"', , "Hide")
        this.default := this._GetDefaultPrinter()
    }

    Reload(){
        this._Load()
    }
}