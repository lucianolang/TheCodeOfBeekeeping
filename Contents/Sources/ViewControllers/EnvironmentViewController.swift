//
//  EnvironmentViewController.swift
//  Book_Sources
//
//  Created by Luciano Gucciardo on 23/03/2019.
//

import UIKit
import PlaygroundSupport

public class EnvironmentViewController: BaseViewController {
    
    var honeyIndicator = QuantityBar(unit: .beeCount)
    
    public override func viewDidLoad() {
        hiveSize = 150
        super.viewDidLoad()
        cells.forEach { (position, cell) in
            cell.texture.image = UIImage(named: "Field")
            cell.texture.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            cell.background.backgroundColor = Colors.soilBrown

        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        addHive(in: Position(row: 0, column: 0))
    }
    
    func plant(seed: String) {
        
        let cell = getRandomEmptyCell()
        cell?.setUpLabels(text: seed)
        
    }
    
    override func tapped(cell: CellView) {
        let bee = BeeView(job: .worker, position: Position.center)
        bee.center = cells[Position.center]!.center
        cellsContainer.addSubview(bee)
        hives.forEach { (hive) in cellsContainer.bringSubviewToFront(hive) }
        
        var seed: String? = cell.labels.first?.text
        
        
    
        func flyBack(from position: Position) {
            let nextPosition = getNextPosition(current: position, last: Position.center)
            if nextPosition != cell.position {
                let currentCell = cells[nextPosition]!
                bee.fly(from: bee.center, to: currentCell.center, comeBack: false) {
                    
                    if let currentSeed = currentCell.labels.first?.text {
                        currentCell.scaleLabels()
                        seed = currentSeed
                        
                    } else if let seed = seed {
                        currentCell.setUpLabels(text: seed)
                    }
                    
                    flyBack(from: nextPosition)
                }
            } else {
                bee.fly(from: bee.center, to: (cells[nextPosition]?.center)!, comeBack: false) {
                        bee.mode = .still
                        bee.removeFromSuperview()
                }
            }
        }
        //
        func getNextPosition(current: Position, last: Position) -> Position {
            let rows = last.row - current.row
            let columns = last.column - current.column
            
            var row = current.row
            var column = current.column
            
            func addRow() {
                if rows > 0 { row += 1}
                else if rows < 0 { row -= 1}
            }
            
            func addColumn() {
                if columns > 0 { column += 1}
                else if columns < 0 {column -= 1 }
            }
            
            
            if columns != 0 && rows != 0 {
                arc4random_uniform(2) == 1 ? addRow() : addColumn()
            } else {
                addRow()
                addColumn()
            }
            
            return Position(row: row, column: column)
        }
        
        bee.fly(from: bee.center, to: cell.center, comeBack: false) {
            if seed != nil {
                cell.scaleLabels()
            }
            flyBack(from: cell.position)
        }
        
        //        var cellsInPath: [CellView] = []
        //        var lowerBound =  1
        //        var upperBound = cell.position.row + cell.position.column
        //        if lowerBound > upperBound {
        //            lowerBound = upperBound
        //            upperBound = -1
        //        }
        //        print(lowerBound,upperBound)
        //        for i in (lowerBound)...(upperBound) {
        //            cellsInPath.append(cells[Position(row: i, column: i - 1)]!)
        //            cellsInPath.append(cells[Position(row: i - 1, column: i)]!)
        //        }
        //        cellsInPath.append(cells[cell.position]!)
        //        cellsInPath.forEach { (cell) in
        //            cell.labels?.forEach({ (label) in
        //                label
        //            })
        //        }
        
    }
    
    override public func receive(_ message: PlaygroundValue) {
        switch message {
        case .string(let string):
            plant(seed: string)
        default:
            break
        }
    }
}
