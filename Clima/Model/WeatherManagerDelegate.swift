//
//  WeatherManagerDelegate.swift
//  Clima
//
//  Created by Nikola Anastasovski on 23.1.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
