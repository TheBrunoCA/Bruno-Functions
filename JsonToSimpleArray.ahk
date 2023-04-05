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
JsonToSimpleArray(p_json, p_is_path := false)
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
    text := StrReplace(text, "{", "")
    text := StrReplace(text, "}", "")
    text := StrReplace(text, "`n", "")
    text := StrReplace(text, "`":", "`",")
    text := StrReplace(text, "`"", "")
    text := StrReplace(text, "[", "")
    text := StrReplace(text, "]", "")

    return StrSplit(text, ",", " ")
}