//
//  calculation.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 04/10/2022.
//

import Foundation

class Calculations {
    
    class func rainForcast(){
        
    }
    class func dewPointCheck(temperature: Double, dewPoint: Double, humidity: Double, pressure: Double) -> Bool
    {
        if ((temperature - dewPoint <= 5)
            && humidity > 85
            && temperature <= 12
            && pressure >= 1020)
        {
            hapticWarning()
            return true
        }
        
        return false
    }
    
    class func coldTemperature(temperature: Double) -> Bool {
        if (temperature <= 9)
        {
            hapticWarning()
            return true
        }
        
        return false
    }
}
