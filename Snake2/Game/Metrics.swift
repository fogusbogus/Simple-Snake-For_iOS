//
//  Metrics.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

class Metrics {
	static var shared = Metrics()
	private init() {
		windowWidth = 100
		windowHeight = 100
		gridSize = CGSize(width: 32, height: 64)
	}
	
	var gridSize: CGSize
	
	var gridWidth: Int { Int(gridSize.width) }
	var gridHeight: Int { Int(gridSize.height) }
	
	var windowWidth: CGFloat {
		didSet {
			print("WW: \(windowWidth)")
		}
	}
	var windowHeight: CGFloat {
		didSet {
			print("WH: \(windowHeight)")
		}
	}
	
	var blockSizeWidth: CGFloat {
		return windowWidth / gridSize.width
	}
	var blockSizeHeight: CGFloat {
		return windowHeight / (gridSize.height + 2)
	}
	
	var windowSize: CGSize {
		return CGSize(width: windowWidth, height: windowHeight)
	}
	
	var idealBlockSize: CGFloat { [blockSizeWidth, blockSizeHeight].min()!}
	
	var idealWindowWidth: CGFloat {
		return CGFloat(gridWidth) * idealBlockSize
	}
	var idealWindowHeight: CGFloat {
		return CGFloat(gridHeight) * idealBlockSize
	}
	
	var horzPadding: CGFloat { windowWidth - idealWindowWidth }
	var vertPadding: CGFloat { windowHeight - idealWindowHeight }
}
