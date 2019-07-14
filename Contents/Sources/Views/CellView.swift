//
//  Cell.swift
//  BeeHi
//
//  Created by Luciano Gucciardo on 16/03/2019.
//  Copyright © 2019 Luciano Gucciardo. All rights reserved.
//

import Foundation
import UIKit


protocol CellViewDelegate {
    func tapped(cell: CellView)
}

class CellView: UIImageView {
    
    var position: Position
    var honey: Honey
    var tapGesture: UITapGestureRecognizer!
    var delegate: CellViewDelegate?
    var texture = UIImageView()
    var background = UIImageView()
    var labels: [UILabel] = []
    var isVisible: Bool = false {
        didSet {
            if !isVisible {
                UIView.animate(withDuration: 0.8) {
                    self.alpha = 0.5
                }
            } else {
                UIView.animate(withDuration: 0.8) {
                    self.alpha = 1
                }
            }
        }
    }
    
    
    init(honey: Honey, frame: CGRect, position: Position) {
        self.honey = honey
        self.position = position
        super.init(frame: frame)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        clipsToBounds = false
        
     
        background.frame = self.frame
        background.center = self.center
        addSubview(background)
        texture = UIImageView(image: UIImage(named: "CellTexture"))
        texture.frame = self.frame
        texture.contentMode = .scaleAspectFill
        texture.center = self.center
        texture.clipsToBounds = true
        
        layer.masksToBounds = false
        clipsToBounds = false
        
        background.backgroundColor = honey.color
        setupHexagonImageView()
        self.addSubview(texture)

       
    }
    
    @objc func tapped() {
        delegate?.tapped(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var scaleLabel: Double = 1
    func scaleLabels() {
        self.scaleLabel = min(2, self.scaleLabel + 0.25)
        self.labels.forEach({ (label) in
            UIView.animate(withDuration: 1, animations: {
               
                label.transform = CGAffineTransform(scaleX: CGFloat(self.scaleLabel), y: CGFloat(self.scaleLabel))
            })
        })
    }

    func setUpLabels(text: String) {
        labels.forEach{ $0.removeFromSuperview() }
        labels.removeAll()
        for c in -1...1 {
            for r in -1...1 {
                if (r,c) == (-1,1) || (r,c) == (1,1) {
                    continue
                }
                let size = Utilities.cellSize.width/3
                let center = CGPoint(x: Utilities.cellSize.width/2, y: Utilities.cellSize.height/2)
                var centerX = center.x + size*CGFloat(c)
                let centerY = center.y + size*CGFloat(r)
                
                if r != 0 {
                    centerX += size/2
                }
                
                let label = UILabel(frame: CGRect(origin: self.center,
                                                  size: CGSize(width: size, height: size)))
                label.transform = .identity
                label.text = text
                label.sizeToFit()
                label.center = CGPoint(x: centerX, y: centerY)
                labels.append(label)
                self.addSubview(label)
                self.bringSubviewToFront(label)

            }
        }
        
        
        
        
    }
    
    internal func setupHexagonImageView() {
        let path = UIBezierPath(hexagonIn: self.frame, cornerRadius: Utilities.cellSize.width/7)
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.strokeColor = UIColor.clear.cgColor
        background.layer.mask = mask
    }
    
}



extension UIBezierPath {
    
    convenience init(hexagonIn rect: CGRect,
                     cornerRadius: CGFloat,
                     rotationOffset: CGFloat = .pi/2)
    {
        self.init()
        let size = rect.size
        let sides = 6
        
        let theta: CGFloat = CGFloat(2.0 * .pi) / CGFloat(sides) // How much to turn at every corner
        let width = max(size.width, size.height)        // Width of the square
        
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        
        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width) / 2.0
        
        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)
        
        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        self.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta),y: corner.y + cornerRadius * sin(angle + theta)))
        
        for _ in 0 ..< sides {
            angle += theta
            
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle),
                                 y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle),
                              y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta),
                                y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta),
                              y: corner.y + cornerRadius * sin(angle + theta))
            
            self.addLine(to: start)
            self.addQuadCurve(to: end, controlPoint: tip)
        }
        
        self.close()
        
        // Move the path to the correct origins
        
        let transform =  CGAffineTransform( translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0,
                                            y: -bounds.origin.y + rect.origin.y / 2.0 + (cornerRadius - (cos(theta) * cornerRadius))/2)
        self.apply(transform)
        
        
    }
}
