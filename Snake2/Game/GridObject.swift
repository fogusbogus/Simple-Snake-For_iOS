//
//  GridObject.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

enum Edible {
	case yes, mortal, no
}

protocol GridObjectType {
	var symbolName: String {get}
	var color: Color {get}
	var score: Int {get}
	var edible: Edible {get}
	var extendLengthBy: Int {get}
	func evolve()
}

class GridObjectApple: GridObjectType {
	var symbolName: String = "apple.logo"
	
	var color: Color { isYoung ? .green : .red }
	
	var score: Int { isYoung ? 20 : 10 }
	
	var edible: Edible = .yes
	
	var extendLengthBy: Int { isYoung ? 3 : 1 }
	
	func evolve() {
		if age < adultAge {
			age += 1
		}
	}

	private let adultAge = 30
	private var isYoung: Bool { age < adultAge }
	private var age = 0
}

class GridObjectWall: GridObjectType {
	var symbolName: String = "square.grid.3x3.square"
	
	var color: Color { .white }
	
	var score: Int { 0 }
	
	var edible: Edible = .yes
	
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

class GridObjectGrass: GridObjectType {
	var symbolName: String = "ellipsis"
	
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
	private var isMiddleAged: Bool { age < oldAge }
	private var age = 0
}

enum GridObject {
	case grass, apple, wall
	
	var symbolName: String {
		switch self {
			case .grass:
				return "ellipsis"
			case .apple:
				return "apple.logo"
			case .wall:
				return "square.grid.3x3.square"
		}
	}
	
	var color: Color {
		switch self {
			case .grass:
				return .yellow
			case .apple:
				return .red
			case .wall:
				return .white
		}
	}
	
	var score: Int {
		switch self {
			case .grass:
				return 5
			case .apple:
				return 20
			case .wall:
				return 0
		}
	}
	
	var extendLengthBy: Int {
		switch self {
			case .grass:
				return 1
			case .apple:
				return 3
			case .wall:
				return 0
		}
	}
	
	var edible: Bool {
		switch self {
			case .wall:
				return false
			default:
				return true
		}
	}
}
