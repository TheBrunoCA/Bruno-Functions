/*
Author: TheBrunoCA
Github: https://github.com/TheBrunoCA
Original repository: https://github.com/TheBrunoCA/Bruno-Functions
*/

/*
Formats a json into a simple array.
@Param p_json The json file.
@Param p_is_path Set to True if p_json is a path.
@Return An array of the json file.
*/
JsonToMap(p_json, p_is_path := false)
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
    ;text := StrReplace(text, "{", "")
    ;text := StrReplace(text, "}", "")
    ;text := StrReplace(text, "`n", "")
    ;text := StrReplace(text, "`":", "`",")
    ;text := StrReplace(text, "`"", "")
    ;text := StrReplace(text, "[", "")
    ;text := StrReplace(text, "]", "")
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
                if(i_line_arr.Has(1))
                {
                    arr.Push(i_line_arr[1])
                    inside_array := false
                    k := StrArrayToString(depth, " ")
                    json_map[depth] := arr
                    depth.Pop()
                    arr := []
                    continue
                }
                inside_array := false
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
            if(!i_linekv.Has(2))
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
            k := StrArrayToString(depth, " ")
            json_map[k . " " . i_linekv[1]] := i_linekv[2]
            continue
        }
        if(InStr(i_line, "["))
        {
            inside_array := true
            i_line_arr := StrSplit(i_line, "[")
            if(i_line_arr.Has(1))
            {
                arr.Push(i_line_arr[1])
                continue
            }
            continue
        }
    }


















    /*
    for i, line in text
    {

        if(InStr(text[i], ":{"))
        {
            text[i] := StrReplace(text[i], ":{", "")
            text[i] := StrReplace(text[i], "`"", "")

            if(InStr(text[i+1], ":{"))
            {
                text[i+1] := StrReplace(text[i+1], ":{", "")
                text[i+1] := StrReplace(text[i+1], "`"", "")

                if(InStr(text[i+2], ":{"))
                {
                    text[i+2] := StrReplace(text[i+2], ":{", "")
                    text[i+2] := StrReplace(text[i+2], "`"", "")

                    if(InStr(text[i+3], ":{"))
                    {
                        text[i+3] := StrReplace(text[i+3], ":{", "")
                        text[i+3] := StrReplace(text[i+3], "`"", "")

                        throw Error("Too in-depth, not yet implemented.")
                    }

                    if(InStr(text[i+3], "`":`""))
                    {
                        text[i+3] := StrReplace(text[i+3], ",", "")
                        text[i+3] := StrReplace(text[i+3], "`"", "")

                        key_val := StrSplit(text[i+3], ":", "`"")
                        json_map[
                            text[i] . " " . 
                            text[i+1] . " " . 
                            text[i+2] . " " . 
                            key_val[1]] := key_val[2]
                        
                        A_Index := i+3
                        continue
                    }
                }
            }
        }
    }


    return json_map
    */
   return text
}

json := A_Desktop . "\example_2.json"

json := JsonToMap(json, true)

#Include StrArrayToString.ahk

MsgBox(StrArrayToString(json))
;MsgBox(json)

;MsgBox(json["quiz sport q1 question"])