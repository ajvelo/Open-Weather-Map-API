//
//  ViewController.swift
//  Open Weather Map API
//
//  Created by Andreas Velounias on 02/10/2018.
//  Copyright © 2018 Andreas Velounias. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let apiKey = API_KEY
    let locationManager = CLLocationManager()
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    let coreData = CoreData()
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImgView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let gradientLayer: CAGradientLayer = {
        let caGradient = CAGradientLayer()
        caGradient.frame = UIScreen.main.bounds
        caGradient.colors = [UIColor.cyan.cgColor, UIColor.blue.cgColor]
        caGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        caGradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        return caGradient
    }()

    @IBAction func refreshBtnAction(_ sender: UIButton) {
        if Utility.isConnected() {
            
            locationManager.startUpdatingLocation()
        }
        else {
            locationLabel.text = "No Internet Connection"
        }
    }
    
    func addSpinner() {
        self.view.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addSpinner()
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        if Utility.isConnected() {
            
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        }
        else {
            locationLabel.text = "No Internet Connection"
            loadData()
        }
    }
    
    // MARK: Load from Core Data
    func loadData() {
        
        // If user is not connected to the internet, then load from CoreData
        let load = coreData.loadData()
        
        self.locationLabel.text = load.location
        self.conditionImgView.image = UIImage(named: load.conditionImageView)
        self.conditionLabel.text = load.conditionLabel
        self.temperatureLabel.text = load.temperatureLabel + " °C"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        self.dayLabel.text = dateFormatter.string(from: load.date)
    }
    
    // MARK: LocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        sendRequest(lat: lat, long: long)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    // MARK: Alamofire Request
    func sendRequest(lat: CLLocationDegrees, long: CLLocationDegrees) {
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric").responseJSON { (response) in
            
            self.spinner.stopAnimating()
            self.spinner.removeFromSuperview()
            
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let jsonWind = jsonResponse["wind"]
                let windSpeed = jsonWind["speed"].stringValue
                let iconName = jsonWeather["icon"].stringValue
                
                self.locationLabel.text = jsonResponse["name"].stringValue
                self.conditionImgView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue + "\nWindspeed of: \(windSpeed) m/s"
                self.temperatureLabel.text = String(Int(round(jsonTemp["temp"].doubleValue))) + " °C"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                let data = Model(location: jsonResponse["name"].stringValue,
                                 conditionImageView: jsonWeather["icon"].stringValue,
                                 conditionLabel: self.conditionLabel.text!, // Save UILabel text here as it has windspeed attached.
                                 temperatureLabel: String(Int(round(jsonTemp["temp"].doubleValue))) + " °C",
                                 date: date)
                
                self.coreData.saveData(model: data)
            }
        }
    }
}

