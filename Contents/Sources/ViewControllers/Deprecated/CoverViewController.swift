//
//  ViewController.swift
//  BeeHiUIKit
//
//  Created by Luciano Gucciardo on 16/03/2019.
//  Copyright © 2019 Luciano Gucciardo. All rights reserved.
//

import UIKit

class CoverViewController: UIViewController {
    
    var cells: [Position: CellView]!
    var margin: CGFloat = 4
    var rows = 9
    var columns = 15
    var height = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(UInt(0x4C150F))
        height = Double(Utilities.screenSize.height / CGFloat(Double(rows)*0.75))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateCells()
    }
    
    func animateCells() {
        let cellSize = CGSize(width: height * sqrt(3.0/4.0), height: height)
        let center = self.view.center
        
        for j in -rows/2...rows/2 {
            for i in -columns/2...columns/2 {
                let centerY = center.y + cellSize.height*0.75 * CGFloat(j) + margin * CGFloat(j)
                var centerX = center.x + cellSize.width * CGFloat(i) + margin * CGFloat(i)
                
                if j % 2 != 0 {
                    centerX += cellSize.width/2 + margin/2
                }
                
                let cell = CellView(honey: Honey(), frame: CGRect(origin: .zero, size: cellSize), position: Position(row: i,column: j))
                cell.tintColor = getRandom()
                cell.center = CGPoint(x: centerX, y: centerY)
                self.view.addSubview(cell)
                
                cell.layer.transform = CATransform3DMakeRotation(.pi/2, 0.0, 1.0, 0.0)
                
                var column = i
                let row = j
                
                if j % 2 != 0 && i < 0{
                    column = column + 1
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.2 * Double(abs(column)+abs(row)), options: .curveEaseInOut, animations: {
                    
                    cell.layer.transform = CATransform3DIdentity
                    
                
                }, completion: nil)
                
            }
        }
    }
    
    func getRandom() -> UIColor {
        let colors: [UInt] = [0xB46520,0xD2B13C,0xCB8F25,0xF8C71C,0xB46520,0x6D280C]
        return UIColor(colors.randomElement()!)
    }

}

