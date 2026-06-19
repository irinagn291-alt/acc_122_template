import SwiftData
import SwiftUI

enum BrightPersistence {
    static let schema = Schema([
        BalloonBundle.self,
        PopIdea.self,
        PopMoment.self
    ])

    static func makeContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        return try ModelContainer(for: schema, configurations: [config])
    }
}
