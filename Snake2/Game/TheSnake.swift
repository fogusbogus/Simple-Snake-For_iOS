//
//  TheSnake.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

/// The class that handles the snake
class TheSnake {
	init(startPoint: CGPoint) {
		self.direction = .east
		start(position: startPoint, direction: .east)
	}
	var points: [CGPoint] = []		//All the points that make the snake. .first is the head, .last is the tail
	var direction: SnakeDirection	//Current direction of the snake
	var desiredLength: Int = 4		//If the snake eats something it might get bigger
	var color: Color = .black		//Probably shouldn't be here as it is UI dependent.
	
	/// Offset a point
	/// - Parameters:
	///   - point: The point to offset
	///   - x: Optional. value to add to x.
	///   - y: Optional. value to add to y.
	/// - Returns: New offset point
	private func offset(_ point: CGPoint, x: CGFloat? = nil, y: CGFloat? = nil) -> CGPoint {
		let newX = point.x + CGFloat(x ?? 0)
		let newY = point.y + CGFloat(y ?? 0)
		return CGPoint(x: newX, y: newY)
	}
	
	/// Move the snake in the desired direction
	/// - Returns: New point of the head
	@discardableResult
	func move() -> CGPoint {
		var newPt = CGPoint.zero
		switch direction {
			case .north:
				newPt = offset(points[0], y: -1)
			case .west:
				newPt = offset(points[0], x: -1)
			case .south:
				newPt = offset(points[0], y: 1)
			case .east:
				newPt = offset(points[0], x: 1)
			case .none:
				newPt = points[0]
		}
		
		//The head is always the first item in the array, the tail is always the last
		points.insert(newPt, at: 0)
		
		//Don't extend beyond the desired length. This allows growth of the snake in stages.
		if points.count > desiredLength {
			points.removeLast(points.count - desiredLength)
		}
		return points[0]
	}
	
	/// Start the snake in a given position and direction
	/// - Parameters:
	///   - position: Where on the grid the snake is
	///   - direction: The direction of the snake
	func start(position: CGPoint, direction: SnakeDirection) {
		points = [position]
		switch direction {
			case .north:
				points.append(offset(position, y: 1))
			case .west:
				points.append(offset(position, x: 1))
			case .south:
				points.append(offset(position, y: -1))
			case .east:
				points.append(offset(position, x: -1))

			case .none:
				points.append(offset(position, x: 1))
		}
	}
	
	/// As we are using SF symbols to represent our snake, get something that our screen writer can understand
	/// - Returns: A number of draw objects including position and symbol
	func getDrawObjects() -> [DrawObject] {
		let ret: [DrawObject] =
		(0..<points.count).map { index in
			if index == 0 {
				return DrawObject(systemName: SnakeType.head.symbolName(self.direction), at: points[index], color: color)
			}
			
			//We can figure out the direction of the symbol from the previous point in relation to this one
			let rotation = SnakeDirection.getDirection(previous: points[index], this: points[index-1])
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
	
	/// In our game the snake is a bit too greedy and will literally eat itself
	/// - Returns: Whether the snake head is matched to another snake position indicating eating itself
	func hasEatenSelf() -> Bool {
		guard points.count > 1 else { return false }
		return points.filter {$0 == points.first!}.count > 1
	}
}
