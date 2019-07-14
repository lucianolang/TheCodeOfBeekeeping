//
//  Position.swift
//  BeeHiUIKit
//
//  Created by Luciano Gucciardo on 17/03/2019.
//  Copyright © 2019 Luciano Gucciardo. All rights reserved.
//

import Foundation
import UIKit

class Position: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
    var row: Int
    var column: Int
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    static var center: Position {
        return Position(row: 0, column: 0)
    }
    
}
