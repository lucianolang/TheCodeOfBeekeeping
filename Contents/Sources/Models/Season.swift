//
//  Season.swift
//  Book_Sources
//
//  Created by Luciano Gucciardo on 23/03/2019.
//

import Foundation

public enum Season: Int {
    
    case spring = 0
    case summer = 1
    case fall = 2
    case winter = 3
    
    var temp: Double {
        switch self {
        case .spring:
            return 0.45
        case .summer:
            return 0.7
        case .fall:
            return 0.4
        case .winter:
            return 0.2
        }
    }
    
    var honeyLevel: Double {
        switch self {
        case .spring:
            return 0.6
        case .summer:
            return 0.3
        case .fall:
            return 0.3
        case .winter:
            return 0.4
        }
    }
    
}
