import SwiftUI
import SwiftData
import Combine

@MainActor
final class SunnyFamilyServices: ObservableObject {
    let preferences: SunnyPreferences
    let bundleVault: BundleVault
    let joyArchive: JoyArchive

    private var cancellables = Set<AnyCancellable>()

    init(context: ModelContext) {
        preferences = SunnyPreferences()
        bundleVault = BundleVault(context: context)
        joyArchive = JoyArchive(context: context)

        preferences.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
}
