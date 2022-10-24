//
//  ViewController.swift
//  MinimalisticWeather
//
//  Created by Achraf Labidi on 04.09.22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var riseLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    var weathermanger = WeatherManager()
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        weathermanger.delegate = self
        searchTextField.delegate = self
        searchTextField.autocapitalizationType = .words
        searchTextField.keyboardType = .alphabet
        if let lat = defaults.object(forKey: "latitude") as? Double{
            if let lon = defaults.object(forKey: "longitude") as? Double {
                weathermanger.fetchWeather(lat: lat, lon: lon)
            }
        } else {
            locationManager.requestLocation()
        }
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension ViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            if city.count >= 1 {
                weathermanger.fetchWeather(cityName: city)
            } else {
                locationManager.requestLocation()
            }
        }
        searchTextField.text = ""
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self.defaults.set(lat, forKey: "latitude")
            self.defaults.set(lon, forKey: "longitude")
            weathermanger.fetchWeather(lat: lat, lon: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }

}
// MARK: - WeatherManagerDelegate
extension ViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.windSpeed.text = weather.windSpeedString
            self.humidity.text = weather.humidityString
            self.conditionsLabel.text = weather.description
            self.cityLabel.text = weather.cityName
            self.riseLabel.text = weather.sunRiseString
            self.setLabel.text = weather.sunSetString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
        }
    }
    func didFailWithError(error: Error) {
        //print(error)
        locationManager.requestLocation()
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
