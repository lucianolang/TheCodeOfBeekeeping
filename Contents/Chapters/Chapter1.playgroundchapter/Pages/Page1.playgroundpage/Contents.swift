//#-hidden-code
import UIKit
import PlaygroundSupport

var colors = [0xB46520,0xD2B13C,0xCB8F25,0xF8C71C,0xB46520,0x6D280C]

import UIKit

public class Hive {
    
    var size: Size = .small
    var workers: Int = 0
    var queen = false
    var drones = 0
    var color = UIColor.white
    
    public enum Size: Int {
        case small = 56
        case medium = 128
        case large = 256
        case enormous = 900
    }
    
    public init(color: UIColor, size: Size) {
        self.color = color
        self.size = size
    }
}

//#-end-hidden-code
/*:
# Create your hive
 
 In this page we're going to create our hive. First, let's choose a size and a color:
 
 */
let myHive = Hive(
 //#-code-completion(everything, hide)
 //#-code-completion(literal, show, color)
    color: /*#-editable-code*/#colorLiteral(red: 0.9720787406, green: 0.7803329825, blue: 0.1127732471, alpha: 1)/*#-end-editable-code*/,
 //#-code-completion(literal, hide, color)
 //#-code-completion(identifier, show, small, medium, large, enormous)
    size: ./*#-editable-code*/<#tap to set size#>/*#-end-editable-code*/
 //#-code-completion(identifier, hide, small, medium, large, enormous)
    )
/*:
     
 Now, we must know every hive needs to have 3 types of bees:
 

 1. **Workers: Sterile female workers**
 
  ![The workers of the hive](Worker.png)
 
They clean the hive, feed the larvae, regulate the temperature of the hive, feed and grooming the queen, collect nectar and pollen and more.
 
 Set a number of workers for your hive.
 
 - Important:
 Be carefull not to add too many or yout bees will swarm.
 */
    //#-code-completion(literal, show, 5, 15, 35, 42, 156, 250)
myHive.workers = /*#-editable-code*/10/*#-end-editable-code*/
/*:
 
 
 2. **Drones: The males of the hive.**
 
  ![The males of the hive](Drone.png)
 
Their sole job is to mate with the queen. Workers kick them out of the hive during winter to preserve the precious and scarce honey.
 
 Set a number of drones for your hive.

 - Important:
 Most hives have a drone for every 10 workers. They don't do much for the hive so do not add too many.
 */
myHive.drones = /*#-editable-code*/2/*#-end-editable-code*/
    //#-code-completion(literal, hide, 5, 15, 35, 42, 156, 250)
/*:
 
 
 3. **Queen: The only fertile female in the hive.**
 
  ![The fertile female in the hive](Queen.png)
 
She lays around 1500 eggs every day. If she dies the workers raise a new one by feeding the larvae with royal jelly.

 - Important:
 If the hive is queenless it must be able to raise a new one. Otherwise, it will collapse.
 */
    //#-code-completion(literal, show, true, false)
myHive.queen = /*#-editable-code*/false/*#-end-editable-code*/
//#-hidden-code
let data = [
    "hiveSize": PlaygroundValue.integer(myHive.size.rawValue),
    "hiveColor": PlaygroundValue.data(try NSKeyedArchiver.archivedData(withRootObject: myHive.color, requiringSecureCoding: true)),
    "workerCount": PlaygroundValue.integer(myHive.workers),
    "droneCount": PlaygroundValue.integer(myHive.drones),
    "queenPresent": PlaygroundValue.boolean(myHive.queen),
]

sendValue(.dictionary(data))
PlaygroundPage.current.needsIndefiniteExecution = true
Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
    PlaygroundPage.current.assessmentStatus = .pass(message: "### Congratulations! \n You have setup your first hive, if some of your bees went away try adding less or continue to the next page where you'll take care of your hive. \n\n[**Next Page**](@next)")
    PlaygroundPage.current.finishExecution()
})

//#-end-hidden-code
