//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//#-code-completion(everything, hide)
import Foundation
import PlaygroundSupport

enum Seed: String {
    case 💐 = "💐"
    case 🌷 = "🌷"
    case 🌸 = "🌸"
    case 🌹 = "🌹"
    case 🌺 = "🌺"
    case 🌻 = "🌻"
    case 🌼 = "🌼"
    case 🍅 = "🍅"
    case 🍇 = "🍇"
    case 🍈 = "🍈"
    case 🍉 = "🍉"
    case 🍊 = "🍊"
    case 🍋 = "🍋"
    case 🍌 = "🍌"
    case 🍍 = "🍍"
    case 🍎 = "🍎"
    case 🍐 = "🍐"
    case 🍑 = "🍑"
    case 🍒 = "🍒"
    case 🍓 = "🍓"
    case 🥝 = "🥝"
    case 🥭 = "🥭"
}
var 💐 = Seed.💐
var 🌷 = Seed.🌷
var 🌸 = Seed.🌸
var 🌹 = Seed.🌹
var 🌺 = Seed.🌺
var 🌻 = Seed.🌻
var 🌼 = Seed.🌼
var 🍅 = Seed.🍅
var 🍇 = Seed.🍇
var 🍈 = Seed.🍈
var 🍉 = Seed.🍉
var 🍊 = Seed.🍊
var 🍋 = Seed.🍋
var 🍌 = Seed.🍌
var 🍍 = Seed.🍍
var 🍎 = Seed.🍎
var 🍐 = Seed.🍐
var 🍑 = Seed.🍑
var 🍒 = Seed.🍒
var 🍓 = Seed.🍓
var 🥝 = Seed.🥝
var 🥭 = Seed.🥭

func plant(seed: Seed) {
    sendValue(.string(seed.rawValue))
}
//#-end-hidden-code
/*:
 ### Bees and humans
 # An often overlooked symbiotic relationship
 
 Out of all insects, bees are the ones that contribute the most to pollination, a bee can travel up to 8km to find polen, fertilizing other plants she might find on the way.

 Unfortunately, we have seen a decline in honeybee colonies, which puts at risk the many crops that are crucial to human survival.
 
 Beekeeping is a humble and gratifying task but there are many other ways we can help bees reclaim their environment. If you live in a city, having biodiverse gardens has proven to have helped bees thriving in some other urban areas.
 
 [Almond flower source: my own, Luciano Gucciardo](Flowers.png)
 
 * Callout(Try this):
 Use a for loop to go through the array of seeds to recreate the bees' environment. You can tap on the screen to see the effects of a bees work.

 */

let wildflowers = [💐,🌷,🌸,🌹,🌺,🌻,🌼]
let crops = [🍅,🍇,🍈,🍉,🍊,🍋,🍌,🍍,🍎,🍐,🍑,🍒,🍓,🥝,🥭]


//#-editable-code Start planting
//#-code-completion(description, show, "plant(seed: Seed)")
//#-code-completion(description, show,"💐","🌷","🌸","🌹","🌺","🌻","🌼","🍅","🍇","🍈","🍉","🍊","🍋","🍌","🍍","🍎","🍐","🍑","🍒","🍓","🥝","🥭")

plant(seed: 🍋 )

//#-code-completion(everything, hide)
//#-code-completion(description, show, "crops", "wildflowers")
for seed in wildflowers {
    plant(seed: seed )
}
//#-end-editable-code

//#-hidden-code
PlaygroundPage.current.assessmentStatus = .pass(message: "### Well done beekeeper! \n Thank you for joining this journey now take what you have learned and **help bees in the real World.**")
//#-end-hidden-code
