//
//  MapPin.swift
//  GeoQuiz
//
//  Created by Pei Liu on 11/30/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import MapKit

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var hidetitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.hidetitle = subtitle
    }
    
    func hideCapital() {
        self.subtitle = "???"
    }
    
    func showCapital() {
        self.subtitle = self.hidetitle
    }
}
