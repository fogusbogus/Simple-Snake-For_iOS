//
//  FindPath.swift
//  Snake2
//
//  Created by Matt Hogg on 27/01/2025.
//

import Foundation

class FindPath {
	
	private static func getSurrounding(_ candidate: CGPoint, size: CGSize) -> [CGPoint] {
		let x = candidate.x, y = candidate.y
		var ret: [CGPoint] = [
			CGPoint(x: x - 1, y: y - 1), CGPoint(x: x, y: y-1), CGPoint(x: x+1, y: y-1),
			CGPoint(x: x - 1, y: y), CGPoint(x: x+1, y: y),
			CGPoint(x: x - 1, y: y + 1), CGPoint(x: x, y: y+1), CGPoint(x: x+1, y: y+1)
		]
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		return ret.filter {rect.contains($0)}
	}
	
	static func canGetTo(a: CGPoint, b: CGPoint, objects: [CGPoint], size: CGSize) -> Bool {
		guard a != b else { return true }
		var candidates: [CGPoint] = [a]
		var visited = objects
		while candidates.count > 0 {
			var surrounding = getSurrounding(candidates.first!, size: size).filter {!visited.contains($0)}
			if surrounding.contains(b) {
				return true
			}
			visited.append(candidates.first!)
			candidates.removeFirst()
			candidates.append(contentsOf: surrounding)
			visited.append(contentsOf: surrounding)
		}
		return false
	}
}


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
