import SwiftUI
import SwiftData

struct CarouselHomeView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var services: SunnyFamilyServices
    @StateObject private var viewModel = PlaygroundViewModel()

    @State private var carouselPage = 0
    @State private var isPopping = false
    @State private var pendingResult: PopBurstResult?
    @State private var showResult = false
    @State private var isRepop = false
    @State private var showPacks = false

    private let carouselTips = [
        ("🌈", "Every pop is a little adventure waiting to happen!"),
        ("👨‍👩‍👧", "Gather the family — one tap, one joyful idea."),
        ("⭐", "Complete pops to grow your star streak together."),
        ("🎁", "Try different packs for rainy days and sunny days!")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                carouselSection
                    .padding(.horizontal, 20)

                PlaygroundGrid(
                    onPopBalloon: { performPop() },
                    onQuickPacks: { showPacks = true },
                    streak: viewModel.streak,
                    ideaOfDay: viewModel.ideaOfDay,
                    bundleTitle: viewModel.dailyBundle?.title
                )
                .padding(.horizontal, 20)

                BalloonPopView(
                    isPopping: isPopping,
                    reduceMotion: services.preferences.reduceAnimations,
                    onTap: { performPop() }
                )
                .padding(.horizontal, 20)

                StarStreakView(streak: viewModel.streak, chartData: viewModel.chartData)
                    .padding(.horizontal, 20)

                HStack(spacing: 12) {
                    SunnyStatTile(title: "Total Pops", value: "\(viewModel.totalPops)", emoji: "🎈")
                    SunnyStatTile(title: "This Month", value: "\(viewModel.monthlyPops)", emoji: "📅")
                    SunnyStatTile(title: "Done Rate", value: "\(Int(viewModel.completionRate * 100))%", emoji: "✅")
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .sunnyScreenBackground()
        .sheet(isPresented: $showResult) {
            if let result = pendingResult {
                PopResultSheet(
                    bundle: result.bundle,
                    idea: result.idea,
                    streak: viewModel.streak,
                    onDone: {
                        viewModel.markDone()
                        showResult = false
                        viewModel.reload(defaultBundleId: services.preferences.defaultDailyBundleId)
                    },
                    onSkip: {
                        viewModel.markSkipped()
                        showResult = false
                    },
                    onRepop: {
                        showResult = false
                        isRepop = true
                        performPop()
                    },
                    allowRepop: services.preferences.allowRepop
                )
                .presentationDetents([.medium, .large])
                .sunnySheetStyle()
            }
        }
        .sheet(isPresented: $showPacks) {
            NavigationStack { PackCatalogView() }
                .sunnySheetStyle()
        }
        .fullScreenCover(item: milestoneBinding) { item in
            MilestoneBurstView(milestone: item.value) {
                viewModel.pendingMilestone = nil
            }
            .preferredColorScheme(.light)
        }
        .onAppear {
            viewModel.setup(
                context: context,
                bundleVault: services.bundleVault,
                joyArchive: services.joyArchive,
                defaultBundleId: services.preferences.defaultDailyBundleId
            )
            SunnyHaptics.shared.setEnabled(services.preferences.hapticsEnabled)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.greeting)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(SunnyPalette.mutedText)
                Text("SunnyPop Playground")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(SunnyPalette.text)
            }
            Spacer()
            Text("☀️").font(.system(size: 32))
        }
    }

    private var carouselSection: some View {
        TabView(selection: $carouselPage) {
            ForEach(carouselTips.indices, id: \.self) { idx in
                HStack(spacing: 14) {
                    Text(carouselTips[idx].0)
                        .font(.system(size: 36))
                    Text(carouselTips[idx].1)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundStyle(SunnyPalette.text)
                        .multilineTextAlignment(.leading)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: SunnyPalette.pillRadius, style: .continuous)
                        .fill(SunnyPalette.secondary.opacity(0.35))
                )
                .tag(idx)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: 110)
    }

    private func performPop() {
        guard let bundle = viewModel.dailyBundle,
              let result = BalloonBurstEngine.shared.pop(bundle: bundle) else { return }
        SunnySound.playPop(enabled: services.preferences.soundEnabled)
        SunnyHaptics.shared.impact(.medium)
        pendingResult = result
        isPopping = true
        viewModel.completePop(result: result, isRepop: isRepop, source: .dailyBalloon)
        isRepop = false

        DispatchQueue.main.asyncAfter(deadline: .now() + SunnyConstants.popAnimationDuration) {
            isPopping = false
            showResult = true
            SunnySound.playCelebrate(enabled: services.preferences.soundEnabled)
        }
    }

    private var milestoneBinding: Binding<MilestoneItem?> {
        Binding(
            get: { viewModel.pendingMilestone.map { MilestoneItem(value: $0) } },
            set: { _ in viewModel.pendingMilestone = nil }
        )
    }
}

struct MilestoneItem: Identifiable {
    let id = UUID()
    let value: Int
}
