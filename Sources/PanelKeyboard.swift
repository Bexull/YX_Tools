import SwiftUI

extension PanelAdditions {
    /// The Kazakh keyboard in the mixer panel: its settings under ⋯ and a note while it
    /// still needs the Accessibility permission.
    static func keyboard(_ keyboard: KazakhKeyboard) -> PanelAdditions {
        PanelAdditions(
            menu: {
                AnyView(Group {
                    Divider()
                    KeyboardMenu(keyboard: keyboard)
                })
            },
            note: { keyboard.needsAccess ? AnyView(KeyboardAccessHint(keyboard: keyboard)) : nil }
        )
    }
}

private struct KeyboardMenu: View {
    let keyboard: KazakhKeyboard

    var body: some View {
        Menu("Казахская клавиатура") {
            Button(keyboard.layoutInstalled ? "Переустановить раскладку" : "Установить раскладку «Русская + Қазақша»") {
                keyboard.installLayout()
            }
            Toggle("Казахские буквы на правом ⌘", isOn: Binding(
                get: { keyboard.rightCommand },
                set: { keyboard.rightCommand = $0 }
            ))
            Toggle("Автозамена казахских слов", isOn: Binding(
                get: { keyboard.autocorrect },
                set: { keyboard.autocorrect = $0 }
            ))
            Button("Мои слова для автозамены…") { keyboard.openUserWords() }
            if let app = keyboard.frontmostApp {
                Toggle("Не исправлять в «\(app.name)»", isOn: Binding(
                    get: { keyboard.isFrontmostExcluded },
                    set: { _ in keyboard.toggleFrontmostExclusion() }
                ))
            }
            if keyboard.learnedCount > 0 {
                Button("Забыть выученное (\(keyboard.learnedCount))") { keyboard.forgetLearned() }
            }
            if keyboard.needsAccess {
                Divider()
                Button("Дать доступ к клавиатуре…") { keyboard.requestAccess() }
            }
        }
    }
}

private struct KeyboardAccessHint: View {
    let keyboard: KazakhKeyboard

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "keyboard")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
            Text("Правому ⌘ и автозамене нужен доступ")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .lineLimit(1)
            Spacer(minLength: 4)
            Button("Открыть") { keyboard.requestAccess() }
                .buttonStyle(.glass)
                .controlSize(.small)
        }
        .padding(.leading, 4)
    }
}
