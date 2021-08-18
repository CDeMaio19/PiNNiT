//
//  User.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 7/29/21.
//

import UIKit


class User{
    
    var ID : String
    var FirstName : String
    var LastName : String
    var Email : String
    var Pins : Array<Pin>
    
    init() {
        self.FirstName = ""
        self.LastName = ""
        self.ID = ""
        self.Email = ""
        self.Pins = Array<Pin>()
        
    }
    
    
    
}


