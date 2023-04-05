/*
Author: TheBrunoCA
Github: https://github.com/TheBrunoCA
Original repository: https://github.com/TheBrunoCA/Bruno-Functions
*/

/*
Formats a json into a Map.
@Param p_json The json file.
@Param p_separator What will separate the key elements.
@Param p_is_path Set to True if p_json is a path.
@Return A Map of the json file.
*/
JsonToMap(p_json, p_separator := " ", p_is_path := false)
{
    text := ""

    if(p_is_path)
    {
        if(FileExist(p_json) == "")
        {
            throw Error("p_json file do not exist.")
        }

        text := FileRead(p_json)

        if(text == "")
        {
            throw Error("p_json is a empty file.")
        }
    }

    text := StrReplace(text, ": ", ":")
    text := StrReplace(text, "  ", "")
    text := StrReplace(text, "{", "")
    text := StrReplace(text, "", "")
    text := StrReplace(text, "`"", "")
    text := StrReplace(text, ",", "")
    text := StrSplit(text, "`n")
    text.Pop()

    json_map := Map()

    depth := []
    inside_array := false
    arr := []

    for i, i_line in text
    {
        if(inside_array)
        {
            if(InStr(i_line, "]"))
            {
                i_line_arr := StrSplit(i_line, "]")
                if(i_line_arr[1] != "")
                {
                    arr.Push(i_line_arr[1])
                    inside_array := false
                    k := StrArrayToString(depth, p_separator)
                    json_map[depth] := arr
                    depth.Pop()
                    arr := []
                    continue
                }
                inside_array := false
                k := StrArrayToString(depth, p_separator)
                json_map[k] := arr
                depth.Pop()
                arr := []
                continue
            }
            arr.Push(i_line)
            continue
        }
        
        if(InStr(i_line, "}"))
        {
            depth.Pop()
            i_line := StrReplace(i_line, "}", "")
            if(i_line == "")
            {
                continue
            }
        }
        
        if(InStr(i_line, ":"))
        {
            i_linekv := StrSplit(i_line, ":")
            if(i_linekv[2] == "")
            {
                depth.Push(i_linekv[1])
                continue
            }
            if(InStr(i_linekv[2], "["))
            {
                inside_array := true
                depth.Push(i_linekv[1])
                continue
            }
            k := StrArrayToString(depth, p_separator)
            json_map[k . p_separator . i_linekv[1]] := i_linekv[2]
            continue
        }
        if(InStr(i_line, "["))
        {
            inside_array := true
            i_line_arr := StrSplit(i_line, "[")
            if(i_line_arr[1] != "")
            {
                arr.Push(i_line_arr[1])
                continue
            }
            continue
        }
    }

    return json_map
}