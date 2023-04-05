/*
@Returns The executable or script name, without extension.
*/
GetAppName(){
    return StrSplit(A_ScriptName, ".")[1]
}

Class IniFile{
    __New(ini_path, delimiter := " ", create_if_not := false) {
        this.ini_path := ini_path
        this.delimiter := delimiter
        this.create_if_not := create_if_not
        this.ini_file := this.__construct_ini()
    }

    GetVal(sec_key, add_if_not := false, default := "default-item", debug := false){
        try {
            return this.ini_file[sec_key]
        } catch Error as e {
            if(e.Message == "Item has no value."){
                if(debug){
                    e.Message := "Ini file has no such section, key or both!"
                    throw e
                }
                sec_key := StrSplit(sec_key, this.delimiter)
                IniWrite(default, this.ini_path, sec_key[1], sec_key[2])
                return default
            }
        }
    }

    __construct_ini(){
        file := Map()
        try {
            sections := IniRead(this.ini_path)
        } catch Error as e {
            if(e.Message == "The requested key, section or file was not found." && this.create_if_not){
                IniWrite("true", this.ini_path, "built-in", "auto-created")
                sections := IniRead(this.ini_path)
            }
            else{
                throw e
                ExitApp(100)
            }
        }
        sections := StrSplit(sections, "`n")
        s_i := 1
        loop sections.Length{
            keys := IniRead(this.ini_path, sections[s_i])
            keys := StrSplit(keys, "`n")
            v := false
            loop keys.Length{
                k_v := StrSplit(keys[A_Index], "=")
                file[sections[s_i] this.delimiter k_v[1]] := k_v[2]
            }
            s_i++
        }
        return file
    }
}