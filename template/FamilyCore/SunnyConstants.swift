import Foundation

enum SunnyConstants {
    static let appName = "SunnyPop"
    static let contactURL = PortalConfig.contactURL
    static let privacyURL = PortalConfig.privacyURL
    static let maxBundleNameLength = 60
    static let maxIdeaTitleLength = 100
    static let maxIdeaDetailsLength = 240
    static let minIdeas = 2
    static let maxIdeas = 20
    static let popAnimationDuration: TimeInterval = 1.2
    static let hasCompletedOnboardingKey = "sunny_hasCompletedOnboarding"
    static let hasSeededBundlesKey = "sunny_hasSeededBundles"
    static let defaultDailyBundleIdKey = "sunny_defaultDailyBundleId"
    static let soundEnabledKey = "sunny_soundEnabled"
    static let hapticsEnabledKey = "sunny_hapticsEnabled"
    static let reduceAnimationsKey = "sunny_reduceAnimations"
    static let allowRepopKey = "sunny_allowRepop"
}
