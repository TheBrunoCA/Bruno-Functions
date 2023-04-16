Class DynamicClass{
    __New(arg*) {
        this.__Load(arg*)
    }

    __Load(arg*){
        
    }

    Reload(arg*){
        this.__BeforeReload()
        this.__Load(arg*)
        this.__AfterReload()
    }

    __BeforeReload(){

    }

    __AfterReload(){

    }
}