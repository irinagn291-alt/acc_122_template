import UIKit

enum SunnyShare {
    static func shareMoment(_ moment: PopMoment) -> [Any] {
        let text = "We popped a SunnyPop idea: \(moment.ideaTitle) \(moment.emojiTag)\n#SunnyPop #FamilyFun"
        return [text]
    }

    static func shareBundle(_ bundle: BalloonBundle) -> [Any] {
        let text = "Check out our \(bundle.title) pack on SunnyPop! \(bundle.theme.emoji)"
        return [text]
    }
}
