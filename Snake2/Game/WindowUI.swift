//
//  WindowUI.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//

import SwiftUI

class WindowUI: ObservableObject {
	@Published var value: Bool = false
	func toggle() {
		value = !value
	}
}
