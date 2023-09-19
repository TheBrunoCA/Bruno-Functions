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

IsStrEmpty(str){
    return str == ""
}

emptyStr := ""