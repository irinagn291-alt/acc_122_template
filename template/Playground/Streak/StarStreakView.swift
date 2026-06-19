import SwiftUI

struct StarStreakView: View {
    let streak: Int
    let chartData: [Int]

    private let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        SunnyCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("⭐ Star Streak")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(SunnyPalette.text)
                    Spacer()
                    Text("\(streak) days")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(SunnyPalette.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(SunnyPalette.secondary.opacity(0.3)))
                }

                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(chartData.indices, id: \.self) { idx in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(chartData[idx] > 0 ? SunnyPalette.primary : SunnyPalette.mutedText.opacity(0.15))
                                .frame(height: max(8, CGFloat(chartData[idx]) * 16))
                            Text(dayLabels[idx % dayLabels.count])
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundStyle(SunnyPalette.mutedText)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 60)
            }
        }
    }
}

struct MilestoneBurstView: View {
    let milestone: Int
    let onDismiss: () -> Void

    @State private var scale: CGFloat = 0.5

    var body: some View {
        ZStack {
            SunnyPalette.backgroundGradient.ignoresSafeArea()
            VStack(spacing: 24) {
                Text("🎉")
                    .font(.system(size: 80))
                    .scaleEffect(scale)
                Text("\(milestone) Day Streak!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(SunnyPalette.text)
                Text("Your family is on fire! Keep popping those joyful ideas together.")
                    .font(.system(size: 17, design: .rounded))
                    .foregroundStyle(SunnyPalette.mutedText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                SunnyPillButton("Amazing!", action: onDismiss)
                    .padding(.horizontal, 40)
                    .padding(.top, 16)
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.2
            }
            SunnyHaptics.shared.notification(.success)
        }
    }
}
