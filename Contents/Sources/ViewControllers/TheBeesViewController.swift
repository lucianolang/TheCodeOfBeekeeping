//
//  WorkariablesViewController.swift
//  Book_Sources
//
//  Created by Luciano Gucciardo on 20/03/2019.
//

import UIKit
import PlaygroundSupport

public class TheBeesViewController: BaseViewController  {
    
    var cellColor: UIColor?
    var workerCount = 0
    var droneCount = 0
    var queenPresent = false
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        cells.forEach { (position, cell) in
            cell.background.addSubview(cell.texture)
            
        }
    }
    
    func updateHiveSize(size: Int, completion:  (()-> Void)? = nil) {
        if hiveSize != size {
            removeBees() {
                self.removeCells() {
                    hiveSize = size
                    self.createCells()
                    self.updateCellsColor(to: self.cellColor, animated: false)
                    self.animateCells() {
                        completion?()
                    }
                }
            }
        } else {
            updateCellsColor(to: cellColor)
            completion?()
        }
    }
    
    func updateBeeCount(workers: Int, drones: Int, queen: Bool , completion: (() -> Void)? = nil) {
        removeBees() {
            var totalCount = workers + drones + (queen ? 1 : 0)
            for i in 0...3 {
                var beeToAdd: BeeView.Job
                var beeCount: Int
                switch i {
                case 0:
                    beeToAdd = .worker
                    beeCount = workers
                case 1:
                    beeToAdd = .drone
                    beeCount = drones
                case 2:
                    beeToAdd = .queen
                    beeCount = 1
                default:
                    beeToAdd = .worker
                    beeCount = 0
                }
                if beeCount <= self.visibleCells.count  {
                    if beeToAdd == .queen && queen {
                        self.addQueen()
                    } else {
                        self.addBees(ofType: beeToAdd, count: beeCount)
                        totalCount -= beeCount
                    }
                } else {
                    //Add bees to all cells and then fly away half .swarm
                    self.addBees(ofType: .worker, count: self.getRandomEmptyCells(count: self.cells.count).count) {
                        for bee in Array(self.bees.values)[0...(self.bees.count/2)] {
                            bee.flyAway(comeBack: false)
                        }
                    }
                }
            }
        }
    }
    
    func updateCellsColor(to color: UIColor?, animated: Bool = true) {
        for (position, cell) in cells {
            cell.background.addSubview(cell.texture)

            var column = position.column
            
            if position.column % 2 != 0 && position.row < 0{
                column = column + 1
            }
            if animated {
                UIView.animate(withDuration: 0.1, delay: 0.2 * Double(abs(column)+abs(position.row)), options: .curveEaseInOut, animations: {
                    cell.background.backgroundColor = color ?? cell.honey.color
                }) { (_) in
                }
            } else {
                cell.background.backgroundColor = color ?? cell.honey.color
            }
        }
    }
    
    override public func receive(_ message: PlaygroundValue) {
        // Change the appearance of the view when a message is received.
        switch message {
            
        case .dictionary(let dict):
            guard case .integer(let size)? = dict["hiveSize"] else { return }
            guard case .integer(let worker)? = dict["workerCount"] else { return }
            self.workerCount = worker
            guard case .integer(let drone)? = dict["droneCount"] else { return }
            self.droneCount = drone
            guard case .boolean(let queen)? = dict["queenPresent"] else { return }
            self.queenPresent = queen
            guard case .data(let messageData)? = dict["hiveColor"] else { return }
            
            do {
                if let color = try  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(messageData) as? UIColor{
                    cellColor = color
                    
                }
            } catch {}
            updateHiveSize(size: size) {
                self.updateBeeCount(workers: self.workerCount, drones: self.droneCount, queen: self.queenPresent, completion: {
                    return
                })
            }
        default:
            break
        }
    }
}
