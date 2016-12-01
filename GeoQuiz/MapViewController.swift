//
//  MapViewController.swift
//  GeoQuiz
//
//  Created by Pei Liu on 11/30/16.
//  Copyright © 2016 Pei Liu. All rights reserved.
//

import UIKit
import MapKit

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, UIAlertViewDelegate  {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Standard
            mapView.delegate = self
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            scoreLabel.text = String(singleton.score)
        }
    }
    
    var popUpMessage: UIAlertView = UIAlertView()
    var singleton : Singleton! = Singleton.sharedInstance
    var randomLocations = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpMessage.addButtonWithTitle("OK")
        singleton.originalAllPins = loadFileToList()!
        loadMapPins(singleton.originalAllPins)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        scoreLabel.text = String(singleton.score)
        if singleton.currentPin != nil && singleton.answerCorrect {
            removeMark(singleton.currentPin!)
            singleton.mapPinStore.removePin(singleton.currentPin!)
            singleton.answerCorrect = false
        }
        if singleton.mapPinStore.allPins.count == 0 {
            print("You won! Quiz completed.")
            self.popUpMessage.title = "You won! Quiz completed."
            self.popUpMessage.show()
        }
    }
    
    func generateFourRandomLocation() {
        singleton.removablePins = loadFileToList()!
        randomLocations.removeAll()
        randomLocations.append((singleton.currentPin?.hidetitle!)!)
        singleton.removablePins = loadFileToList()!
        var count = 0
        repeat {
            let temp = randomPullFromPins()[1]
            if (singleton.currentPin?.hidetitle! != temp) {
                randomLocations.append(temp)
                count = count + 1
            }
        } while (count < 3)
        singleton.fourLocations.removeAll()
        singleton.fourLocations.append(randomPullFromFourPins())
        singleton.fourLocations.append(randomPullFromFourPins())
        singleton.fourLocations.append(randomPullFromFourPins())
        singleton.fourLocations.append(randomPullFromFourPins())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController.contentViewController
        let annotationView = sender as? MKAnnotationView
        singleton.currentPin = annotationView?.annotation as? MapPin
        //annotationView?.removeFromSuperview()
        
        generateFourRandomLocation()
        
        if segue.identifier == "ShowSelection" {
            if let vc = destination as? TableViewController {
                vc.title = "\(singleton.currentPin!.title!)"
            }
        }
    }
    
    // When user select the pin, segue to tableView
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        performSegueWithIdentifier("ShowSelection", sender: view)
    }
    
    /* change pinColor
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        //if annotationView.selected {
            annotationView.pinTintColor = UIColor.brownColor()
        //}

        return annotationView
    }*/
    
    func clearMarks() {
        mapView?.removeAnnotations(mapView.annotations)
    }
    
    func removeMark(mark: MapPin) {
        mapView?.removeAnnotation(mark)
    }
    
    func addMark(mark: MapPin) {
        mapView?.addAnnotation(mark)
        //mapView?.showAnnotations([mark], animated: true)
    }
    
    func randomPullFromPins() -> [String] {
        let rand = Int(arc4random_uniform(UInt32(singleton.removablePins.count)))
        return singleton.removablePins.removeAtIndex(rand)
    }
    
    func randomPullFromFourPins() -> String {
        let rand = Int(arc4random_uniform(UInt32(randomLocations.count)))
        return randomLocations.removeAtIndex(rand)
    }
    
    func loadMapPins(lists: [[String]]?) {
        let mapPinStore = singleton.mapPinStore
        
        for list in lists! {
            let country = list[0]
            let capital = list[1]
            var latitudeStr = list[2]
            var longitudeStr = list[3]
            var latitude = 0.0
            var longitude = 0.0
            
            if latitudeStr.characters.last == "N" {
                latitudeStr.removeAtIndex(latitudeStr.characters.indices.last!) // remove last letter
                latitude = NSNumberFormatter().numberFromString(latitudeStr)!.doubleValue
            } else {
                latitudeStr.removeAtIndex(latitudeStr.characters.indices.last!) // remove last letter
                latitude = NSNumberFormatter().numberFromString(latitudeStr)!.doubleValue
                latitude = -latitude
            }
            
            if longitudeStr.characters.last == "E" {
                longitudeStr.removeAtIndex(longitudeStr.characters.indices.last!) // remove last letter
                longitude = NSNumberFormatter().numberFromString(longitudeStr)!.doubleValue
            } else {
                longitudeStr.removeAtIndex(longitudeStr.characters.indices.last!) // remove last letter
                longitude = NSNumberFormatter().numberFromString(longitudeStr)!.doubleValue
                longitude = -longitude
            }
             
            let pin = MapPin(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: country, subtitle: capital)
            mapPinStore.addPin(pin)
            pin.hideCapital()
            addMark(pin)
        }

    }

    func loadFileToList() -> [[String]]? {
        
        let mainBundle = NSBundle.mainBundle()
        let filePath : String? = mainBundle.pathForResource("location", ofType: "txt")
        var result : [[String]] = []
        // Make sure the file exists!
        if (filePath != nil) {
            //print("\n*********Found the File**********\n")
            do {
                let words: String? = try String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)
                // Now, create an array by separating on newline characters.
                var lines = words!.componentsSeparatedByString("\n")
                lines.removeLast()
                for line in lines {
                    let newLine = line.componentsSeparatedByString("\t")
                    //print(newLine) // Debug only
                    result.append(newLine)
                }
                return result
            } catch let err as NSError {
                //do sth with Error
                print(err)
            }
        } else {
            print("\n*Can not find the File!*\n")
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

