//
//  String+Extensions.swift
//  PlaneWX
//
//  Created by Pierre-Louis L'ALLORET on 05/08/2022.
//

import Foundation

extension String {
    func localised(arguments: [Int: Any]? = nil) -> String {
        var result = NSLocalizedString(self, comment: "")
        
        arguments?.forEach { (argument) in
            result = result.replacingOccurrences(of: "{\(argument.key)}", with: "\(argument.value)")
        }
        
        return result
    }
}
