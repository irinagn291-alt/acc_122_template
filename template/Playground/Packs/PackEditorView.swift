import SwiftUI
import SwiftData

struct PackEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var services: SunnyFamilyServices

    @State private var title = ""
    @State private var selectedTheme: FamilyTheme = .custom
    @State private var ideas: [String] = ["", ""]

    var body: some View {
        NavigationStack {
            Form {
                Section("Pack Name") {
                    TextField("My Family Pack", text: $title)
                }
                Section("Theme") {
                    Picker("Theme", selection: $selectedTheme) {
                        ForEach(FamilyTheme.allCases.filter { $0 != .custom } + [.custom], id: \.self) { theme in
                            Text("\(theme.emoji) \(theme.label)").tag(theme)
                        }
                    }
                }
                Section("Ideas (min 2)") {
                    ForEach(ideas.indices, id: \.self) { idx in
                        TextField("Idea \(idx + 1)", text: $ideas[idx])
                    }
                    if ideas.count < SunnyConstants.maxIdeas {
                        Button("Add idea") { ideas.append("") }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .sunnyScrollScreenBackground()
            .sunnyInlineNavTitle("New Pack")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!canSave)
                }
            }
        }
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        ideas.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.count >= SunnyConstants.minIdeas
    }

    private func save() {
        let trimmedTitle = String(title.prefix(SunnyConstants.maxBundleNameLength))
        let validIdeas = ideas
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .prefix(SunnyConstants.maxIdeas)

        let bundleId = UUID()
        let bundle = BalloonBundle(
            id: bundleId,
            title: trimmedTitle,
            theme: selectedTheme,
            iconName: "balloon.fill",
            colorHex: "FF6B6B",
            sortOrder: 100
        )
        bundle.ideas = validIdeas.enumerated().map { index, ideaTitle in
            PopIdea(
                bundleId: bundleId,
                number: index + 1,
                title: String(ideaTitle.prefix(SunnyConstants.maxIdeaTitleLength)),
                emojiTag: SunnySeedLoader.balloonEmojis[index % SunnySeedLoader.balloonEmojis.count]
            )
        }
        services.bundleVault.insert(bundle)
        dismiss()
    }
}
