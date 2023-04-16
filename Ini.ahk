#Include bruno-functions.ahk
Class Ini{
    __New(ini_path){
        this.path := NewIni(ini_path)
    }

    __Item[section := "", key := "", default := ""] {
        get => this.ReadItem(section, key, default)
        set => this.WriteItem(section, key, value)
    }

    ReadItem(section, key, defaut){
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

    WriteItem(section, key, value){
        if value == ""
            throw Error("Value must not be empty.", "WriteItem", "WriteItem")
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
}