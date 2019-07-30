//
//  ViewController.swift
//  Screens
//
//  Created by Isham Jassat on 20/06/2019.
//  Copyright © 2019 Isla. All rights reserved.
//

import UIKit
import UserNotifications
import QuartzCore

class ViewController: UIViewController {
    @IBOutlet weak var mondayTimeText: UILabel!
    @IBOutlet weak var tuesdayTimeText: UILabel!
    @IBOutlet weak var wednesdayTimeText: UILabel!
    @IBOutlet weak var thursdayTimeText: UILabel!
    @IBOutlet weak var fridayTimeText: UILabel!
    @IBOutlet weak var saturdayTimeText: UILabel!
    @IBOutlet weak var sundayTimeText: UILabel!
    @IBOutlet weak var summaryTimeText: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    
    let defaults = UserDefaults.standard
    var totalTime: Int = 0//save to memory
    var mondayTime: Int = 0
    var tuesdayTime: Int = 0
    var wednesdayTime: Int = 0
    var thursdayTime: Int = 0
    var fridayTime: Int = 0
    var saturdayTime: Int = 0
    var sundayTime: Int = 0
    var mondayTimeVal: Double = 0.0
    var tuesdayTimeVal: Double = 0.0
    var wednesdayTimeVal: Double = 0.0
    var thursdayTimeVal: Double = 0.0
    var fridayTimeVal: Double = 0.0
    var saturdayTimeVal: Double = 0.0
    var sundayTimeVal: Double = 0.0
    var timeInterval: Int = 300
    var timer = Timer()
    var minutesLapsed: Int = 0
    var initialTimeAllowed: Int = 3600 //save to memory
    var totalTimeArr = [0, 0, 0, 0, 0, 0, 0, 0, 0] //[monday, tuesday, wednesday, thursday, friday, saturday, sunday, totalTime(seconds), elapsed time]
    var backgroundNrArray = [0, 0, 0, 0, 0, 0, 0] //[monday, tuesday, wednesday, thursday, friday, saturday, sunday]
    var seconds: Int = 60
    var isTimerRunning: Bool = false //save state
    var hasUserNotificationPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load data
        if let items = defaults.array(forKey: "SavedArray") as? [Int]{
            totalTimeArr = items
        }
        
        if let backgroundItems = defaults.array(forKey: "SavedBgArray") as? [Int] {
            backgroundNrArray = backgroundItems
        }
        
        if let timerState: Bool = defaults.bool(forKey: "TimerState") {
            isTimerRunning = timerState
        }
        
        let overallTime = defaults.integer(forKey: "TotalTime")
        if overallTime != nil {
            seconds = overallTime
        }
        
        //self.defaults.set(self.isTimerRunning, forKey:  "TimerState")
        //self.defaults.set(self.seconds, forKey: "TotalTime")
        
        //update data
        updateViewWithSavedData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        runTimer()
        
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Time", message: "Are you sure you want to reset time?" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in self.reset() }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func timerButton(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            isTimerRunning = true
            timerButton.setTitle("Stop Timer", for: .normal)
        }
        else if isTimerRunning == true {
            stopCountdown()
            isTimerRunning = false
            timerButton.setTitle("Start Timer", for: .normal)
        }
        saveData()
    }
    
    
    @IBAction func addSubtractTimeButtons(_ sender: UIButton) {
        updateSummary(isPositive: false, senderTag: sender.tag)
    }
    
    //update total time on summary screen
    func updateSummary(isPositive: Bool, senderTag: Int) {
        
        if senderTag >= 1 && senderTag <= 7 {
            seconds -= timeInterval
            
            if senderTag == 1 {
                backgroundNrArray[0] = backgroundNrArray[0] - timeInterval
                mondayTime = mondayTime - (timeInterval/60)
                mondayTimeText.text = "\(mondayTime) mins"
            }
            else if senderTag == 2 {
                backgroundNrArray[1] = backgroundNrArray[1] - timeInterval
                tuesdayTime = tuesdayTime - (timeInterval/60)
                tuesdayTimeText.text = "\(tuesdayTime) mins"
            }
            else if senderTag == 3 {
                backgroundNrArray[2] = backgroundNrArray[2] - timeInterval
                wednesdayTime = wednesdayTime - (timeInterval/60)
                wednesdayTimeText.text = "\(wednesdayTime) mins"
            }
            else if senderTag == 4 {
                backgroundNrArray[3] = backgroundNrArray[3] - timeInterval
                thursdayTime = thursdayTime - (timeInterval/60)
                thursdayTimeText.text = "\(thursdayTime) mins"
            }
            else if senderTag == 5 {
                backgroundNrArray[4] = backgroundNrArray[4] - timeInterval
                fridayTime = fridayTime - (timeInterval/60)
                fridayTimeText.text = "\(fridayTime) mins"
            }
            else if senderTag == 6 {
                backgroundNrArray[5] = backgroundNrArray[5] - timeInterval
                saturdayTime = saturdayTime - (timeInterval/60)
                saturdayTimeText.text = "\(saturdayTime) mins"
            }
            else if senderTag == 7 {
                backgroundNrArray[6] = backgroundNrArray[6] - timeInterval
                sundayTime = sundayTime - (timeInterval/60)
                sundayTimeText.text = "\(sundayTime) mins"
            }
        }
        else if senderTag >= 8 && senderTag <= 14 {
            seconds += timeInterval
            
            if senderTag == 8 {
                backgroundNrArray[0] = backgroundNrArray[0] + timeInterval
                mondayTime = mondayTime + (timeInterval/60)
                mondayTimeText.text = "\(mondayTime) mins"
            }
            else if senderTag == 9 {
                backgroundNrArray[1] = backgroundNrArray[1] + timeInterval
                tuesdayTime = tuesdayTime + (timeInterval/60)
                tuesdayTimeText.text = "\(tuesdayTime) mins"
            }
            else if senderTag == 10 {
                backgroundNrArray[2] = backgroundNrArray[2] + timeInterval
                wednesdayTime = wednesdayTime + (timeInterval/60)
                wednesdayTimeText.text = "\(wednesdayTime) mins"
            }
            else if senderTag == 11 {
                backgroundNrArray[3] = backgroundNrArray[3] + timeInterval
                thursdayTime = thursdayTime + (timeInterval/60)
                thursdayTimeText.text = "\(thursdayTime) mins"
            }
            else if senderTag == 12 {
                backgroundNrArray[4] = backgroundNrArray[4] + timeInterval
                fridayTime = fridayTime + (timeInterval/60)
                fridayTimeText.text = "\(fridayTime) mins"
            }
            else if senderTag == 13 {
                backgroundNrArray[5] = backgroundNrArray[5] + timeInterval
                saturdayTime = saturdayTime + (timeInterval/60)
                saturdayTimeText.text = "\(saturdayTime) mins"
            }
            else if senderTag == 14 {
                backgroundNrArray[6] = backgroundNrArray[6] + timeInterval
                sundayTime = sundayTime + (timeInterval/60)
                sundayTimeText.text = "\(sundayTime) mins"
            }
        }
        
        totalTimeArr[0] = mondayTime
        totalTimeArr[1] = tuesdayTime
        totalTimeArr[2] = wednesdayTime
        totalTimeArr[3] = thursdayTime
        totalTimeArr[4] = fridayTime
        totalTimeArr[5] = saturdayTime
        totalTimeArr[6] = sundayTime
        totalTimeArr[7] = seconds
        
        summaryTimeText.text = timeString(time: TimeInterval(seconds))
        //save data
        saveData()
 
    }
    
    func saveData() {
        self.defaults.set(self.totalTimeArr, forKey: "SavedArray")
        self.defaults.set(self.backgroundNrArray, forKey: "SavedBgArray")
        self.defaults.set(self.isTimerRunning, forKey:  "TimerState") //save timer state
        self.defaults.set(self.seconds, forKey: "TotalTime") //save total seconds
        self.defaults.set(self.hasUserNotificationPermission, forKey: "HasPermission") //save user permission default
    }
    
    //reset all time to zero
    func reset() {
        mondayTime = 0
        tuesdayTime = 0
        wednesdayTime = 0
        thursdayTime = 0
        fridayTime = 0
        saturdayTime = 0
        sundayTime = 0
        seconds = initialTimeAllowed
        totalTimeArr[7] = seconds
        minutesLapsed = 0

        
        //update background values
        backgroundNrArray[0] = initialTimeAllowed
        backgroundNrArray[1] = 0
        backgroundNrArray[2] = 0
        backgroundNrArray[3] = 0
        backgroundNrArray[4] = 0
        backgroundNrArray[5] = 0
        backgroundNrArray[6] = 0
        
        
        mondayTimeText.text = "\(mondayTime) mins"
        tuesdayTimeText.text = "\(tuesdayTime) mins"
        wednesdayTimeText.text = "\(wednesdayTime) mins"
        thursdayTimeText.text = "\(thursdayTime) mins"
        fridayTimeText.text = "\(fridayTime) mins"
        saturdayTimeText.text = "\(saturdayTime) mins"
        sundayTimeText.text = "\(sundayTime) mins"
        summaryTimeText.text = timeString(time: TimeInterval(seconds))
        
        saveData()
        
    }
    
    func runTimer() {
        //repeat timer ever one minute
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in self.countdown()
            
        }
        
    }
    
    func countdown() {
        
        if seconds < 1 {
            timer.invalidate()
            //send push notification to user advising timer done
        }
        else {
            seconds -= 1
            summaryTimeText.text = timeString(time: TimeInterval(seconds))
        }
        saveData()
    }
    
    func stopCountdown() {
        timer.invalidate()
        saveData()
        
    }
    
    func updateViewWithSavedData() {
        
        //load array data
        mondayTime = totalTimeArr[0]
        tuesdayTime = totalTimeArr[1]
        wednesdayTime = totalTimeArr[2]
        thursdayTime = totalTimeArr[3]
        fridayTime = totalTimeArr[4]
        saturdayTime = totalTimeArr[5]
        sundayTime = totalTimeArr[6]

        mondayTimeText.text = "\(mondayTime) mins"
        tuesdayTimeText.text = "\(tuesdayTime) mins"
        wednesdayTimeText.text = "\(wednesdayTime) mins"
        thursdayTimeText.text = "\(thursdayTime) mins"
        fridayTimeText.text = "\(fridayTime) mins"
        saturdayTimeText.text = "\(saturdayTime) mins"
        sundayTimeText.text = "\(sundayTime) mins"
        summaryTimeText.text = timeString(time: TimeInterval(seconds))
        
    }
    
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
}

