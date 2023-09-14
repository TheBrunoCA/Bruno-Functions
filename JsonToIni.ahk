/*
Author: TheBrunoCA
Github: https://github.com/TheBrunoCA
Original repository: https://github.com/TheBrunoCA/Bruno-Functions
*/

/*
Converts a simple json into a ini file..
@Param p_json The json file.
@Param p_path_to_save Where to save the ini file.
@Param p_section_name Main section's name
@Param p_is_path Set to True if p_json is a path.
@Return A Ini of the json file.
*/
#Requires autohotkey v2.0
JsonToIni(p_json, p_path_to_save, p_section_name := "DEFAULT", p_is_path := false, p_append := false)
{

    StrArrayToString(p_str_array, p_delimiter := "`n")
    {
        if !p_str_array.HasMethod("Pop")
            throw Error("p_str_array must be a Array", "StrArrayToString")

        ret_string := ""

        for i, string in p_str_array
        {
            if string == ""
                continue
            
            ret_string .= string . p_delimiter
        }
    
        return ret_string
    }

    RemoveSpacesOutStrings(p_text)
    {
        p_text_array := StrSplit(p_text)
        is_str := false
        arr := []

        for i, word in p_text_array
        {
            if(word != " " || is_str)
            {
                if(word == "`"")
                {
                    is_str := !is_str
                }
                arr.Push(word)
            }
        }

        return StrArrayToString(arr, "")
    }

    StrPutInPlace(p_haystack, p_needle, p_before := "", p_after := "", p_ignore_strings := true, p_substitute := false)
    {
        p_text_array := StrSplit(p_haystack)
        is_str := false
        arr := []

        for i, word in p_text_array
        {
            if(word == p_needle && !is_str)
            {
                w := p_substitute ? "" : p_needle
                arr.Push(p_before . w . p_after)
                continue
            }
            if(word == "`"" && p_ignore_strings)
            {
                is_str := !is_str
            }
            arr.Push(word)
        }
        return StrArrayToString(arr, "")
    }

    text .= p_json

    if(p_is_path)
    {
        if(FileExist(p_json) == "")
        {
            throw Error("p_json file do not exist.", "JsonToIni")
        }

        text := FileRead(p_json)

        if(text == "")
        {
            throw Error("p_json is a empty file.", "JsonToIni")
        }
    }

    text := StrReplace(text, "`n", "")
    text := StrReplace(text, "`r", "")
    text := StrReplace(text, "`t", "")

    text := RemoveSpacesOutStrings(text)
    text := StrPutInPlace(text, ",", , "`n")
    text := StrPutInPlace(text, ":", , ":=", , true)
    text := StrReplace(text, ":={", ":{")
    text := StrReplace(text, ":=[", ":[")
    text := StrPutInPlace(text, "{", , "`n")
    text := StrPutInPlace(text, "}", "`n", "`n")
    text := StrPutInPlace(text, "[", , "`n")
    text := StrPutInPlace(text, "]", "`n")
    text := StrReplace(text, "},`n", "}`n")
    text := StrReplace(text, "],`n", "]`n")
    
    arr_txt := StrSplit(text, "`n")
    
    depth := []
    in_array := false
    result := "[" . p_section_name . "]`n"

    for i, i_line in arr_txt
    {
        if in_array
        {
            i_line := StrReplace(i_line, ":=", ":")
            result .= i_line
            
            if i_line == "]"
            {
                in_array := false
                result .= "`n"
            }
            continue
            
        }
        
        if i_line == ""
            continue
        if i_line == "{"
        {
            depth.push("")
            continue
        }
        if i_line == "}"
        {
            if depth.Length < 1
            {
                throw Error("Error while parsing.", "JsonToIni")
            }
            depth.pop()
            continue
        }
        
        
        
        if InStr(i_line, ":{")
        {
            i_line := StrReplace(i_line, "`"", "")
            depth.push(StrSplit(i_line, ":{")[1])
            continue
        }
        
        if InStr(i_line, ":=")
        {
            i_line := StrReplace(i_line, ":=", "=")
            i_line := StrReplace(i_line, "`"", "")
            i_line .= "temprandom"
            if InStr(i_line, ",temprandom")
                i_line := StrReplace(i_line, ",temprandom", "")
            else
                i_line := StrReplace(i_line, "temprandom", "")
            result .= StrArrayToString(depth, ".") . i_line . "`n"
            continue
        }
        
        if InStr(i_line, ":[")
        {
            i_line := StrReplace(i_line, "`"", "")
            i_line := StrReplace(i_line, ":[", "=[")
            result .= StrArrayToString(depth, ".") . i_line
            in_array := true
            continue
        }
    }
    
    if(FileExist(p_path_to_save) != "" && p_append == false)
    {
        FileDelete(p_path_to_save)
    }
    dir := StrSplit(p_path_to_save, "\")
    dir.Pop()
    dir := StrArrayToString(dir, "\")
    if DirExist(dir) == ""
        DirCreate(dir)
    
    FileAppend(result, p_path_to_save)
    
    return result
    
}