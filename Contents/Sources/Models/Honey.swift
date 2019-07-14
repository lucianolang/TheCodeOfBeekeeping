//
//  Model.swift
//  BeeHi
//
//  Created by Luciano Gucciardo on 16/03/2019.
//  Copyright © 2019 Luciano Gucciardo. All rights reserved.
//

import Foundation
import UIKit

class Honey {
    
    var color: UIColor {
        var c = UIColor.clear
        if tastes.count == 0 {
            c = UIColor(0xF8C71C)
        }
        for taste in tastes {
            c = addColor(c, with: multiplyColor(taste.color, by: CGFloat(1/tastes.count)))
        }
        return c
        
    }
    
    var tastes: Array<Taste> = []
    
    enum Taste {
        case citrus
        case floral
        case herby
        case woody
        case earthy
        case caramel
        case spicy
        
        var color: UIColor {
            var color: UInt
            switch self {
            case .citrus: color = 0xE1DA7D
            case .floral: color = 0xD0C067
            case .herby: color = 0xCDB152
            case .woody: color = 0xC3903D
            case .earthy: color = 0xAD6A32
            case .caramel: color = 0x813920
            case .spicy: color = 0x652C15
            }
            return UIColor(color)
        }
//        var imageName: String {
//            
//        }
    }
}

extension Honey {
    func addColor(_ color1: UIColor, with color2: UIColor) -> UIColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // add the components, but don't let them go above 1.0
        return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
    }
    
    func multiplyColor(_ color: UIColor, by multiplier: CGFloat) -> UIColor {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
    }
}

extension UIColor {
    public convenience init(_ hex: UInt, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

func getRandom() -> UIColor {
    let colors: [UInt] = [0xB46520,0xD2B13C,0xCB8F25,0xF8C71C,0xB46520,0x6D280C]
    return UIColor(colors.randomElement()!)
}




