//
//  Extensions.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

extension CGPoint {
	func offset(x: CGFloat? = nil, y: CGFloat? = nil) -> CGPoint {
		let newX = self.x + CGFloat(x ?? 0)
		let newY = self.y + CGFloat(y ?? 0)
		return CGPoint(x: newX, y: newY)
	}
}
