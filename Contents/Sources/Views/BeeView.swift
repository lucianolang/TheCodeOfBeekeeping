//
//  Bee.swift
//  BeeHi
//
//  Created by Luciano Gucciardo on 16/03/2019.
//  Copyright © 2019 Luciano Gucciardo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class BeeView: UIImageView {
    
    var timer = Timer()
    var isTimerRunning = false
    
    var audioPlayer:AVAudioPlayer!
    var job: Job
    var honey: Honey
    var position: Position?
    var bodyImage = UIImageView()
    var wingsOpen = false
    
    var mode: Mode {
        didSet {
            switch mode {
            case .flying:
                animateFlying()
                instantiateAudioPlayer()
            case .moving:
                animateMoving()
                instantiateAudioPlayer()
            case .still:
                self.bodyImage.layer.removeAllAnimations()
                self.bodyImage.transform = .identity
                if let player = self.audioPlayer {
                    player.stop()
                }
                timer.invalidate()
                bodyImage.image = job.getImage()

            }
        }
    }
    
    init(job: Job, position: Position) {
        self.job = job
        self.honey = Honey()
        self.mode = .still
        self.position = position
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: Utilities.cellSize.width * 0.8, height: Utilities.cellSize.height * 0.8)))
        bodyImage.image = job.getImage()
        bodyImage.frame = self.frame
        self.addSubview(bodyImage)
        //        self.addSubview(rightHindwing)
        //        self.addSubview(leftHindwing)
        //        self.addSubview(rightForewing)
        //        self.addSubview(leftHindwing)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,   selector: (#selector(changeImage)), userInfo: nil, repeats: true)
    }
    
    @objc func changeImage() {
        if !wingsOpen {
            self.bodyImage.image = self.job.getFlyingImage()
            wingsOpen = true
        } else {
            self.bodyImage.image = self.job.getImage()
            wingsOpen = false
        }
    }
    
    func animateMoving() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.bodyImage.transform = CGAffineTransform(rotationAngle: .pi/30)
        }, completion: nil)
    }
    
    func animateFlying() {
        runTimer()
//        UIView.animate(withDuration: 0.01, delay: 0, options: [.autoreverse, .repeat], animations: {
//            self.bodyImage.transform = CGAffineTransform(rotationAngle: .pi/30)
//        }, completion: nil)
        
    }
    
    func flyAway(comeBack: Bool = true, completion: (()->Void)? = nil) {
        self.mode = .flying
        
        
        self.superview?.bringSubviewToFront(self)
        let initialPoint = center
        
        let point = CGPoint(x: CGFloat(arc4random_uniform(UInt32(Utilities.screenSize.width))), y: -frame.height*4)
        
        let xRelative = point.x - center.x
        let yRelative = point.y - center.y
        var rotation = atan2(yRelative, xRelative) + .pi/2
        rotation = max(-.pi/4, min(rotation, .pi/4))
        let duration = TimeInterval(2)
        
        self.transform = .identity
        
        //FIXME: Chapuza rotation
        if comeBack {
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = CGAffineTransform(rotationAngle: rotation)
            })
        }
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseInOut,
                       animations: {
                        self.center = point
        }, completion: { (finished) in
            self.mode = .still
            if finished {
                if comeBack {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (Timer) in
                        self.flyIn(to: initialPoint) {
                            completion?()
                        }
                    })
                } else {
                    self.removeFromSuperview()
                    completion?()
                }
            }
        })
        
        
        //        UIView.animateKeyframes(withDuration: duration, delay: 0.1, animations: {
        //            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
        //                self.center = CGPoint(x: self.superview!.frame.origin.x,
        //                                     y: self.superview!.frame.origin.y)
        //            })
        //            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
        //                self.transform = CGAffineTransform(rotationAngle: rotation)
        //            })
        //
        //       }, completion: {
        //            finished in
        //            self.mode = .still
        //            if finished {
        //                if comeBack {
        //                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (Timer) in
        //                        self.fly(to: initialPoint) {
        //                            completion?()
        //                        }
        //                    })
        //                } else {
        //                    self.removeFromSuperview()
        //                    completion?()
        //                }
        //            }
        //       } )
        
    }
    
    
    
    func flyIn(to point: CGPoint, completion: (()->Void)? = nil) {
        self.mode = .flying
        var origin = CGPoint()
        let random = CGFloat(arc4random_uniform(UInt32(Utilities.screenSize.height)))
        if point.x < Utilities.screenSize.width/2 {
            origin = CGPoint(x: 0 - frame.size.width, y: random )
        } else {
            origin = CGPoint(x: Utilities.screenSize.width + frame.size.width, y: random)
        }
        
        center = origin
        
        let xRelative = point.x - origin.x
        let yRelative = point.y - origin.y
        
        let rotation = atan2(yRelative, xRelative) + .pi/2
        let duration = TimeInterval(2)
        self.transform = CGAffineTransform(rotationAngle: rotation)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                self.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.center = point
            })
        }, completion: { finished in
            if finished {
                completion?()
                self.mode = .still
            }
        })
    }
    
    func fly(from: CGPoint, to: CGPoint, comeBack: Bool ,completion: @escaping Completion) {
        self.mode = .flying
        let xRelative = to.x - from.x
        let yRelative = to.y - from.y
        
        let rotation = atan2(yRelative, xRelative) + .pi/2
        let duration = TimeInterval(2)
        
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.transform = CGAffineTransform(rotationAngle: rotation)
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.center = to
            })
        }, completion: { finished in
            if finished {
                if comeBack {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.transform = CGAffineTransform(rotationAngle: .pi/2)
                    })
                    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (Timer) in
                        self.fly(from: self.center, to: from, comeBack: false, completion: {
                            completion()
                        })
                    })
                     self.mode = .still
                } else {
//                    self.removeFromSuperview()
                    completion()
                }
//                completion()
               
                
            }
        })
    }
    
    func instantiateAudioPlayer() {
        let audioFilePath = Bundle.main.path(forResource: "beeHum", ofType: "mp3")
        
        if audioFilePath != nil {
            
            let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            
            audioPlayer = try! AVAudioPlayer(contentsOf: audioFileUrl)
            audioPlayer.play()
            
        } else {
            print("audio file is not found")
        }
    }
}

extension BeeView {
    enum Job {
        case queen
        case drone
        case worker
        
        func getImage() -> UIImage? {
            switch self {
            case .queen: return UIImage(named: "Queen")
            case .drone: return UIImage(named: "Drone")
            case .worker: return UIImage(named: "Worker")
            }
        }
        
        func getFlyingImage() -> UIImage? {
            switch self {
            case .queen: return UIImage(named:  "Queen_Flying")
            case .drone: return UIImage(named:  "Drone_Flying")
            case .worker: return UIImage(named: "Worker_Flying")
            }
        }
        
        //        func getImageSet() -> [UIImage] {
        //            switch self {
        //            case .queen: return [UIImage(named: "Queen_body")!,
        //                                 UIImage(named: "Queen_forewing")!,
        //                                 UIImage(named: "Queen_hindwing")!]
        //            case .drone: return [UIImage(named: "Drone_body")!,
        //                                 UIImage(named: "Drone_forewing")!,
        //                                 UIImage(named: "Drone_hindwing")!]
        //            case .worker: return [UIImage(named: "Worker_body")!,
        //                                  UIImage(named: "Worker_forewing")!,
        //                                  UIImage(named: "Worker_hindwing")!]
        //            }
        //        }
    }
    
    enum Mode {
        case still
        case flying
        case moving
    }
    
}

