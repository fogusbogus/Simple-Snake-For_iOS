//
//  GridObjectApple.swift
//  Snake2
//
//  Created by Matt Hogg on 01/02/2025.
//

import SwiftUI

/// The edible apple
class GridObjectApple: GridObjectType {
	
	/// Constructor
	/// - Parameter randomAge: We don't want all initial apples to be the same age
	init(randomAge: Bool = false) {
		if randomAge {
			age = Int.random(in: 0...oldAge)
		}
	}
	
	var imageRef: String = "apple.logo"
	
	var color: Color { isYoung ? .yellow : isMiddleAged ? .red : .black }
	
	var score: Int { isYoung ? 20 : isMiddleAged ? 10 : 1 }
	
	var edible: Edible = .yes
	
	var extendLengthBy: Int { isYoung ? 3 : 1 }
	
	func evolve() {
		if age < oldAge {
			age += 1
		}
	}

	private let adultAge = 30, oldAge = 60
	private var isYoung: Bool { age < adultAge }
	private var isMiddleAged: Bool { !isYoung && age < oldAge }
	private var age = 0
}
