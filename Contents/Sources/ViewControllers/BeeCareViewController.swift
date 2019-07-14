//
//  BeeCareViewController.swift
//  Book_Sources
//
//  Created by Luciano Gucciardo on 20/03/2019.
//

import UIKit
import PlaygroundSupport

public class BeeCareViewController: BaseViewController  {
    
    var temperatureIndicator = QuantityBar(unit: .celcius)
    var honeyIndicator = QuantityBar(unit: .honey)
    var seasonTimer: Timer? = nil
    var seasonCount = 8
    
    public override func viewDidLoad() {
        hiveSize = 150
        super.viewDidLoad()
        view.backgroundColor = Colors.lightBrown
        cells.forEach { (arg) in
            let (_, cell) = arg
            cell.background.backgroundColor = Colors.soilBrown
            cell.texture.image = UIImage(named: "Field")
            cell.texture.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            view.addSubview(temperatureIndicator)
            view.addSubview(honeyIndicator)
            updateFrames()
            
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.temperatureIndicator.frame.origin.x =  self.view.frame.width + self.temperatureIndicator.frame.width
        self.honeyIndicator.frame.origin.x =  self.view.frame.width +  self.temperatureIndicator.frame.width
        self.updateFrames()
        addHive(in: Position.center)
//        self.startTimer()
    }
    
    var responses = [true, true, true]
    @objc func updateSeason() {
        
        let currentSeason = seasons[((seasonCount + 1) % seasons.count) ]
        
        if responses[0] {
            honeyIndicator.value = currentSeason.honeyLevel
        } else {
            honeyIndicator.value = 1
        }
        temperatureIndicator.value = currentSeason.temp
        if responses[1] {
            if currentSeason == .winter {
                hives.forEach { (hive) in
                    hive.isCovered = true
                }
            } else {
                hives.forEach { (hive) in
                    hive.isCovered = false
                }
            }
        } else {
            hives.forEach { (hive) in
                hive.isCovered = false
            }
        }
        
        if responses[2] {
            
        }
        
        seasonCount += 1
    }
    
    func startTimer() {
        seasonTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.updateSeason()
        })
    }
    
    func stopTimer() {
        if let timer = seasonTimer {
            if timer.isValid {
                timer.invalidate()
                seasonTimer = nil
            }
        }
    }
    
    override func tapped(cell: CellView) {
        addHive(in: cell.position)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFrames()
    }
    
    func updateFrames() {
        
        let width = Utilities.screenSize.width*0.04
        let height = view.frame.height/2 - indicatorMargin*4
        let xOrigin = view.frame.width - width - indicatorMargin
        let yOrigin = indicatorMargin + 64
        
        self.temperatureIndicator.frame = CGRect(x: xOrigin,
                                                 y: yOrigin,
                                                 width: width,
                                                 height: height)
        
        self.honeyIndicator.frame = CGRect(x: xOrigin,
                                           y: yOrigin + height + indicatorMargin,
                                           width: width,
                                           height: height)
        
    }
    
    override public func receive(_ message: PlaygroundValue) {
        // Change the appearance of the view when a message is received.
        switch message {
        case .dictionary(let dict):
            guard case .boolean(let harvested)? = dict["harvested"] else { return }
            guard case .boolean(let covered)? = dict["covered"] else { return }
            guard case .boolean(let routined)? = dict["routines"] else { return }
            responses = [harvested, covered, routined]
        case .integer(let contentSeason):
            seasonCount = contentSeason + 4
            updateSeason()
        case .string(let stringMessage):
            switch stringMessage {
            case "finishedRunning":
                if seasonTimer != nil {
                    seasonTimer?.invalidate()
                    seasonTimer = nil
                } else {
                    startTimer()
                }
            case "coverHive":
                hives.forEach { (hive) in
                    hive.isCovered = true
                }
            //FIXME: do something in the view
            case "harvestHoney": break
            default:
                break
            }
        default:
            break
        }
    }
    
}



//
//let data = [
//    "season": PlaygroundValue.string(week.rawValue),
//    "harvested": PlaygroundValue.boolean(responses[0]),
//    "covered": PlaygroundValue.boolean(responses[1]),
//    "routines": PlaygroundValue.boolean(responses[2]),
//]
//
//sendValue(.dictionary(data))
