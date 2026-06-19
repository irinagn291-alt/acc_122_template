import SwiftUI

struct SunnySettingsView: View {
    @EnvironmentObject private var services: SunnyFamilyServices
    @State private var showTerms = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SunnyScreenHeader(title: "Settings")
                Form {
                Section("Daily Balloon") {
                    Picker("Default Pack", selection: defaultBundleBinding) {
                        Text("Auto (by day)").tag(UUID?.none)
                        ForEach(services.bundleVault.fetchAll(), id: \.id) { bundle in
                            Text("\(bundle.theme.emoji) \(bundle.title)").tag(Optional(bundle.id))
                        }
                    }
                }

                Section("Experience") {
                    Toggle("Sound Effects", isOn: binding(\.soundEnabled))
                    Toggle("Haptic Feedback", isOn: binding(\.hapticsEnabled))
                    Toggle("Reduce Animations", isOn: binding(\.reduceAnimations))
                    Toggle("Allow Re-pop", isOn: binding(\.allowRepop))
                }

                Section("About SunnyPop") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0").foregroundStyle(SunnyPalette.mutedText)
                    }
                    NavigationLink { PortalContactView() } label: { Text("Contact Us") }
                    NavigationLink { PortalPrivacyView() } label: { Text("Privacy Policy") }
                    Button("Terms of Use") { showTerms = true }
                }

                Section {
                    Button("Replay Welcome Tour") {
                        services.preferences.hasCompletedOnboarding = false
                    }
                    .foregroundStyle(SunnyPalette.primary)
                }
                }
            }
            .sunnyScrollScreenBackground()
            .sunnyRootScreenChrome()
            
            
            .sheet(isPresented: $showTerms) {
                SunnyLegalView(type: .terms)
                    .sunnySheetStyle()
            }
            .onChange(of: services.preferences.hapticsEnabled) { _, enabled in
                SunnyHaptics.shared.setEnabled(enabled)
            }
        }
        .background {
            SunnyPalette.backgroundGradient
                .ignoresSafeArea()
        }
        .preferredColorScheme(.light)
    }

    private func binding(_ keyPath: ReferenceWritableKeyPath<SunnyPreferences, Bool>) -> Binding<Bool> {
        Binding(
            get: { services.preferences[keyPath: keyPath] },
            set: { services.preferences[keyPath: keyPath] = $0 }
        )
    }

    private var defaultBundleBinding: Binding<UUID?> {
        Binding(
            get: { services.preferences.defaultDailyBundleId },
            set: { services.preferences.defaultDailyBundleId = $0 }
        )
    }
}

struct SunnyContactSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                Text("🎈")
                    .font(.system(size: 56))
                Button("Open in Safari") {
                    if let url = URL(string: SunnyConstants.contactURL) { openURL(url) }
                }
                .buttonStyle(.borderedProminent)
                .tint(SunnyPalette.primary)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .sunnyScreenBackground()
            .sunnyInlineNavTitle("Contact")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
