//
//  GridObject.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

enum Edible {
	case yes, mortality, no
}

protocol GridObjectType {
	var imageRef: String {get}
	var color: Color {get}
	var score: Int {get}
	var edible: Edible {get}
	var extendLengthBy: Int {get}
	func evolve()
}



