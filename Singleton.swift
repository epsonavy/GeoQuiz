//
//  Singleton.swift
//  GeoQuiz
//
//  Created by Pei Liu on 11/30/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

class Singleton {
    static let sharedInstance = Singleton()
    
    var score = 0
    
    // Store Random pick 4 locations
    var fourLocations = [String]()
    
    var answerCorrect = false
    var originalAllPins = [[String]]()
    var removablePins = [[String]]()
    
    var currentPin : MapPin?
    
    // Store all pins
    let mapPinStore = MapPinStore()
}
