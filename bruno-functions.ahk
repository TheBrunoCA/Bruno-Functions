/*
@Returns The executable or script name, without extension.
*/
GetAppName(){
    return StrSplit(A_ScriptName, ".")[1]
}

GetExtension(){
    return "." StrSplit(A_ScriptName, ".")[2]
}

/*
Create the dir if necessary before returning it back.
@Param p_dir_path The dir path
@Returns The dir path
*/
NewDir(p_dir_path){
    if DirExist(p_dir_path) == ""
        DirCreate(p_dir_path)
    return p_dir_path
}

/*
Create the ini if necessary before returning it back.
@Param p_ini_path The ini path
@Returns The ini path
*/
NewIni(p_ini_path){
    dir := StrSplit(p_ini_path,"\")
    dir.Pop()
    w := ""
    for i, y in dir{
        w .= y "\"
    }

    dir := NewDir(w)
    
    ext := StrSplit(p_ini_path,".")
    ext := ext[ext.Length]
    if ext != "ini"
        p_ini_path .= ".ini"

    if FileExist(p_ini_path) == ""{
        IniWrite(true, p_ini_path, "auto", "auto_created")
    }
    return p_ini_path
}

IsExcelInstalled(force_close := false){
    isit := false
    try{
        ComObject("Excel.Application")
        if force_close
            ProcessClose("excel.exe")
        
        isit := true
    } catch{
        isit := false
    }
    return isit
}

FileOverwrite(text, file_pattern){
    try{
        FileDelete(file_pattern)
    } catch Error as e{
        if e.Message == "Parameter #1 of FileDelete is invalid."
            throw Error("Parameter #1 of FileOverwrite is invalid.")
    }
    try{
        FileAppend(text, file_pattern, "UTF-8")
    }

    return file_pattern
}

IsStrEmpty(str){
    return str == ""
}

emptyStr := ""