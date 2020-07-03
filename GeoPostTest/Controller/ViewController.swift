//
//  ViewController.swift
//  GeoPostTest
//
//  Created by Roma Filipenko on 03.07.2020.
//  Copyright © 2020 Roma&Co. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    //MARK: Properties

    @IBOutlet private weak var timerMinutes: UITextField!
    @IBOutlet private weak var startTimerButton: UIButton!
    @IBOutlet private weak var stopTimerButton: UIButton!
    
    var timer: Timer?
    let geoPoster = GeoAPI()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        startTimerButton.isEnabled = false
        stopTimerButton.isEnabled = false
        setUpLocationManager()
    }
    
    //MARK: Geo&Time Data
    
    func setUpLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func getGeo() -> (Double?, Double?) {
        
        let currentLocation = locationManager.location
        guard let latitude = currentLocation?.coordinate.latitude else { return (nil, nil) }
        guard let longitude = currentLocation?.coordinate.longitude else { return (nil, nil) }
        
        let lat = Double(latitude)
        let lon = Double(longitude)
        
        return (lat, lon)
    }
    
    func getGeoData() -> GeoModel {
        let coordinate = getGeo()
        let lat = coordinate.0
        let lon = coordinate.1
        
        let time = Date().timeIntervalSince1970
        
        return GeoModel(time: time, lat: lat!, lon: lon!)
    }
    
    //MARK: Start/Stop Timer

    @IBAction private func startTimer(_ sender: UIButton) {
        guard let numOfMinutes = Int(timerMinutes.text!) else { return }
        let numberOfMinutes = Double( numOfMinutes * 60 )
        
        timer = Timer.scheduledTimer(withTimeInterval: numberOfMinutes, repeats: false) { [weak self] timer in
            
            self?.startTimerButton.isEnabled = true
            self?.stopTimerButton.isEnabled = false
        }
        
        let geoData = getGeoData()
        geoPoster.postGeo(geoData: geoData)
        
        startTimerButton.isEnabled = false
        stopTimerButton.isEnabled = true
    }
    
    @IBAction private func stopTimer(_ sender: UIButton) {
        timer?.invalidate()
        startTimerButton.isEnabled = true
        stopTimerButton.isEnabled = false
    }
    
}

//MARK: LocationManger Delegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
}

// MARK: TextField Checks

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var allowedNumbers: [Int] = []
        for i in 1...10 {
            allowedNumbers.append(i)
        }
        let number = Int(textField.text!) ?? 1
        
        if !allowedNumbers.contains(number) {
            
            startTimerButton.isEnabled = false
            alertAboutWrongNumbers()
        }
        startTimerButton.isEnabled = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard !string.isEmpty else {
            startTimerButton.isEnabled = false
            return true
        }
        
        if textField.keyboardType == .numberPad {
            if !CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                
                startTimerButton.isEnabled = false
                alertAboutWrongNumbers()
                
                return false
            }
        }
        
        startTimerButton.isEnabled = true
        return true
    }
    
    func alertAboutWrongNumbers() {
        let alert = UIAlertController(title: "Error!!!", message: "This field accepts only numbers from 1 to 10", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { [weak self] action in
            self?.timerMinutes.text?.removeAll()
        }
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
}

//MARK: Keyboard Dismiss

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
