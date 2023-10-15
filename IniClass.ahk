#Requires AutoHotkey v2.0

NewDir(dir_path){
    if not DirExist(dir_path)
        try DirCreate(dir_path)
    return dir_path
}

Class IniClass{
    __New(path) {
        this.directory := StrSplit(path, "\")
        this.directory.Pop()
        for dir in this.directory{
            d .= dir "\"
        }
        this.directory := NewDir(d)
        this.path := InStr(path, ".ini") ? path : path ".ini"
    }

    GetSections(){
        local sections := StrSplit(IniRead(this.path), "`n")
        for index, section in sections{
            if Trim(section) == ""
                sections.RemoveAt(index)
        }
        return sections
    }

    GetKeys(section){
        local keys_values := StrSplit(IniRead(this.path), "`n")
        local keys := []
        for index, key in keys_values{
            if Trim(key) == ""
                continue
            local k := StrSplit(key, "=")
            keys.Push(k[1])
        }
        return keys
    }

    GetValue(section, key, default := ""){
        return IniRead(this.path, section, key, default)
    }

    SetValue(section, key, value){
        IniWrite(value, this.path, section, key)
    }
}