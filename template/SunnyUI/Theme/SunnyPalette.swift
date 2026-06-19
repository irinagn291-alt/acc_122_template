import SwiftUI

enum SunnyPalette {
    static let primary = Color(hex: "FF6B6B")
    static let secondary = Color(hex: "FFE66D")
    static let accent = Color(hex: "4ECDC4")
    static let background = Color(hex: "FFF9E6")
    static let surface = Color(hex: "FFFFFF")
    static let text = Color(hex: "2C3E50")
    static let mutedText = Color(hex: "2C3E50").opacity(0.55)
    static let success = Color(hex: "4ECDC4")
    static let warning = Color(hex: "FFE66D")
    static let danger = Color(hex: "FF6B6B")

    static let balloonColors: [Color] = [
        Color(hex: "FF6B6B"),
        Color(hex: "FFE66D"),
        Color(hex: "4ECDC4"),
        Color(hex: "FF9F43"),
        Color(hex: "A29BFE"),
        Color(hex: "FD79A8")
    ]

    static let pillRadius: CGFloat = 24

    static var sunnyGradient: LinearGradient {
        LinearGradient(
            colors: [primary, Color(hex: "FF8E8E")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [background, Color(hex: "FFF3CC")],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

enum SunnySpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        default:
            r = 1; g = 1; b = 1
        }
        self.init(red: r, green: g, blue: b)
    }
}
