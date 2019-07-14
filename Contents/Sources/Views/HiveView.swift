//
//  Hive.swift
//  BeeHiUIKit
//
//  Created by Luciano Gucciardo on 17/03/2019.
//  Copyright © 2019 Luciano Gucciardo. All rights reserved.
//

import UIKit
public typealias Completion = () -> Void

class HiveView: UIImageView {
    
    

    var honey: Honey?
    var cover: Cover?
    var isCovered = false {
        didSet {
            if isCovered {
                cover = Cover(with: self.center)
                self.superview?.addSubview(cover!)
            } else {
                cover?.animateDisappear() {
                    self.cover = nil
                }
            }
        }
    }
    
    init(with center: CGPoint) {
        super.init(frame: CGRect(origin: .zero, size: Utilities.cellSize))
        self.center = CGPoint(x: center.x, y: center.y)
        image = UIImage(named: "Hive")
        contentMode = .scaleAspectFill
        alpha = 0
        transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        annimateAppeareance()
    }
    
    func annimateAppeareance() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            self.alpha = 1
            
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Cover: UIImageView {
    
    init(with center: CGPoint) {
        super.init(frame: CGRect(origin: .zero, size: Utilities.cellSize))
        self.center = CGPoint(x: center.x, y: center.y - 100)
        image = UIImage(named: "Cover")
        contentMode = .scaleAspectFill
        alpha = 0
        transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        annimateAppeareance()
    }
    
    func annimateAppeareance() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.center.y += 95
            self.alpha = 1
            
        }, completion: nil)
    }
    
    func animateDisappear(completion: Completion?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.center.y -= 100
            self.alpha = 0
        }, completion: {_ in
            self.removeFromSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
