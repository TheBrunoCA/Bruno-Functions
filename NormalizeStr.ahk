NormalizeStr(str, toUpper := false){
    chars := Map( "a" , "áàâǎăãảạäåāąấầẫẩậắằẵẳặǻ"
    , "c" , "ćĉčċç"
    , "d" , "ďđð"
    , "e" , "éèêěĕẽẻėëēęếềễểẹệ"
    , "g" , "ğĝġģ"
    , "h" , "ĥħ"
    , "i" , "íìĭîǐïĩįīỉịĵ"
    , "k" , "ķ"
    , "l" , "ĺľļłŀ"
    , "n" , "ńňñņ"
    , "o" , "óòŏôốồỗổǒöőõøǿōỏơớờỡởợọộ"
    , "s" , "ṕṗŕřŗśŝšş"
    , "t" , "ťţŧ"
    , "u" , "úùŭûǔůüǘǜǚǖűũųūủưứừữửựụ"
    , "w" , "ẃẁŵẅýỳŷÿỹỷỵ"
    , "z" , "źžż")

    newText := str
    if toUpper
        newText := StrUpper(newText)

    for a, b in chars{
        upperA := StrUpper(a)
        upperB := StrUpper(b)
        newText := RegExReplace(newText, "[" b "]", a)
        newText := RegExReplace(newText, "[" upperB "]", upperA)
    }
    return newText
}