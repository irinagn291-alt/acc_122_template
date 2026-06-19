import SwiftUI
import UIKit

struct SunnyScreenBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                SunnyPalette.backgroundGradient
                    .ignoresSafeArea()
            }
    }
}

struct SunnyScrollScreenBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background {
                SunnyPalette.backgroundGradient
                    .ignoresSafeArea()
            }
    }
}

enum SunnyNavigationBarStyle {
    static func apply() {
        let background = UIColor(SunnyPalette.background)
        let title = UIColor(SunnyPalette.text)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = background
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [.foregroundColor: title]
        appearance.titleTextAttributes = [.foregroundColor: title]

        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = title
    }
}

extension View {
    func sunnyScreenBackground() -> some View {
        modifier(SunnyScreenBackground())
    }

    func sunnyScrollScreenBackground() -> some View {
        modifier(SunnyScrollScreenBackground())
    }

    func sunnySheetStyle() -> some View {
        presentationBackground {
            SunnyPalette.backgroundGradient
                .ignoresSafeArea()
        }
        .presentationDragIndicator(.visible)
        .preferredColorScheme(.light)
    }

    func sunnyTextField() -> some View {
        foregroundStyle(SunnyPalette.text)
            .tint(SunnyPalette.primary)
    }

    func sunnyRootScreenChrome() -> some View {
        toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
    }

    func sunnyInlineNavTitle(_ title: String) -> some View {
        navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(SunnyPalette.text)
                    .lineLimit(1)
            }
        }
        .toolbarBackground(SunnyPalette.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
