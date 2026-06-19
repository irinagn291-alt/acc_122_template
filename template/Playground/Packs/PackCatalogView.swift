import SwiftUI
import SwiftData

struct PackCatalogView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var services: SunnyFamilyServices
    @State private var bundles: [BalloonBundle] = []
    @State private var showEditor = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    SunnyScreenHeader(title: "Family Packs")

                    LazyVStack(spacing: 12) {
                        ForEach(bundles, id: \.id) { bundle in
                            NavigationLink {
                                PackDetailView(bundle: bundle)
                            } label: {
                                packRow(bundle)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
            .sunnyScrollScreenBackground()
            .sunnyRootScreenChrome()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showEditor = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(SunnyPalette.primary)
                    }
                }
            }
            .sheet(isPresented: $showEditor) {
                PackEditorView()
                    .sunnySheetStyle()
            }
            .onAppear { reload() }
        }
        .background {
            SunnyPalette.backgroundGradient
                .ignoresSafeArea()
        }
        .preferredColorScheme(.light)
    }

    private func packRow(_ bundle: BalloonBundle) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: bundle.colorHex).opacity(0.2))
                    .frame(width: 50, height: 50)
                Text(bundle.theme.emoji).font(.system(size: 24))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(bundle.title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundStyle(SunnyPalette.text)
                Text("\(bundle.sortedIdeas.count) ideas · \(bundle.theme.label)")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(SunnyPalette.mutedText)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(SunnyPalette.mutedText)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: SunnyPalette.pillRadius, style: .continuous)
                .fill(SunnyPalette.surface)
                .shadow(color: SunnyPalette.primary.opacity(0.1), radius: 8, y: 3)
        )
    }

    private func reload() {
        bundles = services.bundleVault.fetchAll()
    }
}
