/*
Author: TheBrunoCA
Github: https://github.com/TheBrunoCA
Original repository: https://github.com/TheBrunoCA/Bruno-Functions
*/

/*
Downloads the page's content and returns it. Not Async.
@Param p_url The url for the page.
@Return The page's content.
*/
GetPageContent(p_url)
{
    page := ComObject("MSXML2.XMLHTTP.6.0")
    page.Open("GET", p_url, true)

    loop 10 {
        try {
            page.Send()
            while (page.readyState != 4)
            {
                Sleep(50)
            }
            break
        }
        catch Error as e {
            if InStr(e.Message, "(0x80070005)") {
                sleep 50
                continue
            }
            else
                throw e
        }
    }
    return page.ResponseText
}