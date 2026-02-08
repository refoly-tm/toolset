package main

import (
    "fmt"
)

// UI elements

func prompt(message string){
    fmt.Print(message)
}


// i dont know how function arguments work in go so il stick to global for now
func sweep(){

}


func main(){

    var ip_range = prompt("[INP] Ip Range")

    for( int ip=1 , ip < 255; ++ip){
        prompt(ip)
    }

}
