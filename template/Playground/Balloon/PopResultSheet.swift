import SwiftUI

struct PopResultSheet: View {
    let bundle: BalloonBundle
    let idea: PopIdea
    let streak: Int
    let onDone: () -> Void
    let onSkip: () -> Void
    let onRepop: () -> Void
    let allowRepop: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text(idea.emojiTag)
                .font(.system(size: 56))
                .padding(.top, 8)

            Text("Pop! Here's your idea")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(SunnyPalette.mutedText)

            Text(idea.title)
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(SunnyPalette.text)
                .multilineTextAlignment(.center)

            if !idea.details.isEmpty {
                Text(idea.details)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(SunnyPalette.mutedText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            HStack(spacing: 8) {
                Text(bundle.theme.emoji)
                Text(bundle.title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(SunnyPalette.accent)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Capsule().fill(SunnyPalette.accent.opacity(0.15)))

            if streak > 0 {
                HStack(spacing: 4) {
                    Text("⭐")
                    Text("\(streak) day streak!")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(SunnyPalette.secondary)
                }
            }

            Spacer(minLength: 0)

            VStack(spacing: 12) {
                SunnyPillButton("We did it!", icon: "checkmark.circle.fill", action: onDone)
                HStack(spacing: 12) {
                    Button("Maybe later") { onSkip() }
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(SunnyPalette.mutedText)
                        .frame(maxWidth: .infinity)
                    if allowRepop {
                        Button("Pop again") { onRepop() }
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundStyle(SunnyPalette.primary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            SunnyPalette.backgroundGradient
                .ignoresSafeArea()
        }
        .preferredColorScheme(.light)
    }
}
