import Foundation
import SwiftData

struct BuiltInFamilyPack {
    let key: String
    let title: String
    let theme: FamilyTheme
    let iconName: String
    let colorHex: String
    let sortOrder: Int
    let ideas: [(String, String)]
}

enum SunnySeedLoader {
    static let packs: [BuiltInFamilyPack] = [
        BuiltInFamilyPack(key: "sunday_fun", title: "Sunday Fun", theme: .together,
                          iconName: "sun.max.fill", colorHex: "FF6B6B", sortOrder: 0,
                          ideas: [
                              ("Build a blanket fort", "Grab pillows and make a cozy hideout together 🏰"),
                              ("Family story time", "Each person adds one sentence to a silly tale 📚"),
                              ("Living room dance party", "Pick a song and wiggle together 💃"),
                              ("Draw each other", "Funny portraits only — no perfection! 🎨"),
                              ("Treasure hunt at home", "Hide little notes with sweet clues 🔍"),
                              ("Pillow fight (gentle!)", "Soft pillows, big laughs, zero tears 🛋️")
                          ]),
        BuiltInFamilyPack(key: "outdoor_play", title: "Outdoor Play", theme: .outdoor,
                          iconName: "leaf.fill", colorHex: "4ECDC4", sortOrder: 1,
                          ideas: [
                              ("Cloud watching", "Lie down and name shapes in the sky ☁️"),
                              ("Nature scavenger hunt", "Find a leaf, a rock, and something yellow 🍃"),
                              ("Sidewalk chalk art", "Draw a sunny mural on the pavement 🖍️"),
                              ("Bubble chase", "Who can pop the most bubbles? 🫧"),
                              ("Park picnic", "Pack snacks and eat on the grass 🧺"),
                              ("Bug safari", "Look for ladybugs and ants with a magnifier 🔎")
                          ]),
        BuiltInFamilyPack(key: "creative_spark", title: "Creative Spark", theme: .creative,
                          iconName: "paintbrush.fill", colorHex: "FFE66D", sortOrder: 2,
                          ideas: [
                              ("Make friendship bracelets", "One for each family member 💛"),
                              ("Cardboard castle", "Turn a box into a royal fortress 📦"),
                              ("Family band jam", "Pots, pans, and spoons as drums 🥁"),
                              ("Origami animals", "Fold paper creatures together 🦊"),
                              ("Photo booth fun", "Silly faces and props only 📸"),
                              ("Paint rocks", "Bright colors for the garden path 🪨")
                          ]),
        BuiltInFamilyPack(key: "kitchen_joy", title: "Kitchen Joy", theme: .kitchen,
                          iconName: "fork.knife", colorHex: "FF6B6B", sortOrder: 3,
                          ideas: [
                              ("Decorate cupcakes", "Sprinkles everywhere — no rules! 🧁"),
                              ("Smoothie experiment", "Mix fruits and name your creation 🥤"),
                              ("Pizza night", "Everyone picks their own toppings 🍕"),
                              ("Cookie cutters fun", "Shape dough into stars and hearts ⭐"),
                              ("Fruit kebab skewers", "Rainbow colors on a stick 🍓"),
                              ("Hot chocolate bar", "Whipped cream, marshmallows, joy ☕")
                          ]),
        BuiltInFamilyPack(key: "cozy_calm", title: "Cozy Calm", theme: .quiet,
                          iconName: "moon.stars.fill", colorHex: "4ECDC4", sortOrder: 4,
                          ideas: [
                              ("Gratitude jar", "Write one happy thing each 🫙"),
                              ("Stargazing from window", "Count the brightest stars ✨"),
                              ("Read aloud together", "One chapter, many voices 📖"),
                              ("Gentle yoga stretch", "Reach for the sky like a sunflower 🌻"),
                              ("Lullaby sing-along", "Soft songs before bedtime 🎵"),
                              ("Warm bath bubbles", "Rubber duck parade time 🦆")
                          ]),
        BuiltInFamilyPack(key: "weekend_magic", title: "Weekend Magic", theme: .weekend,
                          iconName: "sparkles", colorHex: "FFE66D", sortOrder: 5,
                          ideas: [
                              ("Movie matinee at home", "Popcorn and pajamas mandatory 🍿"),
                              ("Farmers market trip", "Pick one new fruit to try 🍎"),
                              ("Bike ride adventure", "Explore a new street together 🚲"),
                              ("Board game marathon", "Winner picks dessert 🎲"),
                              ("Build a LEGO city", "Skyscrapers and silly shops 🏙️"),
                              ("Backyard camping", "Tent, flashlights, and stories ⛺")
                          ]),
        BuiltInFamilyPack(key: "rainy_day", title: "Rainy Day", theme: .together,
                          iconName: "cloud.rain.fill", colorHex: "FF6B6B", sortOrder: 6,
                          ideas: [
                              ("Indoor obstacle course", "Cushions, chairs, and giggles 🏃"),
                              ("Bake banana bread", "Mash, mix, and smell the magic 🍌"),
                              ("Puppet show time", "Socks become superstars 🧦"),
                              ("Puzzle race", "Team up on a big jigsaw 🧩"),
                              ("Write a family comic", "Draw your funniest adventure 💬"),
                              ("Hot cocoa and stories", "Rain sounds = perfect backdrop 🌧️")
                          ]),
        BuiltInFamilyPack(key: "after_school", title: "After School", theme: .together,
                          iconName: "backpack.fill", colorHex: "4ECDC4", sortOrder: 7,
                          ideas: [
                              ("Share one good thing", "Everyone tells their best moment 💬"),
                              ("Quick park visit", "Fifteen minutes of fresh air 🌤️"),
                              ("Homework helper huddle", "Teamwork makes it faster ✏️"),
                              ("Snack taste test", "Blindfold and guess the fruit 🍇"),
                              ("Jump rope challenge", "How many in a row? 🪢"),
                              ("Build with blocks", "Tallest tower wins 🏗️")
                          ])
    ]

    static let balloonEmojis = ["🎈", "🌟", "🌈", "🦋", "🌸", "🍭", "🎪", "🐣"]

    static func seedIfNeeded(context: ModelContext) {
        guard !UserDefaults.standard.bool(forKey: SunnyConstants.hasSeededBundlesKey) else { return }
        for pack in packs {
            let bundleId = UUID()
            let bundle = BalloonBundle(
                id: bundleId,
                title: pack.title,
                theme: pack.theme,
                iconName: pack.iconName,
                colorHex: pack.colorHex,
                isBuiltIn: true,
                sortOrder: pack.sortOrder,
                builtInKey: pack.key
            )
            bundle.ideas = pack.ideas.enumerated().map { index, item in
                let emoji = balloonEmojis[index % balloonEmojis.count]
                return PopIdea(bundleId: bundleId, number: index + 1, title: item.0, details: item.1, emojiTag: emoji)
            }
            context.insert(bundle)
        }
        try? context.save()
        UserDefaults.standard.set(true, forKey: SunnyConstants.hasSeededBundlesKey)
    }

    static func dailyBundleKey(for date: Date = .now) -> String {
        let weekday = Calendar.current.component(.weekday, from: date)
        switch weekday {
        case 1: return "weekend_magic"
        case 2: return "after_school"
        case 3: return "creative_spark"
        case 4: return "outdoor_play"
        case 5: return "kitchen_joy"
        case 6: return "sunday_fun"
        case 7: return "cozy_calm"
        default: return "sunday_fun"
        }
    }
}
