//
//  PlayArea.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

class PlayArea {
	init(objects: [CGPoint : GridObject], snake: TheSnake, size: CGSize, setup: ((PlayArea) -> Void)? = nil) {
		self.objects = objects
		self.snake = snake
		self.size = size
		
		Metrics.shared.gridSize = size
		
		//Outside wall
		(0..<Int(size.width)).forEach { x in
			pushObject(CGPoint(x: x, y: 0), object: .wall)
			pushObject(CGPoint(x: x, y: Int(size.height - 1)), object: .wall)
		}
		(0..<Int(size.height)).forEach { y in
			
			pushObject(CGPoint(x: 0, y: y), object: .wall)
			pushObject(CGPoint(x: Int(size.width - 1), y: y), object: .wall)
		}
		
		setup?(self)
		setupNodes()
	}
	var objects: [CGPoint:GridObject] = [:]
	var snake: TheSnake
	var size: CGSize
	private var width: Int { Int(size.width) }
	private var height: Int { Int(size.height) }
	
	private var nodes: [ShortPath] = []
	
	private func setupNodes() {
		nodes = []
		(0..<width).forEach { x in
			(0..<height).forEach { y in
				nodes.append(ShortPath(xy: CGPoint(x: x, y: y), parent: nil, globalGoal: Float.infinity, localGoal: Float.infinity, neighbours: []))
			}
		}
		nodes.forEach { node in
			let neighbours: [ShortPath?] = [
				getNode(x: node.xy.x, y: node.xy.y - 1),
				getNode(x: node.xy.x - 1, y: node.xy.y),
				getNode(x: node.xy.x + 1, y: node.xy.y),
				getNode(x: node.xy.x, y: node.xy.y + 1)
			]
			node.neighbours = neighbours.compactMap {$0}
		}
	}
	
	private func resetNodes() {
		nodes.forEach { node in
			node.globalGoal = Float.infinity
			node.localGoal = Float.infinity
			node.visited = false
			node.parent = nil
			node.obstacle = objects.keys.contains(node.xy)
		}
	}
	
	private func getNode(x: CGFloat, y: CGFloat) -> ShortPath? {
		return nodes.first(where: {$0.xy.x == x && $0.xy.y == y})
	}
	
	private func canReach(start: CGPoint, end: CGPoint) -> Bool {
		guard let startNode = getNode(x: start.x, y: start.y), let endNode = getNode(x: end.x, y: end.y) else { return false }
		guard start != end else { return true }
		resetNodes()
		
		let distance : (ShortPath, ShortPath) -> Float = { a, b in
			return sqrtf(Float(a.xy.x - b.xy.x) * Float(a.xy.x - b.xy.x) + Float(a.xy.y - b.xy.y) * Float(a.xy.y - b.xy.y))
		}
		
		let heuristic : (ShortPath, ShortPath) -> Float = { distance($0, $1) }
		var current = startNode
		startNode.localGoal = 0
		startNode.globalGoal = heuristic(startNode, endNode)
		var listNotTested: [ShortPath] = [startNode]
		while listNotTested.count > 0 {
			listNotTested.sort(by: {$0.globalGoal < $1.globalGoal})
			while listNotTested.first?.visited ?? false {
				listNotTested.removeFirst()
			}
			if listNotTested.count == 0 {
				break
			}
			current = listNotTested.first!
			current.visited = true
			current.neighbours.forEach { neighbour in
				if !neighbour.visited && !neighbour.obstacle {
					listNotTested.append(neighbour)
				}
				let lowerGoal = current.localGoal + distance(current, neighbour)
				if lowerGoal < neighbour.localGoal {
					neighbour.parent = current
					neighbour.localGoal = lowerGoal
					neighbour.globalGoal = neighbour.localGoal + heuristic(neighbour, endNode)
				}
			}
		}
		return endNode.parent != nil
	}
	
	func pushObject(_ at: CGPoint, object: GridObject) {
		guard !objects.keys.contains(at) else { return }
		objects[at] = object
	}
	
	func allObjects() -> [DrawObject] {
		var ret: [DrawObject] = []
		objects.forEach { obj in
			ret.append(DrawObject(systemName: obj.value.symbolName, at: obj.key, color: obj.value.color))
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
		objKeys.append(contentsOf: objects.keys)
		var illegal: [CGPoint] = snake.points
		illegal.append(contentsOf: objKeys)
		while illegal.contains(rnd) || !canReach(start: snake.points.first!, end: rnd) {
			rnd = CGPoint(x: Int.random(in: 0..<Int(size.width)), y: Int.random(in: 0..<Int(size.height)))
		}
		pushObject(rnd, object: .apple)
	}
	
	func play() {
		guard !isDead else { return }
		if desiredRotation != .none {
			snake.direction = desiredRotation
			desiredRotation = .none
		}
		let pt = snake.move()
		if let obj = objects[pt] {
			if obj == .wall || snake.hasEatenSelf() {
				isDead = true
				return
			}
			snake.desiredLength += obj.extendLengthBy
			score += obj.score
			objects.removeValue(forKey: pt)
			if obj == .apple {
				addApple()
			}
		}
		else {
			if snake.hasEatenSelf() {
				isDead = true
			}
		}
	}
	
	var desiredRotation: SnakeRotation = .none
	
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
