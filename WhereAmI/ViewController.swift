//
//  ViewController.swift
//  WhereAmI
//
//  Created by NanYar on 20.11.14.
//  Copyright (c) 2014 NanYar. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate
{
    // @IBOutlets
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!    
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var nearestAddressLabel: UILabel!
    
    var locationManager: CLLocationManager! // = implicitly unwrapped optional (actual value = nil)
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self // = this ViewController (self) is managing the locationManager (.delegate)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // = GPS Accuracy
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    // invoked when new locations are available
    // locations is an array of CLLocation objects in chronological order
    {
        let userLocation: CLLocation = locations[0] as CLLocation
        latitudeLabel.text = "\(userLocation.coordinate.latitude)"
        longitudeLabel.text = "\(userLocation.coordinate.longitude)"
        courseLabel.text = "\(userLocation.course)"
        speedLabel.text = "\(userLocation.speed)"
        altitudeLabel.text = "\(userLocation.altitude)"
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler:
        { (placemarks, error) in
            if error == nil
            {
                let myPlacemark: CLPlacemark = CLPlacemark(placemark: placemarks?[0] as CLPlacemark)
                
                // nil - Werte ausblenden
                var subThoroughfare: String
                if myPlacemark.subThoroughfare != nil
                {
                    subThoroughfare = myPlacemark.subThoroughfare
                }
                else
                {
                    subThoroughfare = ""
                }
                
                var thoroughfare: String
                if myPlacemark.thoroughfare != nil
                {
                    thoroughfare = myPlacemark.thoroughfare
                }
                else
                {
                    thoroughfare = ""
                }
                
                self.nearestAddressLabel.text =
                    "\"\(myPlacemark.name)\"\n\n" +
                    "\(thoroughfare) \(subThoroughfare)\n" +
                    "\(myPlacemark.ISOcountryCode)-\(myPlacemark.postalCode) \(myPlacemark.locality)\n" +
                    "\(myPlacemark.administrativeArea)\n" +
                    "\(myPlacemark.country)"
            }
            else
            {
                self.nearestAddressLabel.text = "Error: \(error)"
            }
        } )
        //println(userLocation)
    }
}
