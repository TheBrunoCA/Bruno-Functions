

downloadFile(url, filename, progress := true, overwrite := true, onCloseCallback := false){
    if not overwrite and FileExist(filename)
        return


    last_size := 0
    progressGui := Gui("AlwaysOnTop", "Download em andamento")

    if onCloseCallback
        progressGui.OnEvent("Close", onCloseCallback)

    conLength := ""

    try{
        obj := ComObject("WinHttp.WinHttpRequest.5.1")
        obj.Open("HEAD", url)
        obj.Send()
        conLength := obj.GetResponseHeader("Content-Length")
    }

    addProgressBar := conLength != "" and progress

    progressName := progressGui.AddText(, "Baixando " filename)

    if addProgressBar
        progressBar := progressGui.AddProgress("w500 cGreen", 0)

    progressValue := progressGui.AddText("w300", "")
    progressDelta := progressGui.AddText("w300", "")
    progressGui.Show()
    SetTimer(__updateProgress, 100)
    currentSize := 0
    Download(url, filename)
    SetTimer(__updateProgress, 0)
    progressValue.Value := "Finalizado"
    Sleep 1000
    progressGui.Destroy()

        __updateProgress(){
            try{
                currentSize := FileGetSize(filename)
            }
            if addProgressBar
                progressBar.Value := Round(currentSize / conLength * 100)

            delta_size := Round((currentSize - last_size) / 1000 * 10)
            last_size := currentSize
            progressValue.Value := "Baixados: " Round(currentSize/1000) " KB"
            
            if addProgressBar
                progressValue.Value .= " / " conLength / 1000 " KB"

            progressDelta.Value := "Velocidade: " delta_size " KB/s"
        }
}