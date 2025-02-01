//
//  GameplayArea.swift
//  Snake2
//
//  Created by Matt Hogg on 25/01/2025.
//

import SwiftUI




struct DrawObject {
	var systemName: String
	var at: CGPoint
	var color: Color
}

struct Grid: View {
	
	@ObservedObject var ui = WindowUI()

	var playArea: PlayArea

	func calcRect(x: Int, y: Int, sz: CGSize? = nil) -> CGRect {
		let w = Metrics.shared.blockSizeWidth, h = Metrics.shared.blockSizeHeight
		return CGRect(x: CGFloat(x) * w, y: CGFloat(y) * h, width: w, height: h )
	}
	
	var body: some View {
		
		GeometryReader { geo in
			VStack {
				Rectangle().fill(.green)
					.onChange(of: geo.size) { oldValue, newValue in
						Metrics.shared.windowWidth = newValue.width
						Metrics.shared.windowHeight = newValue.height
						self.ui.toggle()
					}
					.onAppear {
						Metrics.shared.windowWidth = geo.size.width
						Metrics.shared.windowHeight = geo.size.height
					}
				Text("Score: \(playArea.score)")
			}
		}.overlay {
			VStack {
				Canvas { gc, sz in
					let items = playArea.allObjects()
					items.forEach { sd in
						let rect = calcRect(x: Int(sd.at.x), y: Int(sd.at.y), sz: sz)
						var image = gc.resolve( Image(systemName: sd.systemName))
						image.shading = .color(sd.color)
						
						gc.draw(image, in: rect)
					}
				}
				Text("Score: \(playArea.score)")
			}
		}
	}
}


struct GameplayArea: View {
	@State var playArea: PlayArea = PlayArea(objects: [:], snake: TheSnake(startPoint: CGPoint(x:5,y:5)), size: CGSize(width: 31, height: 40)) { area in
			//Let's do some objects
			(0..<10).forEach { _ in
				if let pt = try? area.findBlankSpot() {
					area.pushObject(pt, object: GridObjectApple(randomAge: true))
				}
			}
			(0..<30).forEach { _ in
				if let pt = try? area.findBlankSpot() {
					area.pushObject(pt, object: GridObjectGrass(randomAge: true))
				}
			}
			(0..<10).forEach { _ in
				if let pt = try? area.findBlankSpot() {
					area.pushObject(pt, object: GridObjectWall())
				}
			}
	}
	
	func reset() -> PlayArea {
		return PlayArea(objects: [:], snake: TheSnake(startPoint: CGPoint(x:5,y:5)), size: CGSize(width: 31, height: 40)) { area in
			//Let's do some objects
			(0..<10).forEach { _ in
				if let pt = try? area.findBlankSpot() {
					area.pushObject(pt, object: GridObjectApple(randomAge: true))
				}
			}
			(0..<30).forEach { _ in
				if let pt = try? area.findBlankSpot() {
					area.pushObject(pt, object: GridObjectGrass(randomAge: true))
				}
			}
			(0..<10).forEach { _ in
				if let pt = try? area.findBlankSpot() {
					area.pushObject(pt, object: GridObjectWall())
				}
			}
		}
	}
	
	@ObservedObject var ui = WindowUI()

	let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()

    var body: some View {
		VStack(alignment: .center) {
			Button {
				playArea = reset()
			} label: {
				Text(playArea.isDead ? "Game Over" : "Greedy Bastard!").font(.largeTitle)
			}
			.buttonStyle(.borderedProminent)
			Grid(playArea: playArea)
				.onReceive(timer) { _ in
					playArea.play()
					ui.toggle()
				}
			HStack(alignment: .center, spacing: 24) {
				Button {
					playArea.rotateRight()
				} label: {
					Image(systemName: "arrowshape.left.fill")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.white)
				}
				.contentShape(Rectangle())
				.background(.blue)
				Button {
					playArea.rotateLeft()
				} label: {
					Image(systemName: "arrowshape.right.fill")
						.resizable()
						.scaledToFit()
						.foregroundStyle(.white)
				}
				.contentShape(Rectangle())
				.background(.blue)
			}
				.onTapGesture {
					playArea.snake.move()
					ui.toggle()
				}
		}
		.scenePadding()
    }
}

#Preview {
    GameplayArea()
}
