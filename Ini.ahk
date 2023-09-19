#Include bruno-functions.ahk
Class Ini{
    __New(ini_path){
        this.path := NewIni(ini_path)
    }

    __Item[section := "", key := "", default := ""] {
        get => this.readItem(section, key, default)
        set => this.writeItem(section, key, value)
    }

    readItem(section, key, defaut){
        try {
            if section != "" and key != ""
                return IniRead(this.path, section, key)
            if section != ""
                return IniRead(this.path, section)
            return IniRead(this.path)
        } catch Error as e {
            try{
                IniWrite(defaut, this.path, section, key)
            }
            return defaut
        }
    }

    writeItem(section, key, value){
        if value == ""
            IniDelete(this.path, section, key)
        if section == ""
            throw Error("Section must not be empty.", "WriteItem", "WriteItem")
        try{
            if section != "" and key != ""{
                IniWrite(value, this.path, section, key)
                return true
            }
            if section != ""{
                IniWrite(value, this.path, section)
                return true
            }
            return false
        }
    }

    hasValue(section, key){
        if this.readItem(section, key, "") == ""{
            return false
        }
        return true
    }

    hasKey(section, key){
        if !InStr(this.readItem(section, "", ""), key){
            return false
        }
        return true
    }

    hasSection(section){
        if !InStr(this.readItem("", "", ""), section){
            return false
        }
        return true
    }

    delete(section, key := ""){
        if key == ""{
            IniDelete(this.path, section)
            return
        }
        IniDelete(this.path, section, key)
    }
}