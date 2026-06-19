import Foundation
import SwiftData

@MainActor
final class BundleVault {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll(includeArchived: Bool = false) -> [BalloonBundle] {
        var descriptor = FetchDescriptor<BalloonBundle>(
            sortBy: [SortDescriptor(\.sortOrder), SortDescriptor(\.title)]
        )
        if !includeArchived {
            descriptor.predicate = #Predicate { !$0.isArchived }
        }
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchBuiltIn(key: String) -> BalloonBundle? {
        var descriptor = FetchDescriptor<BalloonBundle>(
            predicate: #Predicate { $0.builtInKey == key }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    func fetch(id: UUID) -> BalloonBundle? {
        var descriptor = FetchDescriptor<BalloonBundle>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    func insert(_ bundle: BalloonBundle) {
        context.insert(bundle)
        try? context.save()
    }

    func save() {
        try? context.save()
    }

    func delete(_ bundle: BalloonBundle) {
        context.delete(bundle)
        try? context.save()
    }
}
