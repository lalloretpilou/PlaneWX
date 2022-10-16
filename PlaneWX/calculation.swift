//
//  calculation.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 04/10/2022.
//

import Foundation

class Calculations {
    
    class func rainForcast(pressure: Double, visibility: Double, cloudCoverage: Double) -> Bool{
        
        if(pressure <= 1013
           //&& visibility <= 5
           && cloudCoverage >= 80)
        {
            return true
        }
            return false
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
