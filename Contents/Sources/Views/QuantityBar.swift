//
//  QuantityBar.swift
//  Book_Sources
//
//  Created by Luciano Gucciardo on 22/03/2019.
//

import UIKit

class QuantityBar: UIView {
    
    var quantityView = UIView()
    var icon = UIImageView()
    var type: MeasureUnit
    var value: Double = 0 {
        didSet {
            layoutSubviews()
        }
    }
    var isStarting = true
    
    
    init(unit: MeasureUnit) {
        type = unit
        super.init(frame: CGRect(origin: .zero, size: .zero))
        self.icon.image = type.image
        self.quantityView.backgroundColor = type.color
        value = 0.5
        backgroundColor = Colors.gray10
        self.addSubview(quantityView)
        self.addSubview(icon)
        icon.alpha = 0.8
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width/2
        quantityView.frame.size.width = frame.width
        quantityView.frame.origin.y = frame.height - quantityView.frame.size.height
        if isStarting { self.quantityView.frame.origin.y = self.frame.height }
        UIView.animate(withDuration: 0.5, delay: isStarting ? 1 : 0, options: [], animations: {
            self.quantityView.frame.size.height = self.frame.height*CGFloat(self.value)
            self.quantityView.frame.origin.y = self.frame.height - self.quantityView.frame.size.height
            
            if self.type == .celcius {
                if self.value < 0.3 {
                    self.quantityView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.6)
                } else {
                    self.quantityView.backgroundColor = self.type.color
                }
                
            }
            
        }) { _ in
            self.isStarting = false
        }
        
        let iconSize = self.frame.width*0.8
        icon.frame = CGRect(x: iconSize*0.1,
                            y: self.frame.height - iconSize*1.3,
                            width: iconSize,
                            height: iconSize)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



enum MeasureUnit {
    case honey
    case celcius
    case beeCount
    var color: UIColor? {
        switch self {
        case .honey:
            return UIColor(0xFFDD7D)
        case .celcius:
            return UIColor(0xFF967D)
        case .beeCount:
            return UIColor(0xFF967D)
        }
    }
    var image: UIImage? {
        switch self {
        case .honey:
            return UIImage(named: "Honey")
        case .celcius:
            return UIImage(named: "Temperature")
        case .beeCount:
            return UIImage(named: "BeeNumber")
        }
    }
}
