//
//  GridObjectWall.swift
//  Snake2
//
//  Created by Matt Hogg on 01/02/2025.
//

import SwiftUI


class GridObjectWall: GridObjectType {
	var imageRef: String = "square.grid.3x3.square"
	
	var color: Color { .white }
	
	var score: Int { 0 }
	
	var edible: Edible = .mortality
	
	var extendLengthBy: Int { 0 }
	
	func evolve() {
		if age < adultAge {
			age += 1
		}
	}

	private let adultAge = 30
	private var isYoung: Bool { age < adultAge }
	private var age = 0
}
