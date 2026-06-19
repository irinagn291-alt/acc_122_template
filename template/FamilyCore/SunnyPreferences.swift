import Foundation

@MainActor
final class SunnyPreferences: ObservableObject {
    @Published var soundEnabled: Bool {
        didSet { UserDefaults.standard.set(soundEnabled, forKey: SunnyConstants.soundEnabledKey) }
    }
    @Published var hapticsEnabled: Bool {
        didSet { UserDefaults.standard.set(hapticsEnabled, forKey: SunnyConstants.hapticsEnabledKey) }
    }
    @Published var reduceAnimations: Bool {
        didSet { UserDefaults.standard.set(reduceAnimations, forKey: SunnyConstants.reduceAnimationsKey) }
    }
    @Published var allowRepop: Bool {
        didSet { UserDefaults.standard.set(allowRepop, forKey: SunnyConstants.allowRepopKey) }
    }
    @Published var defaultDailyBundleId: UUID? {
        didSet {
            if let id = defaultDailyBundleId {
                UserDefaults.standard.set(id.uuidString, forKey: SunnyConstants.defaultDailyBundleIdKey)
            } else {
                UserDefaults.standard.removeObject(forKey: SunnyConstants.defaultDailyBundleIdKey)
            }
        }
    }
    @Published var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: SunnyConstants.hasCompletedOnboardingKey) }
    }

    init() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: SunnyConstants.soundEnabledKey) == nil {
            defaults.set(true, forKey: SunnyConstants.soundEnabledKey)
        }
        if defaults.object(forKey: SunnyConstants.hapticsEnabledKey) == nil {
            defaults.set(true, forKey: SunnyConstants.hapticsEnabledKey)
        }
        if defaults.object(forKey: SunnyConstants.allowRepopKey) == nil {
            defaults.set(true, forKey: SunnyConstants.allowRepopKey)
        }
        soundEnabled = defaults.bool(forKey: SunnyConstants.soundEnabledKey)
        hapticsEnabled = defaults.bool(forKey: SunnyConstants.hapticsEnabledKey)
        reduceAnimations = defaults.bool(forKey: SunnyConstants.reduceAnimationsKey)
        allowRepop = defaults.bool(forKey: SunnyConstants.allowRepopKey)
        if let idString = defaults.string(forKey: SunnyConstants.defaultDailyBundleIdKey) {
            defaultDailyBundleId = UUID(uuidString: idString)
        }
        hasCompletedOnboarding = defaults.bool(forKey: SunnyConstants.hasCompletedOnboardingKey)
    }
}
