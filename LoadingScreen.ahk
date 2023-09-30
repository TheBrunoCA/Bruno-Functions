
class LoadingScreen{
    __New(text, title, &progressVar, maxProgress, color := "BackgroundGray cGreen", onCloseCallback := this._exitAappCallback) {
        this.progressVar    := &progressVar
        this.maxProgress    := maxProgress
        this.gLoading       := Gui("-MaximizeBox -MinimizeBox -Caption -Border")
        this.gLoading.Title := title
        this.gLoading.OnEvent("Close", onCloseCallback)
        this.gTxt           := this.gLoading.AddText(, text)
        this.gBar           := this.gLoading.AddProgress(color " w150", 0)
        this.gPercent       := this.gLoading.AddText("w50", "0%")
        this.fUpdateProgress:= ObjBindMethod(this, "_progressUpdate")
    }

    start(updateInterval := 100){
        SetTimer(this.fUpdateProgress, updateInterval)
        this.gLoading.Show()
    }

    stop(){
        SetTimer(this.fUpdateProgress, 0)
        this.gLoading.Destroy()
        
    }

    _progressUpdate(args*){
        progress            := %this.progressVar%
        maxProgress         := this.maxProgress
        if progress >= maxProgress{
            return
        }
        percent             := Round(progress/maxProgress*100)
        this.gBar.Value     := percent
        this.gPercent.Value := percent "%"
    }

    _exitAappCallback(){
        ExitApp()
    }
}