import SwiftUI

struct BubbleParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var scale: CGFloat
    var opacity: Double
    var color: Color
}

struct BubbleParticleView: View {
    let particles: [BubbleParticle]

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color.opacity(particle.opacity))
                    .frame(width: 12 * particle.scale, height: 12 * particle.scale)
                    .position(x: particle.x, y: particle.y)
            }
        }
        .allowsHitTesting(false)
    }
}

struct BubbleBurstEffect: View {
    @State private var particles: [BubbleParticle] = []
    let center: CGPoint
    let colors: [Color]
    @Binding var isActive: Bool

    var body: some View {
        BubbleParticleView(particles: particles)
            .onChange(of: isActive) { _, active in
                if active { burst() }
            }
    }

    private func burst() {
        particles = (0..<18).map { _ in
            BubbleParticle(
                x: center.x + CGFloat.random(in: -80...80),
                y: center.y + CGFloat.random(in: -100...20),
                scale: CGFloat.random(in: 0.5...1.5),
                opacity: Double.random(in: 0.4...1.0),
                color: colors.randomElement() ?? SunnyPalette.primary
            )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            particles = []
            isActive = false
        }
    }
}
