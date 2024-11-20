import SwiftUI
import Translation

struct BatchTranslationDemo: View {
    @State private var sampleText = "こんにちは！デモアプリへようこそ。このアプリは、Appleの新しいネイティブAPIをテストするために設計されています。テキストを素早く正確に多言語に翻訳することができます。翻訳したいテキストを入力し、ターゲット言語を選択してください。シームレスなコミュニケーションの力を探求してみましょう！"
    @State private var translatedText = ""
    @State private var translated: Bool = false
    @State private var configuration: TranslationSession.Configuration?

    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    guard !translated else { translated = false; return }
                    if configuration == nil {
                        configuration = TranslationSession
                            .Configuration(source: .init(identifier: "ja-JP"),
                                           target: .init(identifier: Locale.current.language.languageCode?.identifier ?? ""))
                        return
                    }
                    configuration?.invalidate()
                } label: {
                    Label(translated ? "Show original" : "Show translate",
                          systemImage: "translate")
                }
                .padding()
                Text(translated ? translatedText : sampleText)
                Spacer()
            }.padding()
        }.translationTask(configuration) { session in
            let requests = TranslationSession.Request(sourceText: sampleText, clientIdentifier: sampleText)
            if let responses = try? await session.translations(from: [requests]) {
                responses.forEach { response in
                    withAnimation {
                        translated = true
                        translatedText = response.targetText
                    }
                }
            }
        }
    }
}

#Preview {
    BatchTranslationDemo()
}
