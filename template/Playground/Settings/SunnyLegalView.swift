import SwiftUI

enum LegalDocType {
    case privacy, terms

    var title: String {
        switch self {
        case .privacy: "Privacy Policy"
        case .terms: "Terms of Use"
        }
    }

    var content: String {
        switch self {
        case .privacy:
            """
            SunnyPop respects your family's privacy.

            We collect minimal data needed to improve the app experience. \
            Your balloon pops and family packs are stored locally on your device.

            We use analytics to understand app performance. \
            You can control tracking permissions in your device settings.

            We never sell personal information. \
            For questions, reach us through the Contact page.
            """
        case .terms:
            """
            Welcome to SunnyPop!

            SunnyPop provides fun family activity ideas through balloon pops. \
            Ideas are suggestions — parents should always supervise children.

            You may create custom packs for personal family use. \
            Built-in packs are provided as-is for entertainment.

            We are not liable for activities chosen through the app. \
            Use common sense and have fun together!
            """
        }
    }
}

struct SunnyLegalView: View {
    let type: LegalDocType
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(type.content)
                    .font(.system(size: 15, design: .rounded))
                    .foregroundStyle(SunnyPalette.text)
                    .padding(20)
            }
            .sunnyScrollScreenBackground()
            .sunnyInlineNavTitle(type.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .background {
            SunnyPalette.backgroundGradient
                .ignoresSafeArea()
        }
        .preferredColorScheme(.light)
    }
}
