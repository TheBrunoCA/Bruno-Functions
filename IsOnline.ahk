/*
Checks a list of websites to determine if it is online.
@Param p_method "fast" will search less websites.
@Returns The ini path
*/
IsOnline(p_method := "fast"){
    fast := [
        "https://github.com"
        ,"https://google.com"
        ,"https://amazon.com"
    ]
    slow := fast.Clone()
    slow.Push(
        "https://openai.com"
        ,"https://autohotkey.com"
        ,"https://facebook.com"
        ,"https://itch.io"
        ,"https://brave.com"
        ,"https://duckduckgo.com"
        ,"https://downdetector.com"
    )

    meth := p_method := "fast" ? fast : slow

    for i, site in meth{
        page := ComObject("Msxml2.XMLHTTP")
        page.Open("GET", site, true)
        try{
            page.Send()
        }
        catch Error as e{
            if InStr(e.Message, "(0x80070005)"){
                continue
            }
            else throw e
        }
        

        while page.readyState != 4
            sleep 50

        if page.status == 200
            return true
    }
    return false
}