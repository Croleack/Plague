//
//  InputManager.swift
//  Plague
//
//  Created by Enzhe Gaysina on 26.03.2024.
//

import Foundation

final class InputManager {
    static func validate(groupSize: String?, infectionFactor: String?, period: String?) -> (Int, Int, Double)? {
	   guard let groupSizeText = groupSize,
		    let groupSize = Int(groupSizeText),
		    groupSize > 0 else {
		  return nil
	   }
	   
	   guard let infectionFactorText = infectionFactor,
		    let infectionFactor = Int(infectionFactorText),
		    infectionFactor > 0 else {
		  return nil
	   }
	   
	   guard let periodText = period,
		    let period = Double(periodText),
		    period > 0 else {
		  return nil
	   }
	   
	   return (groupSize, infectionFactor, period)
    }
}
