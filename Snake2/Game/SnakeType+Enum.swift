//
//  SnakeType.swift
//  Snake2
//
//  Created by Matt Hogg on 28/01/2025.
//


/// Snake body part
enum SnakeType {
	case tail, body, curve, head
	
	func symbolName(_ rotation: SnakeDirection) -> String {
		if self == .head {
			switch rotation {
				case .north:
					return "arrow.up.circle"
				case .west:
					return "arrow.left.circle"
				case .south:
					return "arrow.down.circle"
				case .east:
					return "arrow.right.circle"
				default:
					return ""
			}
		}
		if self == .tail {
			switch rotation {
				case .north:
					return "chevron.down"
				case .west:
					return "chevron.right"
				case .south:
					return "chevron.up"
				case .east:
					return "chevron.left"
				default:
					return ""
			}
		}
		if self == .curve {
			return "record.circle"
		}
		switch rotation {
			case .north:
				return "chevron.up.2"
			case .west:
				return "chevron.left.2"
			case .south:
				return "chevron.down.2"
			case .east:
				return "chevron.right.2"
			default:
				return ""
		}
	}
}
