Class IniParser{
    __New(p_ini_path, p_separator := " ", p_create_if_not := false) {
        this.ini_path := p_ini_path
        this.separator := p_separator
        this.create_if_not := p_create_if_not
        this.ini_file := this.__construct_ini()
    }

    GetVal(p_sec_key, p_add_if_not := false, p_default := "default-item", p_debug := false){
        try {
            return this.ini_file[p_sec_key]
        } catch Error as e {
            if(e.Message == "Item has no value."){
                if(p_debug){
                    e.Message := "Ini file has no such section, key or both!"
                    throw e
                }
                p_sec_key := StrSplit(p_sec_key, this.separator)
                IniWrite(p_default, this.ini_path, p_sec_key[1], p_sec_key[2])
                return p_default
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
                file[sections[s_i] this.separator k_v[1]] := k_v[2]
            }
            s_i++
        }
        return file
    }
}