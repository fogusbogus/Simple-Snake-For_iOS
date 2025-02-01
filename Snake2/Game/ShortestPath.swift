//
//  ShortestPath.swift
//  Marbling
//
//  Created by Matt Hogg on 14/05/2024.
//

import Foundation
import SwiftUI

class SPNode: Identifiable {
	init(x: Int, y: Int, parent: SPNode? = nil, obstacle: Bool = false, visited: Bool = false, globalGoal: Float, localGoal: Float, neighbours: [SPNode]) {
		self.x = x
		self.y = y
		self.parent = parent
		self.obstacle = obstacle
		self.visited = visited
		self.globalGoal = globalGoal
		self.localGoal = localGoal
		self.neighbours = neighbours
	}
	var id = UUID()
	var x: Int, y: Int
	var parent: SPNode?
	var obstacle = false, visited = false
	var globalGoal: Float, localGoal: Float
	var neighbours: [SPNode]
	
	func getColor(startPoint: CGPoint, endPoint: CGPoint) -> Color {
		if Int(startPoint.x) == x && Int(startPoint.y) == y {
			return .green
		}
		if Int(endPoint.x) == x && Int(endPoint.y) == y {
			return .pink
		}
		return obstacle ? .white : (visited ? .blue : .blue.opacity(0.5))
	}
	
	func getRect(origin: CGPoint, size: CGSize) -> CGRect {
		return CGRect(x: origin.x + size.width * CGFloat(x), y: origin.y + size.height * CGFloat(y), width: size.width, height: size.height)
	}
}

class SPExample {
	let width = 16, height = 16
	
	var nodes: [SPNode]
	
	init() {
		nodes = []
		(0..<width).forEach { x in
			(0..<height).forEach { y in
				nodes.append(SPNode(x: x, y: y, parent: nil, obstacle: false, visited: false, globalGoal: Float.infinity, localGoal: Float.infinity, neighbours: []))
			}
		}
		nodes.forEach { node in
			let neighbours : [SPNode?] = [
				//getNode(CGPoint(x: node.x - 1, y: node.y - 1)),
				getNode(CGPoint(x: node.x, y: node.y - 1)),
				//getNode(CGPoint(x: node.x + 1, y: node.y - 1)),
				getNode(CGPoint(x: node.x - 1, y: node.y)),
				getNode(CGPoint(x: node.x + 1, y: node.y)),
				//getNode(CGPoint(x: node.x - 1, y: node.y + 1)),
				getNode(CGPoint(x: node.x, y: node.y + 1)),
				//getNode(CGPoint(x: node.x + 1, y: node.y + 1))
			]
			node.neighbours = neighbours.compactMap {$0}
		}
	}
	
	func reset() {
		nodes.forEach { node in
			node.globalGoal = Float.infinity
			node.localGoal = Float.infinity
			node.visited = false
			node.parent = nil
		}
	}
	
	func getNode(_ position: CGPoint) -> SPNode? {
		return nodes.first(where: {$0.x == Int(position.x) && $0.y == Int(position.y)})
	}
	
	func Solve_AStar(startPosition: CGPoint, endPosition: CGPoint) {
		guard let startNode = getNode(startPosition), let endNode = getNode(endPosition) else { return }
		guard startNode.id != endNode.id else { return }
		reset()
		
		let distance : (SPNode, SPNode) -> Float = { a, b in
			return sqrtf(Float(a.x - b.x) * Float(a.x - b.x) + Float(a.y - b.y) * Float(a.y - b.y))
		}
		
		let heuristic : (SPNode, SPNode) -> Float = { distance($0, $1) }
		
		var current = startNode
		startNode.localGoal = 0
		startNode.globalGoal = heuristic(startNode, endNode)
		
		var listNotTested : [SPNode] = [startNode]
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
	}
	
	func getNodePath(node: SPNode, origin: CGPoint, size: CGSize, schemeSize: CGSize) -> Path {
		var p = Path()
		p.addRect(CGRect(origin: CGPoint(x: origin.x + schemeSize.width * CGFloat(node.x), y: origin.y + schemeSize.height * CGFloat(node.y)), size: size))
		return p
	}
	
	func getNodeJoins(node: SPNode, origin: CGPoint, size: CGSize, schemeSize: CGSize) -> Path {
		let rect = CGRect(origin: CGPoint(x: origin.x + schemeSize.width * CGFloat(node.x), y: origin.y + schemeSize.height * CGFloat(node.y)), size: size)
		let mp = CGPoint(x: rect.midX, y: rect.midY)
		var p = Path()
		if node.x > 0 {
			p.move(to: mp)
			p.addLine(to: CGPoint(x: mp.x - schemeSize.width, y: mp.y))
		}
		if node.y > 0 {
			p.move(to: mp)
			p.addLine(to: CGPoint(x: mp.x, y: mp.y - schemeSize.height))
		}
		return p
	}
	
	func getNodeFromPosition(point: CGPoint, origin: CGPoint, schemeSize: CGSize) -> SPNode? {
		let off = CGPoint(x: point.x - origin.x, y: point.y - origin.y)
		let px = Int(off.x / schemeSize.width)
		let py = Int(off.y / schemeSize.height)
		
		if px < 0 || py < 0 || px >= width || py >= height { return nil }
		return nodes.first(where: {$0.x == px && $0.y == py})
	}
	
}

extension Array where Element == CGPoint {
	func offset(x: CGFloat, y: CGFloat) -> [CGPoint] {
		return self.map {CGPoint(x: $0.x + x, y: $0.y + y)}
	}
}

class UIUpdate : ObservableObject {
	@Published var toggle : Bool = false
	func update() {
		toggle = !toggle
	}
}

struct SPMap : View {
	let nodeSize = 28
	let nodeBorder = 10
	
	@State var startPosition: CGPoint = CGPoint(x: 2, y: 7)
	@State var endPosition: CGPoint = CGPoint(x: 13, y: 7)
	
	func getEndNode() -> SPNode? {
		return ex.nodes.first(where: {$0.x == Int(endPosition.x) && $0.y == Int(endPosition.y)})
	}
	
	@State var ex = SPExample()
	@ObservedObject var ui = UIUpdate()
	
	func getSolutionPath() -> Path {
		var p = Path()
		var endNode = getEndNode()
		var pts : [CGPoint] = []
		while endNode != nil {
			
			let rect = endNode!.getRect(origin: CGPoint.zero, size: CGSize(width: nodeSize + nodeBorder, height: nodeSize + nodeBorder))
			pts.append(CGPoint(x: rect.midX, y: rect.midY))
			
			endNode = endNode?.parent
		}
		p.addLines(pts)
		return p
	}
	
	var body: some View {
		Canvas { context, size in
			context.fill(Path(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerSize: CGSize.zero), with: .color(.black))
			ex.nodes.forEach { node in
				context.stroke(ex.getNodeJoins(node: node, origin: CGPoint.zero, size: CGSize(width: nodeSize, height: nodeSize), schemeSize: CGSize(width: nodeSize + nodeBorder, height: nodeSize + nodeBorder)), with: .color(.blue.opacity(0.5)), lineWidth: 4)
			}
			ex.nodes.forEach { node in
				context.fill(ex.getNodePath(node: node, origin: CGPoint.zero, size: CGSize(width: nodeSize, height: nodeSize), schemeSize: CGSize(width: nodeSize + nodeBorder, height: nodeSize + nodeBorder)), with: .color(node.getColor(startPoint: startPosition, endPoint: endPosition)))
			}
			context.stroke(getSolutionPath().offsetBy(dx: -4, dy: -4), with: .color(.yellow), lineWidth: 6)
		}
		.onTapGesture { location in
			if let node = ex.getNodeFromPosition(point: location, origin: CGPoint.zero, schemeSize: CGSize(width: nodeSize + nodeBorder, height: nodeSize + nodeBorder)) {
				node.obstacle = !node.obstacle
				ex.Solve_AStar(startPosition: startPosition, endPosition: endPosition)
				ui.update()
			}
		}
	}
}

#Preview {
	SPMap()
		.padding()
}
