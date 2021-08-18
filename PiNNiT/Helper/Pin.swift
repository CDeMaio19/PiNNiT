//
//  Pin.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 8/10/21.
//

import UIKit
import MapKit

class Pin {
    var Name: String
    var Address: String
    var Location: CLLocationCoordinate2D
    var Tag: String
    
    init(){
        self.Name = ""
        self.Address = ""
        self.Location = CLLocationCoordinate2D()
        self.Tag = ""
        
    }
    
    init(name: String, address: String, location: CLLocationCoordinate2D, tag: String) {
        self.Name = name
        self.Address = address
        self.Location = location
        self.Tag = tag
    }

}
