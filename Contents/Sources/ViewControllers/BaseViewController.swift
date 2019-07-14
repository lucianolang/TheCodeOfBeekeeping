//
//  ViewController.swift
//  BeeHiUIKit
//
//  Created by Luciano Gucciardo on 16/03/2019.
//  Copyright © 2019 Luciano Gucciardo. All rights reserved.
//

import UIKit

public class BaseViewController: LiveViewController, CellViewDelegate {
    
    var cells: [Position: CellView] = [:]
    var bees: [Position: BeeView] = [:]
    var cellsContainer = UIView()
    var centerRendered = CGPoint()
    var hives: [HiveView] = []
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        screenSize = view.frame.size
        view.backgroundColor = UIColor(UInt(0xEADCCC))
        cellsContainer.frame = CGRect(origin: .zero, size: view.frame.size)
        cellsContainer.center = view.center
        cellsContainer.autoresizesSubviews = true
        view.addSubview(cellsContainer)
        createCells()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateCells()
    }
    
    func removeBees(completion: (() -> Void)? = nil) {
        var hasCompleted = false
        if bees.isEmpty {
            completion?()
        } else {
            for (position,bee) in bees {
                bee.flyAway(comeBack: false) {
                    if !hasCompleted {
                        hasCompleted = true
                        completion?()
                    }
                    self.bees.removeValue(forKey: position)
                }
            }
        }
    }
    
    @objc func removeCells(completion: (() -> Void)? = nil) {
        
        for (position,cell) in self.cells {
            UIView.animate(withDuration: 0.5, delay: 0.1 * Double(abs(position.column)+abs(position.row)), options: .curveEaseInOut, animations: {
                cell.layer.transform = CATransform3DMakeRotation(.pi/2, 0.0, 1.0, 0.0)
            }, completion: { _ in
                self.cells.removeValue(forKey: position)
                if position.row == rows/2 && position.column == columns/2 {
                    //                        cell.superview?.subviews.forEach {$0.removeFromSuperview()}
                    completion?()
                }
            })
        }
    }
    
    
    func createCells(margin: CGFloat? = nil) {
        cellsContainer.center = view.center
        centerRendered = CGPoint(x: view.center.x - cellsContainer.frame.minX,
                                 y: view.center.y - cellsContainer.frame.minY)
        let cellSize = Utilities.cellSize
        let margin = margin ?? Utilities.margin
        for j in -rows/2...rows/2 {
            for i in -columns/2...columns/2 {
                let centerY = centerRendered.y + cellSize.height*0.75 * CGFloat(j) + margin * CGFloat(j)
                var centerX = centerRendered.x + cellSize.width * CGFloat(i) + margin * CGFloat(i)
                
                if j % 2 != 0 {
                    centerX += cellSize.width/2 + margin/2
                }
                
                let cell = CellView(honey: Honey(), frame: CGRect(origin: .zero, size: cellSize), position: Position(row: j,column: i))
                cell.center = CGPoint(x: centerX, y: centerY)
                cells[Position(row: j,column: i)] = cell
                cell.delegate = self
                cellsContainer.addSubview(cell)
                cell.layer.transform = CATransform3DMakeRotation(.pi/2, 0.0, 1.0, 0.0)
                
            }
        }
//        cells[Position(row: 0, column: 0)]?.backgroundColor = .red
    }
    
    func animateCells(completion: (() -> Void)? = nil) {
        
        cells.forEach { (pos, cell) in
            var column = pos.column
            let row = pos.row
            
            if row % 2 != 0 && column < 0 {
                column = column + 1
            }
            
            UIView.animate(withDuration: 0.5, delay: 0.2 * Double(abs(column)+abs(row)), options: .curveEaseInOut, animations: {
                
                cell.layer.transform = CATransform3DIdentity
                
            }, completion: { _ in
                if cell.position == Position(row: rows/2-1,column: columns/2-1) {
                    completion?()
                }
            })
        }
    }
    
    func tapped(cell: CellView) {
        if !bees.isEmpty {
            if let bee = bees[cell.position] {
                if bee.layer.animationKeys()?.isEmpty ?? true {
                    bee.flyAway(comeBack: true)
                }
            }
        }
    }
    var screenSize: CGSize!
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cellsContainer.center = self.view.center
        updateVisibleCells()
    }
    
    func updateVisibleCells() {
        return cells.forEach { (position, cell) in
            let point = CGPoint(x: cell.center.x + cellsContainer.frame.minX,
                                y: cell.center.y + cellsContainer.frame.minY)
            cell.isVisible = view.frame.contains(point)
        }
    }
    
    var visibleCells: [CellView] {
        updateVisibleCells()
        return cells.values.filter { (cell) -> Bool in
            return cell.isVisible
        }
    }
    
    func getRandomEmptyCells(count: Int) -> [CellView] {
        var numberOfCells = count
        let array = visibleCells.filter { (cell) -> Bool in
            return (bees[cell.position] == nil)
        }
        if !(array.isEmpty) {
            if numberOfCells > array.count - 1 { numberOfCells = array.count - 1 }
            return Array(array[0...numberOfCells])
        } else {
            return []
        }
        
    }
    
    func getRandomEmptyCell() -> CellView? {
        let array = visibleCells.filter { (cell) -> Bool in
            return (bees[cell.position] == nil) && cell.labels.isEmpty
        }
        if array.isEmpty {
            return nil
        } else {
            return array[Int(arc4random_uniform(UInt32(array.count)))]
        }
    }
    
    func getRandomBee() -> BeeView {
        let array = Array(bees.values)
        let index = Int(arc4random_uniform(UInt32(bees.count)))
        
        if array.indices.contains(index) {
            return array[index]
        } else {
            return BeeView(job: .worker, position: Position(row: 0, column: 0))
        }
    }
    
    func getCenterPoint(for position: Position) -> CGPoint {
        return cells[position]?.center ?? self.view.center
    }
    
    func addBees(ofType: BeeView.Job, count: Int, completion: (() -> Void)? = nil) {
        var i = 0
        for cell in getRandomEmptyCells(count: count) {
            if cell.position != Position(row: 0, column: 0) {
                let bee = BeeView(job: ofType, position: cell.position)
                cellsContainer.addSubview(bee)
                bee.flyIn(to: cell.center) {
                    completion?()
                }
                bees[cell.position] = bee
            }
            i += 1
        }
    }
    
    func addBeesToAllCells(ofType: BeeView.Job) {
        for cell in visibleCells {
            let bee = BeeView(job: ofType, position: cell.position)
            cellsContainer.addSubview(bee)
            bee.flyIn(to: cell.center)
            bees[cell.position] = bee
        }
    }
    
    func addQueen() {
        let queen = BeeView(job: .queen, position: Position(row: 0, column: 0))
        cellsContainer.addSubview(queen)
        queen.flyIn(to: getCenterPoint(for: Position(row: 0, column: 0)))
        queen.position = Position(row: 0, column: 0)
        bees[Position(row: 0, column: 0)] = queen
    }
    
    func addHive(in position: Position) {
        //        let center = self.cells[position]?.center
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.cells[position]?.alpha = 0
            self.cells[position]?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { _ in
            self.cells[position]?.texture.image = nil
            self.cells[position]?.background.backgroundColor = self.cells[position]?.honey.color
            let hive = HiveView(with: self.getCenterPoint(for: position))
            self.cellsContainer.addSubview(hive)
            self.hives.append(hive)
        }
    }
}
