//
//  Pin.swift
//  PiNNiT
//
//  Created by Christopher DeMaio on 8/10/21.
//

import UIKit
import MapKit
import Firebase

class Pin {
    var Name: String
    var Address: String
    var Location: GeoPoint
    var Tag: String
    var Public: Bool
    var Creator: String
    
    init(){
        self.Name = ""
        self.Address = ""
        self.Location = GeoPoint(latitude: 0.0, longitude: 0.0)
        self.Tag = ""
        self.Public = true
        self.Creator = ""
        
    }
    
    init(name: String, address: String, location: CLLocationCoordinate2D, tag: String, privacy: Bool, Id:String) {
        self.Name = name
        self.Address = address
        self.Location = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        self.Tag = tag
        self.Public = privacy
        self.Creator = Id
    }

}
