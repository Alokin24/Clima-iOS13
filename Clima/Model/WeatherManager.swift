//
//  File.swift
//  Clima
//
//  Created by Nikola Anastasovski on 22.1.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=48646b890d3d603867bb7a80a61dafcb&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
           
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let saveData = data {
                    if let weather = parseJSON(saveData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
           
            // 4. Start the task
            task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
            
//            print(weather.conditionName)
//            print(weather.temperatureString)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
       
    }
    
    
    
}
