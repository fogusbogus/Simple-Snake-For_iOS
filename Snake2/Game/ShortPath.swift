//
//  ShortPath.swift
//  Snake2
//
//  Created by Matt Hogg on 27/01/2025.
//

import Foundation

class ShortPath {
	var xy: CGPoint
	var parent: ShortPath?
	var obstacle = false, visited = false
	var globalGoal: Float, localGoal: Float
	var neighbours: [ShortPath]
	
	init(xy: CGPoint, parent: ShortPath? = nil, obstacle: Bool = false, visited: Bool = false, globalGoal: Float, localGoal: Float, neighbours: [ShortPath]) {
		self.xy = xy
		self.parent = parent
		self.obstacle = obstacle
		self.visited = visited
		self.globalGoal = globalGoal
		self.localGoal = localGoal
		self.neighbours = neighbours
	}
}

class ShortPathCalculation {
	init(size: CGSize) {
		self.size = size
		setupNodes()
	}
	init(width: Int, height: Int) {
		self.size = CGSize(width: width, height: height)
		setupNodes()
	}
	private var nodes: [ShortPath] = []
	private var size: CGSize
	
	private func setupNodes() {
		nodes = []
		(0..<Int(self.size.width)).forEach { x in
			(0..<Int(self.size.height)).forEach { y in
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
	
	private func resetNodes(obstaclePoints: [CGPoint]) {
		nodes.forEach { node in
			node.globalGoal = Float.infinity
			node.localGoal = Float.infinity
			node.visited = false
			node.parent = nil
			node.obstacle = obstaclePoints.contains(node.xy)
		}
	}
	
	private func getNode(x: CGFloat, y: CGFloat) -> ShortPath? {
		return nodes.first(where: {$0.xy.x == x && $0.xy.y == y})
	}
	
	func canReach(start: CGPoint, end: CGPoint, obstaclePoints: [CGPoint]) -> Bool {
		guard let startNode = getNode(x: start.x, y: start.y), let endNode = getNode(x: end.x, y: end.y) else { return false }
		guard start != end else { return true }
		resetNodes(obstaclePoints: obstaclePoints)
		
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
	
}
