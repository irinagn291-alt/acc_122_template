import SwiftUI

struct BalloonPopView: View {
    let isPopping: Bool
    let reduceMotion: Bool
    let onTap: () -> Void

    @State private var floatOffset: CGFloat = 0
    @State private var wiggle: Double = 0
    @State private var showBurst = false
    @State private var burstCenter = CGPoint(x: 150, y: 150)

    var body: some View {
        GeometryReader { geo in
            ZStack {
                BubbleBurstEffect(
                    center: burstCenter,
                    colors: SunnyPalette.balloonColors,
                    isActive: $showBurst
                )

                Button(action: {
                    burstCenter = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                    showBurst = true
                    onTap()
                }) {
                    ZStack {
                        Ellipse()
                            .fill(
                                RadialGradient(
                                    colors: [SunnyPalette.primary, SunnyPalette.primary.opacity(0.7)],
                                    center: .topLeading,
                                    startRadius: 10,
                                    endRadius: 120
                                )
                            )
                            .frame(width: 160, height: 190)
                            .shadow(color: SunnyPalette.primary.opacity(0.4), radius: 20, y: 10)

                        Ellipse()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 40, height: 55)
                            .offset(x: -30, y: -50)

                        Path { path in
                            path.move(to: CGPoint(x: 80, y: 190))
                            path.addQuadCurve(
                                to: CGPoint(x: 80, y: 240),
                                control: CGPoint(x: 100, y: 215)
                            )
                        }
                        .stroke(SunnyPalette.primary.opacity(0.5), lineWidth: 2)
                        .offset(y: -25)

                        if isPopping {
                            Text("💥")
                                .font(.system(size: 48))
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            Text("🎈")
                                .font(.system(size: 36))
                                .offset(y: -60)
                        }
                    }
                    .scaleEffect(isPopping ? 1.3 : 1.0)
                    .opacity(isPopping ? 0 : 1)
                    .offset(y: reduceMotion ? 0 : floatOffset)
                    .rotationEffect(.degrees(reduceMotion ? 0 : wiggle))
                }
                .disabled(isPopping)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
        }
        .frame(height: 280)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                floatOffset = -12
            }
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                wiggle = 3
            }
        }
    }
}
