//
//  ViewController.swift
//  NoodleTimer
//
//  Created by hidetaka on 2019/10/19.
//  Copyright © 2019 hidetaka. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class ViewController: UIViewController,AVAudioPlayerDelegate {

    var startTime: TimeInterval? = nil
    var setTime:TimeInterval = 180
    var resetTime:TimeInterval = 180
    var timer = Timer()
    var musicTimer = Timer()
    var toggle:Bool = true
    var resetTimerLabel = "3:00"
    
    
    let sound = NSDataAsset(name: "music")
    var player: AVAudioPlayer?
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var noodle1: UIImageView!
    @IBOutlet weak var btnLabel: UIButton!
    
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnLabel.addTarget(self, action: #selector(ViewController.onDownButton(sender:)), for: .touchDown)
        btnLabel.addTarget(self, action: #selector(ViewController.onUpButton(sender:)), for: [.touchUpInside,.touchUpOutside])
        
        btn3.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 1)
        btn4.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 0.1)
        btn5.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 0.1)
        btnLabel.backgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0, alpha: 1)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
  
    func creatNotification(){
        // ローカル通知のの内容
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "カップ麺ができました"
        content.badge = 1
//        content.subtitle = "タイマー通知"
//        content.body = "タイマーによるローカル通知です"
        // タイマーの時間（秒）をセット
        let timer = setTime
        // ローカル通知リクエストを作成
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timer), repeats: false)
        let identifier = NSUUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    @objc func onDownButton(sender: UIButton){
        //UIView.animateWithDuration
        UIView.animate(withDuration: 0.1,

                                   // アニメーション中の処理.
            animations: { () -> Void in

                // 縮小用アフィン行列を作成する.
                self.btnLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)

            })
        { (Bool) -> Void in

        }
    }
    
    
    @objc func onUpButton(sender: UIButton){
        UIView.animate(withDuration: 0.1,

                                   // アニメーション中の処理.
            animations: { () -> Void in

                // 拡大用アフィン行列を作成する.
                self.btnLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)

                // 縮小用アフィン行列を作成する.
                self.btnLabel.transform = CGAffineTransform(scaleX: 1, y: 1)

            })
        { (Bool) -> Void in

        }
    }
    
    func setBtnEnabled(_ btn3:Bool, _ btn4:Bool, _ btn5:Bool) {
        self.btn3.isEnabled = btn3
        self.btn4.isEnabled = btn4
        self.btn5.isEnabled = btn5
    }
    
    @objc func playMusic(){
            if let sound = NSDataAsset(name: "music") {
                player = try? AVAudioPlayer(data: sound.data)
                player?.play()
                print("music")
        }
    }
    
    
    @objc func update() {
            if let startTime = self.startTime {
                let t: Double = setTime - (Date.timeIntervalSinceReferenceDate-startTime)
                if t >= 0 {
                    
                    let min = Int(ceil(t)) / 60
                    let sec = Int(ceil(t)) % 60
                    self.timerLabel.text = String(format: "%01d:%02d", min,sec)
                    print(t)
                } else {
                    self.btnLabel.isEnabled = true
                    self.timerLabel.text = "完成"
                    self.btnLabel.setTitle("ストップ", for: .normal)
                    toggle = false
                    timer.invalidate()
                    noodle1.image = UIImage(named: "noodle2")
                    self.musicTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                         target: self,
                                         selector: #selector(self.playMusic),
                                         userInfo: nil,
                                         repeats: true)
                }
            }
    }

    @IBAction func countDownStart(_ sender: Any) {
        if (toggle) {
            creatNotification()
            self.startTime = Date.timeIntervalSinceReferenceDate
            self.timer = Timer.scheduledTimer(
                timeInterval: 0.01,
                target: self,
                selector: #selector(self.update),
                userInfo: nil,
                repeats: true)
            self.btnLabel.setTitle("waiting", for: .normal)
            self.btnLabel.isEnabled = false
            btnLabel.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 1)
            setBtnEnabled(false, false, false)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
            self.musicTimer.invalidate()
            self.setTime = self.resetTime
            self.startTime = nil
            self.btnLabel.setTitle("スタート", for: .normal)
            btnLabel.backgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0, alpha: 1)
            self.timerLabel.text = resetTimerLabel
            toggle = true
            setBtnEnabled(true, true, true)
            noodle1.image = UIImage(named: "noodle1")
        }
    }
    
    @IBAction func set3minites(_ sender: Any) {
        self.setTime = 180
        self.resetTime = 180
        self.timerLabel.text = "3:00"
        self.resetTimerLabel = "3:00"
        self.startTime = nil
        btn3.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 1)
        btn4.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 0.1)
        btn5.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 0.1)
        btn3.setTitleColor(UIColor.white, for: .normal)
        btn4.setTitleColor(UIColor.systemBlue, for: .normal)
        btn5.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    @IBAction func set4minites(_ sender: Any) {
        self.setTime = 240
        self.resetTime = 240
        self.timerLabel.text = "4:00"
        self.resetTimerLabel = "4:00"
        self.startTime = nil
        btn3.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 0.1)
        btn4.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 1)
        btn5.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 0.1)
        btn4.setTitleColor(UIColor.white, for: .normal)
        btn3.setTitleColor(UIColor.systemBlue, for: .normal)
        btn5.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    @IBAction func set5minites(_ sender: Any) {
        self.setTime = 300
        self.resetTime = 300
        self.timerLabel.text = "5:00"
        self.resetTimerLabel = "5:00"
        self.startTime = nil
        btn3.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 0.1)
        btn4.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 0.1)
        btn5.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0, alpha: 1)
        btn5.setTitleColor(UIColor.white, for: .normal)
        btn4.setTitleColor(UIColor.systemBlue, for: .normal)
        btn3.setTitleColor(UIColor.systemBlue, for: .normal)
    }
    
    
    
}

