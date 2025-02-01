//
//  TheSnake.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

class TheSnake {
	init(startPoint: CGPoint) {
		self.direction = .east
		start(position: startPoint, direction: .east)
	}
	var points: [CGPoint] = []
	var direction: SnakeRotation
	var desiredLength: Int = 4
	var color: Color = .black
	
	@discardableResult
	func move() -> CGPoint {
		var newPt = CGPoint.zero
		switch direction {
			case .north:
				newPt = points[0].offset(y: -1)
			case .west:
				newPt = points[0].offset(x: -1)
			case .south:
				newPt = points[0].offset(y: 1)
			case .east:
				newPt = points[0].offset(x: 1)
			case .none:
				newPt = points[0]
		}
		points.insert(newPt, at: 0)
		if points.count > desiredLength {
			points.removeLast(points.count - desiredLength)
		}
		return points[0]
	}
	
	func start(position: CGPoint, direction: SnakeRotation) {
		points = [position]
		switch direction {
			case .north:
				points.append(position.offset(y: 1))
			case .west:
				points.append(position.offset(x: 1))
			case .south:
				points.append(position.offset(y: -1))
			case .east:
				points.append(position.offset(x: -1))

			case .none:
				points.append(position.offset(x: 1))
		}
	}
	
	func getDrawObjects() -> [DrawObject] {
		let ret: [DrawObject] =
		(0..<points.count).map { index in
			if index == 0 {
				return DrawObject(systemName: SnakeType.head.symbolName(self.direction), at: points[index], color: color)
			}
			let rotation = SnakeRotation.getDirection(previous: points[index], this: points[index-1])
			if index == points.count - 1 {
				return DrawObject(systemName: SnakeType.tail.symbolName(rotation), at: points[index], color: color)
			}
			/*
			 Is this a curve? For this to be true then prev.xy cannot be on same plane as next.xy
			 */
			let prev = points[index-1], next = points[index+1]
			var type: SnakeType = .body
			if prev.x != next.x && prev.y != next.y {
				type = .curve
			}
			return DrawObject(systemName: type.symbolName(rotation), at: points[index], color: color)
		}
		return ret
	}
	
	func hasEatenSelf() -> Bool {
		guard points.count > 1 else { return false }
		return points.filter {$0 == points.first!}.count > 1
	}
}
