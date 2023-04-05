/*
Author: TheBrunoCA
Github: https://github.com/TheBrunoCA
Original repository: https://github.com/TheBrunoCA/Bruno-Functions
*/

/*
Converts a array of strings into a single string.
@Param p_str_array An array of strings. Not tested on other types.
@Param p_delimiter What will be in between the elements.
@Return String of the entire array separated by p_delimiter.
@Inspiration jim U (https://stackoverflow.com/users/4695439/jim-u)
*/
StrArrayToString(p_str_array, p_delimiter := "`n")
{
    ret_string := ""

    for i, string in p_str_array
    {
        ret_string .=  p_delimiter . string
    }
    
    return SubStr(ret_string, StrLen(p_delimiter)+1)
}
