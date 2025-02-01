//
//  SnakeRotation.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

enum SnakeRotation {
	case north, west, south, east, none
	
	static func getDirection(previous: CGPoint, this: CGPoint) -> SnakeRotation {
		if previous.x < this.x { return .east }
		if previous.x > this.x { return .west }
		if previous.y < this.y { return .south }
		if previous.y > this.y { return .north }
		return .none
	}
}
