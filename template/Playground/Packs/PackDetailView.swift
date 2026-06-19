import SwiftUI
import SwiftData

struct PackDetailView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var services: SunnyFamilyServices
    let bundle: BalloonBundle

    @State private var isPopping = false
    @State private var pendingResult: PopBurstResult?
    @State private var showResult = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(bundle.theme.emoji).font(.system(size: 48))
                    Text(bundle.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(SunnyPalette.text)
                    Text(bundle.theme.label)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundStyle(SunnyPalette.mutedText)
                }
                .padding(.top, 8)

                BalloonPopView(
                    isPopping: isPopping,
                    reduceMotion: services.preferences.reduceAnimations,
                    onTap: { performPop() }
                )

                SunnyPillButton("Pop from this pack", icon: "balloon.fill") {
                    performPop()
                }
                .padding(.horizontal, 20)

                SunnyCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Ideas inside")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(SunnyPalette.text)
                        ForEach(bundle.sortedIdeas, id: \.id) { idea in
                            HStack(spacing: 10) {
                                Text(idea.emojiTag)
                                Text(idea.title)
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundStyle(SunnyPalette.text)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .sunnyScrollScreenBackground()
        .sunnyInlineNavTitle(bundle.title)
        .sheet(isPresented: $showResult) {
            if let result = pendingResult {
                PopResultSheet(
                    bundle: result.bundle,
                    idea: result.idea,
                    streak: 0,
                    onDone: { showResult = false },
                    onSkip: { showResult = false },
                    onRepop: { showResult = false; performPop() },
                    allowRepop: services.preferences.allowRepop
                )
                .presentationDetents([.medium, .large])
                .sunnySheetStyle()
            }
        }
    }

    private func performPop() {
        guard let result = BalloonBurstEngine.shared.pop(bundle: bundle) else { return }
        SunnySound.playPop(enabled: services.preferences.soundEnabled)
        pendingResult = result
        isPopping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + SunnyConstants.popAnimationDuration) {
            isPopping = false
            showResult = true
        }
    }
}
