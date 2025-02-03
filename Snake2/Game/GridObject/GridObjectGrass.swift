//
//  GridObjectGrass.swift
//  Snake2
//
//  Created by Matt Hogg on 01/02/2025.
//

import SwiftUI

/// Grass. 'Tis edible.
class GridObjectGrass: GridObjectType {
	
	/// Constructor
	/// - Parameter randomAge: We don't want all grass to be the same age initially
	init(randomAge: Bool = false) {
		if randomAge {
			age = Int.random(in: 0..<oldAge)
		}
	}
	var imageRef: String = "ellipsis"
	
	var color: Color { isYoung ? Color(UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1.0)) : isMiddleAged ? .yellow : .gray }
	
	var score: Int { isYoung ? 10 : isMiddleAged ? 5 : 1 }
	
	var edible: Edible = .yes
	
	var extendLengthBy: Int { age < oldAge ? 1 : 0 }
	
	func evolve() {
		if age < oldAge {
			age += 1
		}
	}

	private let middleAge = 30, oldAge = 50
	private var isYoung: Bool { age < middleAge }
	private var isMiddleAged: Bool { !isYoung && age < oldAge }
	private var age = 0
}
