class BatWrite {
    __New(p_bat_path, p_append := false) {
        dir := StrSplit(p_bat_path, "\")
        dir.Pop()
        tdir := ""
        for i, w in dir{
            tdir .= w . "\"
        }
        dir := tdir
        if DirExist(dir) == ""
            DirCreate(dir)

        ext := StrSplit(p_bat_path, ".")
        if ext[ext.Length] != "bat"
            p_bat_path .= ".bat"

        this.path := p_bat_path
        if p_append == false {
            if FileExist(this.path) != ""
                FileDelete(this.path)
        }

        FileAppend("@CHCP 1252 >NUL`n", this.path)
    }

    DeleteSelf() {
        if FileExist(this.path) != ""
            FileDelete(this.path)
    }


    MoveFile(p_from, p_to) {
        w := "
        (
        MOVE /Y "{1}" "{2}"

        )"

        w := Format(w, p_from, p_to)

        FileAppend(w, this.path)
    }

    DeleteFile(p_file){
        w := "
        (
        DEL "{1}"

        )"

        w := Format(w, p_file)

        FileAppend(w, this.path)
    }

    Start(p_path){
        w := "
        (
        START "" "{1}"

        )"

        w := Format(w, p_path)

        FileAppend(w, this.path)
    }

    TimeOut(p_seconds){
        w := "
        (
        TIMEOUT /T {1} /NOBREAK

        )"

        w := Format(w, p_seconds)

        FileAppend(w, this.path)
    }

    DeleteLastLine(){
        file := FileRead(this.path)
        if file == ""
            return
        file := StrSplit(file, "`n")
        
        for i in file.Length{
            last := file.Pop()
            if last != ""
                break
        }
        ret := ""
        for i, w in file{
            ret .= w . "`n"
        }
        try{
            FileDelete(this.path)
        }
        FileAppend(ret, this.path)
    }

    CreateShortcut(p_from, p_to, p_type := "Powershell"){
        if p_type != "Powershell" && p_type != "Mklink"
            throw Error("p_type can only be `"Powershell`" or `"Mklink`"!")
        ext := StrSplit(p_to, ".")
        if ext[ext.Length] != "lnk"
            p_to .= ".lnk"

        switch p_type {
            case "Powershell":
                {
                    w := "
                    (
                    powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('{1}');$s.TargetPath='{2}';$s.Save()"
                    
                    )"
                    w := Format(w, p_to, p_from)
                    FileAppend(w, this.path)
                }
            default:
                {
                    w := "
                    (
                    mklink "{1}" "{2}"
                    
                    )"
                    w := Format(w, p_to, p_from)
                    FileAppend(w, this.path)
                }
        }
    }
}