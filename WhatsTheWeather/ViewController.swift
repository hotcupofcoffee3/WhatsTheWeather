//
//  ViewController.swift
//  WhatsTheWeather
//
//  Created by Adam Moore on 3/24/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var forecastString = ""
    
    @IBOutlet  weak var weatherTextField: UITextField!
    @IBAction func showWeatherButton(_ sender: UIButton) {
        
        var retrievedWeatherForecastString = String()
        
        if let city = self.weatherTextField.text {
            
            if city != "" {
                
                let url = URL(string: "http://www.weather-forecast.com/locations/\(city.replacingOccurrences(of: " ", with: "-"))/forecasts/latest")!
                
                let request = URLRequest(url: url)
                
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    (data, response, error) in
                    
                    if let error = error {
                        print(error)
                    } else {
                        if let unwrappedData = data {
                            let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                            
                            let stringSeparator = "\(city) Weather Today </h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                            
                            if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                                
                                let secondStringSeparator = "</span></p></td><td colspan=\"9\"><span class=\"b-forecast__table-description-title\"><h2>\(city) Weather"
                                
                                let shorterContentArray = contentArray[1].components(separatedBy: secondStringSeparator)
                                
                                retrievedWeatherForecastString = shorterContentArray[0]
                                
                                DispatchQueue.main.sync(execute: {
                                    
                                    self.forecastLabel.text = retrievedWeatherForecastString
                                    
                                })
                            }
                        }
                    }
                }
                task.resume()
            } else {
                self.forecastLabel.text = "You need to enter a city first."
            }
        }
    }
    @IBOutlet weak var forecastLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

