//#-hidden-code

import UIKit
import PlaygroundSupport

enum HoneyQuantity {
    case abundant
    case justEnough
    case low
}

var seasons: [Int] = [0,1,2,3]
var honeyQuantity: HoneyQuantity = HoneyQuantity.low
var freezingPoint = 0
var current = 0
var responses = [false, false, true]
var temperature = 25

let solution = """
```swift\nfor season in seasons { \n
if honeyQuantity == .abundant { \n\
harvestHoney() \n\
}\n
if temperature < freezingPoint { \n\
coverHive()\n\
}\n\
}\n ```
"""

func coverHive() {
    if current == 1 && temperature <= freezingPoint {
        responses[1] = true
        sendValue(.string("coverHive"))
    }
}

func harvestHoney() {
    if current == 0 && honeyQuantity == .abundant {
        responses[0] = true
        sendValue(.string("harvestHoney"))
    }
}

func routineCheck() {
    if current == 2 {
        responses[2] = true
    }
}
//#-end-hidden-code
/*:
 ### Beekeeping basics
 
 For newbie beekeepers like us the most expected part of beekeeping is harvesting time. But we must remember that harvesting honey means taking away food from our bees, we must be careful not to put them in an tough position if we **take too much honey away**.
 
 Also, even though bees do a pretty good job auto-regulating the hive's temperature by flocking their wings, they need some extra help during the winter, this is why one of the most important tasks of the beekeeper is to **isolate the hive during freezing temperatures.**
 
 ![Beekeeper routine check, source: michiganradio.org](RealHive.jpg)
 
 * Callout(Challenge):
 Write the correct functions in the for-loop considering that:
 
 - You should harvest only when there's a honey surplus.
 
 - That the hive must be covered if the weather reaches freezing temperatures.
 
 */

for season in seasons {
    //#-hidden-code
    sendValue(.integer(season))
    if season == 0 {
        honeyQuantity = .abundant
    } else {
        honeyQuantity = .justEnough
        if season == 3 {
            temperature = -1
        } else {
            temperature = 25
        }
    }
    //#-end-hidden-code
    if honeyQuantity == ./*#-editable-code*/<#quantity##HoneyQuantity#>/*#-end-editable-code*/ {
        //#-hidden-code
        current = 0
        //#-end-hidden-code
        //#-code-completion(everything, hide)
        //#-code-completion(description, show, "harvestHoney()", "coverHive()")
        /*#-editable-code*/<#T##action()#>/*#-end-editable-code*/
    }
    //#-code-completion(everything, hide)
    //#-code-completion(description, show,"==","!=",">=","<=",">","<","freezingPoint")
    if temperature /*#-editable-code*/<#logic#>/*#-end-editable-code*/ {
        //#-hidden-code
        current = 1
        //#-end-hidden-code
        //#-code-completion(everything, hide)
        //#-code-completion(description,hide,"freezingPoint")
        //#-code-completion(description, show, "harvestHoney()", "coverHive()", ")
        /*#-editable-code*/<#T##action()#>/*#-end-editable-code*/
    }
}


//#-hidden-code
sendValue(.string("finishedRunning"))
let data = [
    //    "season": PlaygroundValue.string(week.rawValue),
    "harvested": PlaygroundValue.boolean(responses[0]),
    "covered": PlaygroundValue.boolean(responses[1]),
    "routines": PlaygroundValue.boolean(responses[2])
]
sendValue(.dictionary(data))

if responses == [true, true, true] {
    PlaygroundPage.current.assessmentStatus = .pass(message: "### Wohoo! \n You're starting to become a beekeeper, go to the next page to know why beekeeping is crucial for life on Earth. \n\n[**Next Page**](@next)")
} else if responses[0] == false {
    if honeyQuantity == .abundant {
        PlaygroundPage.current.assessmentStatus = .fail( hints: [
            "You should **only** cover your hive when the temperature is too cold"],
                                                         solution: solution)
    } else {
        PlaygroundPage.current.assessmentStatus = .fail( hints: [
            "Harvest honey **only** when your bees have enough for themselves"],
                                                         solution: solution)
    }
    
} else if responses[1] == false {
    
    if temperature <= freezingPoint {
        
        PlaygroundPage.current.assessmentStatus = .fail( hints: [
            "If the temperature is below `freezingPoint` you should **cover the hive**"],
                                                         solution: solution)
        
    } else {
        
        PlaygroundPage.current.assessmentStatus = .fail( hints: [
            "If the temperature is below `freezingPoint` you should **cover the hive**",
            "Use the `<` operator to test for temperature and then call the appropiate function."],
                                                         solution: solution)
        
    }
}

//#-end-hidden-code





