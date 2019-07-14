//
//  HiveViewController.swift
//  BeeHiUIKit
//
//  Created by Luciano Gucciardo on 17/03/2019.
//  Copyright © 2019 Luciano Gucciardo. All rights reserved.
//

import UIKit

public class HiveViewController: BaseViewController {
    

    override public func viewDidAppear(_ animated: Bool) {
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
            self.addWorkers()
        }
        Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { (Timer) in
            self.addQueen()
        }
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (Timer) in
            self.addDrones()
            }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (Timer) in
            let bee = self.getRandomBee()
            if bee.mode == .still {
                bee.mode = .moving
            }
        }
    }
    
    
    func addDrones() {
        for (position, cell) in cells {
            if bees[position] == nil {
                let bee = BeeView(job: .drone, position: position)
                view.addSubview(bee)
                bee.flyIn(to: cell.center)
                bees[position] = bee
            }
        }
    }
    
    
    
    func addWorkers() {
//        for cell in getRandomCells() {
//            if cell.position != Position(row: 0, column: 0) {
//                let bee = BeeView(job: .worker, position: cell.position)
//                view.addSubview(bee)
//                bee.fly(to: cell.center)
//                bees[cell.position] = bee
//            }
//        }
    }
    
    
    
}


