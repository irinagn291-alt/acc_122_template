import SwiftUI

struct JoyArchiveView: View {
    @EnvironmentObject private var services: SunnyFamilyServices
    @State private var moments: [PopMoment] = []
    @State private var showShare = false
    @State private var shareItems: [Any] = []

    var body: some View {
        NavigationStack {
            Group {
                if moments.isEmpty {
                    VStack(spacing: 0) {
                        SunnyScreenHeader(title: "Joy Archive")
                        SunnyEmptyState(
                            emoji: "💛",
                            title: "No joyful moments yet",
                            message: "Pop your first balloon and your family memories will appear here!"
                        )
                        Spacer(minLength: 0)
                    }
                    .sunnyScreenBackground()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            SunnyScreenHeader(title: "Joy Archive")

                            LazyVStack(spacing: 12) {
                                ForEach(moments, id: \.id) { moment in
                                    momentRow(moment)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 100)
                    }
                    .sunnyScrollScreenBackground()
                }
            }
            .sunnyRootScreenChrome()
            .onAppear { reload() }
            .sheet(isPresented: $showShare) {
                SunnyShareSheet(items: shareItems)
                    .sunnySheetStyle()
            }
        }
        .background {
            SunnyPalette.backgroundGradient
                .ignoresSafeArea()
        }
        .preferredColorScheme(.light)
    }

    private func momentRow(_ moment: PopMoment) -> some View {
        HStack(spacing: 14) {
            Text(moment.emojiTag).font(.system(size: 28))
            VStack(alignment: .leading, spacing: 4) {
                Text(moment.ideaTitle)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(SunnyPalette.text)
                Text(moment.bundleTitle)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(SunnyPalette.mutedText)
                Text(moment.poppedAt.formatted(.dateTime.month().day().hour().minute()))
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(SunnyPalette.mutedText.opacity(0.7))
            }
            Spacer()
            VStack(spacing: 8) {
                PopStatusBadge(status: moment.status)
                Button {
                    shareItems = SunnyShare.shareMoment(moment)
                    showShare = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 14))
                        .foregroundStyle(SunnyPalette.accent)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: SunnyPalette.pillRadius, style: .continuous)
                .fill(SunnyPalette.surface)
                .shadow(color: SunnyPalette.primary.opacity(0.08), radius: 6, y: 2)
        )
        .contextMenu {
            Button("Mark done") {
                services.joyArchive.updateStatus(moment, status: .completed)
                reload()
            }
            Button("Skip") {
                services.joyArchive.updateStatus(moment, status: .skipped)
                reload()
            }
        }
    }

    private func reload() {
        moments = services.joyArchive.fetchAll()
    }
}
