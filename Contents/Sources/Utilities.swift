//
//  Utilities.swift
//  BeeHiUIKit
//
//  Created by Luciano Gucciardo on 16/03/2019.
//  Copyright © 2019 Luciano Gucciardo. All rights reserved.
//

import UIKit

public var hiveSize = 250
public var rows: Int {return Int(sqrt(Double(hiveSize))) }
public var columns: Int {return Int(sqrt(Double(hiveSize)))}
public var workerRatio = 0.75
public let indicatorMargin: CGFloat = 30
public let seasons: [Season] = [.spring, .summer, .fall, .winter]

class Utilities {
    
    static var screenSize: CGSize {return UIScreen.main.bounds.size}
    static let beeSpeed = 0.5
    static var margin: CGFloat {return Utilities.cellHeight/20}
    static var cellHeight: CGFloat {return Utilities.maxScreenSize.height / CGFloat(Double(rows)*0.75)}
    static var cellSize: CGSize {return CGSize(width: cellHeight * sqrt(3.0/4.0), height: cellHeight)}
    static var maxScreenSize = CGSize(width: 1366, height: 1366)
    static var hiveHeight: CGFloat {return (cellHeight+margin)*CGFloat(rows)}
    static var hiveWidth: CGFloat {return (cellSize.width+margin)*CGFloat(columns)}

}

class Colors {
    static var lightBrown = UIColor(0xF2DC87)
    static var soilBrown = UIColor(0x6D280C)
    static var gray10 = UIColor(0xE8E8E8)

}

