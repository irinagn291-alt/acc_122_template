import SwiftUI

struct FamilyInsightsView: View {
    @EnvironmentObject private var services: SunnyFamilyServices
    @State private var stats = PopStatsSnapshot(totalPops: 0, completedPops: 0, monthlyPops: 0, streak: 0, completionRate: 0, chartData: [])

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    SunnyScreenHeader(title: "Family Stars")

                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            SunnyStatTile(title: "Total Pops", value: "\(stats.totalPops)", emoji: "🎈")
                            SunnyStatTile(title: "Completed", value: "\(stats.completedPops)", emoji: "✅")
                        }
                        HStack(spacing: 12) {
                            SunnyStatTile(title: "Streak", value: "\(stats.streak)", emoji: "⭐")
                            SunnyStatTile(title: "This Month", value: "\(stats.monthlyPops)", emoji: "📅")
                        }

                        StarStreakView(streak: stats.streak, chartData: stats.chartData)

                        SunnyCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Family Fun Score")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundStyle(SunnyPalette.text)
                                HStack {
                                    Text("\(Int(stats.completionRate * 100))%")
                                        .font(.system(size: 36, weight: .bold, design: .rounded))
                                        .foregroundStyle(SunnyPalette.primary)
                                    Spacer()
                                    Text(stats.completionRate >= 0.7 ? "🌟" : stats.completionRate >= 0.4 ? "😊" : "🌱")
                                        .font(.system(size: 40))
                                }
                                Text(completionMessage)
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundStyle(SunnyPalette.mutedText)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
            .sunnyScrollScreenBackground()
            .sunnyRootScreenChrome()
            .onAppear { reload() }
        }
        .background {
            SunnyPalette.backgroundGradient
                .ignoresSafeArea()
        }
        .preferredColorScheme(.light)
    }

    private var completionMessage: String {
        if stats.completionRate >= 0.7 {
            return "Wow! Your family is crushing it with joyful activities!"
        } else if stats.completionRate >= 0.4 {
            return "Nice progress! A few more pops and you'll be shining."
        } else {
            return "Every pop counts — start small and grow together!"
        }
    }

    private func reload() {
        stats = PopStatsEngine.compute(from: services.joyArchive.fetchAll())
    }
}
