import Foundation

struct PopBurstResult {
    let idea: PopIdea
    let bundle: BalloonBundle
    let reelIndex: Int
}

@MainActor
final class BalloonBurstEngine {
    static let shared = BalloonBurstEngine()

    private init() {}

    func pop(bundle: BalloonBundle) -> PopBurstResult? {
        let ideas = bundle.sortedIdeas
        guard !ideas.isEmpty else { return nil }
        let index = Int.random(in: 0..<ideas.count)
        return PopBurstResult(idea: ideas[index], bundle: bundle, reelIndex: index)
    }
}

struct PopStatsSnapshot {
    let totalPops: Int
    let completedPops: Int
    let monthlyPops: Int
    let streak: Int
    let completionRate: Double
    let chartData: [Int]
}

enum PopStatsEngine {
    static func compute(from moments: [PopMoment]) -> PopStatsSnapshot {
        let calendar = Calendar.current
        let now = Date()
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now

        let total = moments.count
        let completed = moments.filter { $0.status == .completed || $0.status == .accepted }.count
        let monthly = moments.filter { $0.poppedAt >= monthStart }.count
        let rate = total > 0 ? Double(completed) / Double(total) : 0

        let chartData = (0..<7).map { offset -> Int in
            guard let day = calendar.date(byAdding: .day, value: -offset, to: now) else { return 0 }
            let start = calendar.startOfDay(for: day)
            guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return 0 }
            return moments.filter { $0.poppedAt >= start && $0.poppedAt < end }.count
        }.reversed()

        return PopStatsSnapshot(
            totalPops: total,
            completedPops: completed,
            monthlyPops: monthly,
            streak: computeStreak(moments: moments),
            completionRate: rate,
            chartData: Array(chartData)
        )
    }

    static func computeStreak(moments: [PopMoment]) -> Int {
        let calendar = Calendar.current
        let activeDays = Set(
            moments
                .filter { $0.status == .completed || $0.status == .accepted }
                .map { calendar.startOfDay(for: $0.poppedAt) }
        )
        guard !activeDays.isEmpty else { return 0 }

        var streak = 0
        var day = calendar.startOfDay(for: .now)

        if !activeDays.contains(day) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: day) else { return 0 }
            day = yesterday
        }

        while activeDays.contains(day) {
            streak += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = prev
        }
        return streak
    }

    static func pendingMilestone(streak: Int) -> Int? {
        let milestones = [3, 7, 14, 30, 60, 100]
        return milestones.first { $0 == streak }
    }
}
