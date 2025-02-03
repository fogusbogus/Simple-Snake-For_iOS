//
//  SnakeDirection.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

enum SnakeDirection {
	case north, west, south, east, none
	
	/// In which direction does a new point lie?
	/// - Parameters:
	///   - previous: The previous location
	///   - this: The current location
	/// - Returns: Direction
	static func getDirection(previous: CGPoint, this: CGPoint) -> SnakeDirection {
		if previous.x < this.x { return .east }
		if previous.x > this.x { return .west }
		if previous.y < this.y { return .south }
		if previous.y > this.y { return .north }
		return .none
	}
}
