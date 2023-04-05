/*
Author: TheBrunoCA
Github: https://github.com/TheBrunoCA
Original repository: https://github.com/TheBrunoCA/Bruno-Functions
*/

/*
Gets the next element from an array or return default.
@Param p_array The array in which to search.
@Param p_key The key to search for in p_array.
@Param p_default The default value in case p_key is not found.
*/
GetFromSimpleArray(p_array, p_key, p_default := "")
{
    if(Type(p_array) != "Array")
    {
        throw Error("p_array is not array.")
    }
    
    for i, v in p_array
    {
        if(v == p_key)
        {
            return p_array[i+1]
        }
    }

    return p_default
}