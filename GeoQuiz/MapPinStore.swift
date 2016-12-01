//
//  MapPinStore.swift
//  GeoQuiz
//
//  Created by Pei Liu on 11/30/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

class MapPinStore {
    var allPins = [MapPin]()
    
    func addPin(pin: MapPin) {
        allPins.append(pin)
    }
    
    func removePin(pin: MapPin) {
        if let index = allPins.indexOf(pin) {
            allPins.removeAtIndex(index)
        }
    }
    
    func getCount() -> Int {
        return allPins.count
    }

}
