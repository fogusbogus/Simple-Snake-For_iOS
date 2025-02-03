//
//  PlayArea.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

class PlayArea {
	init(objects: [CGPoint : any GridObjectType], snake: TheSnake, size: CGSize, setup: ((PlayArea) -> Void)? = nil) {
		self.objects = objects
		self.snake = snake
		self.size = size
		shortPathCalculator = ShortPathCalculation(size: size)

		Metrics.shared.gridSize = size
		
		//Outside wall
		(0..<Int(size.width)).forEach { x in
			pushObject(CGPoint(x: x, y: 0), object: GridObjectWall())
			pushObject(CGPoint(x: x, y: Int(size.height - 1)), object: GridObjectWall())
		}
		(0..<Int(size.height)).forEach { y in
			
			pushObject(CGPoint(x: 0, y: y), object: GridObjectWall())
			pushObject(CGPoint(x: Int(size.width - 1), y: y), object: GridObjectWall())
		}
		
		setup?(self)
	}
	var objects: [CGPoint:any GridObjectType] = [:]
	var snake: TheSnake
	var size: CGSize
	private var width: Int { Int(size.width) }
	private var height: Int { Int(size.height) }
	
	private var shortPathCalculator: ShortPathCalculation

	func pushObject(_ at: CGPoint, object: any GridObjectType) {
		guard !objects.keys.contains(at) else { return }
		objects[at] = object
	}
	
	func allObjects() -> [DrawObject] {
		var ret: [DrawObject] = []
		objects.forEach { obj in
			ret.append(DrawObject(systemName: obj.value.imageRef, at: obj.key, color: obj.value.color))
		}
		ret.append(contentsOf: snake.getDrawObjects())
		return ret
	}
	
	func findBlankSpot() throws -> CGPoint {
		var allPoints: [CGPoint] = []
		allPoints.append(contentsOf: objects.keys)
		allPoints.append(contentsOf: snake.points)
		if allPoints.count > Int(self.size.width * self.size.height) {
			throw CancellationError()
		}
		var pt = CGPoint(x: Int.random(in: 0..<Int(self.size.width)), y: Int.random(in: 0..<Int(self.size.height)))
		while allPoints.contains(pt) {
			pt = CGPoint(x: Int.random(in: 0..<Int(self.size.width)), y: Int.random(in: 0..<Int(self.size.height)))
		}
		return pt
	}
	
	var isDead = false
	var score = 0
	
	func addApple() {
		var rnd = CGPoint(x: Int.random(in: 0..<Int(size.width)), y: Int.random(in: 0..<Int(size.height)))
		var objKeys: [CGPoint] = []
		objKeys.append(contentsOf: objects.filter({$0.value is GridObjectWall}).keys)
		var illegal: [CGPoint] = snake.points
		illegal.append(contentsOf: objKeys)
		while illegal.contains(rnd) || !shortPathCalculator.canReach(start: snake.points.first!, end: rnd, obstaclePoints: objects.keys.map {$0}) {
			rnd = CGPoint(x: Int.random(in: 0..<Int(size.width)), y: Int.random(in: 0..<Int(size.height)))
		}
		pushObject(rnd, object: GridObjectApple())
	}
	
	func play() {
		guard !isDead else { return }
		objects.forEach {$0.value.evolve()}
		if desiredRotation != .none {
			snake.direction = desiredRotation
			desiredRotation = .none
		}
		let pt = snake.move()
		if let obj = objects[pt] {
			if obj.edible == .mortality || snake.hasEatenSelf() {
				isDead = true
				return
			}
			snake.desiredLength += obj.extendLengthBy
			score += obj.score
			objects.removeValue(forKey: pt)
			if obj is GridObjectApple {
				addApple()
			}
		}
		else {
			if snake.hasEatenSelf() {
				isDead = true
			}
		}
	}
	
	var desiredRotation: SnakeDirection = .none
	
	func rotateLeft() {
		switch snake.direction {
			case .north:
				desiredRotation = .east
			case .east:
				desiredRotation = .south
			case .south:
				desiredRotation = .west
			case .west:
				desiredRotation = .north
			case .none:
				break
		}
	}
	
	func rotateRight() {
		switch snake.direction {
			case .north:
				desiredRotation = .west
			case .west:
				desiredRotation = .south
			case .south:
				desiredRotation = .east
			case .east:
				desiredRotation = .north
			case .none:
				break
		}
	}
}
