//
//  GridObject.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

/// Can something be eaten? Will it kill the snake?
enum Edible {
	case yes, mortality, no
}

/// Some object in the grid
protocol GridObjectType {
	var imageRef: String {get}			//The SF symbol of the object
	var color: Color {get}				//The color of the object
	var score: Int {get}				//Score if consumed
	var edible: Edible {get}			//Edible status
	var extendLengthBy: Int {get}		//How much bigger will the snake get?
	func evolve()						//An object can get older and evolve
}



