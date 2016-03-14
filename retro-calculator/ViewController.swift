//
//  ViewController.swift
//  retro-calculator
//
//  Created by Phillip Paik on 3/13/16.
//  Copyright © 2016 Phillip Paik. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Plus = "+"
        case Subtract = "-"
        case Divide = "/"
        case Multiple = "*"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLabel: UILabel!
    
    var buttonSound: AVAudioPlayer!
    
    
    var runningNumber: String = "";
    var leftValString: String = "";
    var rightValString: String = "";
    var currentOperation: Operation = Operation.Empty
    var result = "";
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        
        let soundURL = NSURL(fileURLWithPath: path!)
        
        
        do {
           try buttonSound = AVAudioPlayer(contentsOfURL: soundURL)
            buttonSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numberPressed(btn: UIButton!){
        playSound()
        
        runningNumber += "\(btn.tag)"
        outputLabel.text = runningNumber
    }

    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            // Run some math
            
            if runningNumber != "" {
                rightValString = runningNumber
                runningNumber = ""
                
                switch currentOperation{
                case .Multiple: result = "\(Double(leftValString)! * Double(rightValString)!)"
                case .Divide : result = "\(Double(leftValString)! / Double(rightValString)!)"
                case .Plus : result = "\(Double(leftValString)! + Double(rightValString)!)"
                case .Subtract : result = "\(Double(leftValString)! - Double(rightValString)!)"
                default: result = ""
                }
                
                leftValString = result
                outputLabel.text = result
            }

            
            currentOperation = op
            
        } else {
            // First Time operator is pressed
            leftValString = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    func playSound(){
        if buttonSound.playing {
            buttonSound.stop()
        }
        
        buttonSound.play()
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(.Divide)
        
    }
    
    @IBAction func onMultiPressed(sender: AnyObject) {
        processOperation(.Multiple)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(.Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(.Plus)
    }
    
    @IBAction func onEqualsPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    @IBAction func onClearPressed(sender: AnyObject) {
        playSound()
        runningNumber = "";
        leftValString = "";
        rightValString = "";
        currentOperation = Operation.Empty
        result = "";
        outputLabel.text = "0"
    }
    
}

