import SwiftUI
import SwiftData

@MainActor
final class PlaygroundViewModel: ObservableObject {
    @Published var dailyBundle: BalloonBundle?
    @Published var ideaOfDay: PopIdea?
    @Published var streak = 0
    @Published var totalPops = 0
    @Published var completionRate: Double = 0
    @Published var monthlyPops = 0
    @Published var chartData: [Int] = []
    @Published var lastPoppedIdea: PopIdea?
    @Published var pendingMilestone: Int?
    @Published var greeting = "Good morning, sunshine!"

    private var context: ModelContext?
    private var joyArchive: JoyArchive?
    private var bundleVault: BundleVault?

    func setup(context: ModelContext, bundleVault: BundleVault, joyArchive: JoyArchive, defaultBundleId: UUID?) {
        self.context = context
        self.bundleVault = bundleVault
        self.joyArchive = joyArchive
        reload(defaultBundleId: defaultBundleId)
    }

    func reload(defaultBundleId: UUID? = nil) {
        guard let bundleVault, let joyArchive else { return }

        let key = SunnySeedLoader.dailyBundleKey()
        dailyBundle = bundleVault.fetchBuiltIn(key: key)
            ?? bundleVault.fetchAll().first

        if let defaultId = defaultBundleId, let custom = bundleVault.fetch(id: defaultId) {
            dailyBundle = custom
        }

        if let bundle = dailyBundle {
            let ideas = bundle.sortedIdeas
            let dayIndex = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 0
            ideaOfDay = ideas.isEmpty ? nil : ideas[dayIndex % ideas.count]
        }

        let moments = joyArchive.fetchAll()
        let stats = PopStatsEngine.compute(from: moments)
        streak = stats.streak
        totalPops = stats.totalPops
        completionRate = stats.completionRate
        monthlyPops = stats.monthlyPops
        chartData = stats.chartData
        greeting = Self.greetingForNow()
    }

    func completePop(result: PopBurstResult, isRepop: Bool, source: PopSource) {
        guard let joyArchive else { return }
        let moment = PopMoment(
            bundleId: result.bundle.id,
            bundleTitle: result.bundle.title,
            ideaTitle: result.idea.title,
            ideaDetails: result.idea.details,
            emojiTag: result.idea.emojiTag,
            status: .popped,
            source: source,
            streakDay: streak
        )
        joyArchive.insert(moment)
        lastPoppedIdea = result.idea

        if !isRepop, let milestone = PopStatsEngine.pendingMilestone(streak: streak + 1) {
            pendingMilestone = milestone
        }
    }

    func markDone() {
        guard let joyArchive, let last = joyArchive.fetchRecent(limit: 1).first else { return }
        joyArchive.updateStatus(last, status: .completed)
    }

    func markSkipped() {
        guard let joyArchive, let last = joyArchive.fetchRecent(limit: 1).first else { return }
        joyArchive.updateStatus(last, status: .skipped)
    }

    private static func greetingForNow() -> String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12: return "Good morning, sunshine!"
        case 12..<17: return "Happy afternoon, family!"
        case 17..<21: return "Evening pop time!"
        default: return "Cozy night pops!"
        }
    }
}
