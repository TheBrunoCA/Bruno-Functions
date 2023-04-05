/*
@Returns The executable or script name, without extension.
*/
GetAppName(){
    return StrSplit(A_ScriptName, ".")[1]
}


; Wow, so many things in here now.