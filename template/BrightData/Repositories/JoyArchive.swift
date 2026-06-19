import Foundation
import SwiftData

@MainActor
final class JoyArchive {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() -> [PopMoment] {
        let descriptor = FetchDescriptor<PopMoment>(
            sortBy: [SortDescriptor(\.poppedAt, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchRecent(limit: Int = 50) -> [PopMoment] {
        var descriptor = FetchDescriptor<PopMoment>(
            sortBy: [SortDescriptor(\.poppedAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? context.fetch(descriptor)) ?? []
    }

    func insert(_ moment: PopMoment) {
        context.insert(moment)
        try? context.save()
    }

    func updateStatus(_ moment: PopMoment, status: PopMomentStatus) {
        moment.status = status
        try? context.save()
    }

    func save() {
        try? context.save()
    }
}
