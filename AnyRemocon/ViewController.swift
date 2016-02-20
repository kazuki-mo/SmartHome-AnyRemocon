//
//  ViewController.swift
//  AnyRemocon
//
//  Created by 守谷 一希 on 2016/02/17.
//  Copyright © 2016年 守谷 一希. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var timer : NSTimer!
    let session: NSURLSession = NSURLSession.sharedSession()
    
    let dbModel = DBModel()
    var objects = NSMutableArray()
    var single_dic = NSMutableDictionary()
    var double_dic = NSMutableDictionary()
    var up_dic = NSMutableDictionary()
    var down_dic = NSMutableDictionary()
    var right_dic = NSMutableDictionary()
    var left_dic = NSMutableDictionary()
    
    var Aircon_SetTempValue = 0.0
    var Aircon_AirFlowValue = 0
    var Aircon_DriveModeValue = 0
    var Light_LightLevelValue = 0
    var Light_LightColorValue = 0
    var Light_LightingModeValue = 0
    
    var Flag_TV = false
    var Flag_Aircon = false
    var Flag_Light = false
    var Flag_AirClean = false
    var Flag_Remocon = false
    
    @IBOutlet weak var Lb_1: UILabel!
    @IBOutlet weak var Lb_2: UILabel!
    @IBOutlet weak var Lb_3: UILabel!
    @IBOutlet weak var Lb_Power: UILabel!
    
    
    @IBOutlet weak var Lb_Text: UILabel!
    @IBOutlet weak var Lb_Type: UILabel!

    @IBOutlet weak var BT_Remocon: UIButton!
    @IBOutlet weak var BT_AirClean: UIButton!
    @IBOutlet weak var BT_Light: UIButton!
    @IBOutlet weak var BT_Aircon: UIButton!
    @IBOutlet weak var BT_TV: UIButton!

    @IBOutlet weak var BT_Setting: UIButton!
    @IBOutlet weak var Im_Remocon: UIImageView!
    @IBOutlet weak var Im_AirClean: UIImageView!
    @IBOutlet weak var Im_Light: UIImageView!
    @IBOutlet weak var Im_Aircon: UIImageView!
    @IBOutlet weak var Im_TV: UIImageView!
    
    @IBAction func BT_Setting(sender: AnyObject) {
        
        let mySettingController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingController") as! SettingController
        mySettingController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.navigationController?.pushViewController(mySettingController, animated: true)
        
    }

    @IBAction func BT_Remocon(sender: AnyObject) {
        Flag_TV = false
        Flag_Aircon = false
        Flag_Light = false
        Flag_AirClean = false
        Flag_Remocon = true
        
        Im_TV.hidden = true
        Im_Aircon.hidden = true
        Im_Light.hidden = true
        Im_AirClean.hidden = true
        Im_Remocon.hidden = false
        BT_Setting.hidden = false
        
        BT_TV.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Aircon.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Light.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_AirClean.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Remocon.backgroundColor = UIColorUtil.rgb(0xe0ffe2)
        
        Lb_Type.text = "ユーザ設定"
        
        Lb_1.hidden = true
        Lb_2.hidden = true
        Lb_3.hidden = true
        Lb_Power.hidden = true
        
        objects = dbModel.getAll()
        for object in objects{
            let id = object["ID"] as! Int
            let touchestype = object["touchestype"] as! String
            let command1 = object["command1"] as! String
            let command2 = object["command2"] as! String
            let command3 = object["command3"] as! String
            let command4 = object["command4"] as! String
            
            print("ID:\(id), touchestype:\(touchestype), command1:\(command1), command2:\(command2), command3:\(command3), command4:\(command4)")
            
            if(touchestype == "single"){
                single_dic = ["ID":id,"touchestype":touchestype,"command1":command1,"command2":command2,"command3":command3,"command4":command4]
            }else if(touchestype == "double"){
                double_dic = ["ID":id,"touchestype":touchestype,"command1":command1,"command2":command2,"command3":command3,"command4":command4]
            }else if(touchestype == "up"){
                up_dic = ["ID":id,"touchestype":touchestype,"command1":command1,"command2":command2,"command3":command3,"command4":command4]
            }else if(touchestype == "down"){
                down_dic = ["ID":id,"touchestype":touchestype,"command1":command1,"command2":command2,"command3":command3,"command4":command4]
            }else if(touchestype == "right"){
                right_dic = ["ID":id,"touchestype":touchestype,"command1":command1,"command2":command2,"command3":command3,"command4":command4]
            }else if(touchestype == "left"){
                left_dic = ["ID":id,"touchestype":touchestype,"command1":command1,"command2":command2,"command3":command3,"command4":command4]
            }
        }
        
        var url = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/getSetTemp")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:07:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Aircon_SetTempValue = Double(((Int(result3, radix: 16) ?? 0) - 128)) / 2.0
            })
        })
        
        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/getAirFlow")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:a0:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Aircon_AirFlowValue = (Int(result3, radix: 16) ?? 0) - 48
                if(self.Aircon_AirFlowValue == 17){
                    self.Aircon_AirFlowValue = 0
                }
                
            })
        })
        
        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/getDriveMode")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:b0:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Aircon_DriveModeValue = Int(result3, radix: 16) ?? 0
                
            })
        })

        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/getLightLevel")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:b0:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Light_LightLevelValue = Int(result3, radix: 16) ?? 0
            })
        })
        
        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/getLightColor")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:b1:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Light_LightColorValue = Int(result3, radix: 16) ?? 0
            })
        })
        
        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/getLightingMode")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:b6:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Light_LightingModeValue = Int(result3, radix: 16) ?? 0
            })
        })

    }
    @IBAction func BT_AirClean(sender: AnyObject) {
        Flag_TV = false
        Flag_Aircon = false
        Flag_Light = false
        Flag_AirClean = true
        Flag_Remocon = false
        
        Im_TV.hidden = true
        Im_Aircon.hidden = true
        Im_Light.hidden = true
        Im_AirClean.hidden = false
        Im_Remocon.hidden = true
        BT_Setting.hidden = true
        
        BT_TV.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Aircon.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Light.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_AirClean.backgroundColor = UIColorUtil.rgb(0xe0ffe2)
        BT_Remocon.backgroundColor = UIColorUtil.rgb(0x27b54a)
        
        Lb_Type.text = "空気清浄機"
        
        Lb_1.hidden = true
        Lb_2.hidden = true
        Lb_3.hidden = true
        Lb_Power.hidden = false
        
        let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/AirClean/getPower")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:80:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                if(result3 == "30"){
                    self.Lb_Power.text = "電源：ON"
                }else if(result3 == "31"){
                    self.Lb_Power.text = "電源：OFF"
                }
            })
        })
    }
    @IBAction func BT_Light(sender: AnyObject) {
        Flag_TV = false
        Flag_Aircon = false
        Flag_Light = true
        Flag_AirClean = false
        Flag_Remocon = false
        
        Im_TV.hidden = true
        Im_Aircon.hidden = true
        Im_Light.hidden = false
        Im_AirClean.hidden = true
        Im_Remocon.hidden = true
        BT_Setting.hidden = true
        
        BT_TV.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Aircon.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Light.backgroundColor = UIColorUtil.rgb(0xe0ffe2)
        BT_AirClean.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Remocon.backgroundColor = UIColorUtil.rgb(0x27b54a)
        
        Lb_Type.text = "天井照明"
        
        Lb_1.hidden = false
        Lb_2.hidden = false
        Lb_3.hidden = false
        Lb_Power.hidden = false
        
        var url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/getPower")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:80:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                if(result3 == "30"){
                    self.Lb_Power.text = "電源：ON"
                }else if(result3 == "31"){
                    self.Lb_Power.text = "電源：OFF"
                }
            })
        })
        
        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/getLightLevel")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:b0:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Light_LightLevelValue = Int(result3, radix: 16) ?? 0
                self.Lb_1.text = "明るさ：" + String(self.Light_LightLevelValue) + "％"
            })
        })
        
        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/getLightColor")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:b1:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Light_LightColorValue = Int(result3, radix: 16) ?? 0
                if(result3 == "41"){
                    self.Lb_2.text = "光色：電球色"
                }else if(result3 == "42"){
                    self.Lb_2.text = "光色：白色"
                }else if(result3 == "43"){
                    self.Lb_2.text = "光色：昼白色"
                }else if(result3 == "44"){
                    self.Lb_2.text = "光色：昼光色"
                }else if(result3 == "40"){
                    self.Lb_2.text = "光色：その他"
                }
                
            })
        })
        
        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/getLightingMode")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:b6:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Light_LightingModeValue = Int(result3, radix: 16) ?? 0
                if(result3 == "41"){
                    self.Lb_3.text = "点灯モード：自動"
                }else if(result3 == "42"){
                    self.Lb_3.text = "点灯モード：通常灯"
                }else if(result3 == "43"){
                    self.Lb_3.text = "点灯モード：常夜灯"
                }else if(result3 == "45"){
                    self.Lb_3.text = "点灯モード：カラー灯"
                }
                
            })
        })
    }
    @IBAction func BT_Aircon(sender: AnyObject) {
        Flag_TV = false
        Flag_Aircon = true
        Flag_Light = false
        Flag_AirClean = false
        Flag_Remocon = false
        
        Im_TV.hidden = true
        Im_Aircon.hidden = false
        Im_Light.hidden = true
        Im_AirClean.hidden = true
        Im_Remocon.hidden = true
        BT_Setting.hidden = true
        
        BT_TV.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Aircon.backgroundColor = UIColorUtil.rgb(0xe0ffe2)
        BT_Light.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_AirClean.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Remocon.backgroundColor = UIColorUtil.rgb(0x27b54a)
        
        Lb_Type.text = "エアコン"
        Lb_1.hidden = false
        Lb_2.hidden = false
        Lb_3.hidden = false
        Lb_Power.hidden = false
        
        var url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/getPower")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:80:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                if(result3 == "30"){
                    self.Lb_Power.text = "電源：ON"
                }else if(result3 == "31"){
                    self.Lb_Power.text = "電源：OFF"
                }
            })
        })
        
        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/getSetTemp")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:07:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Aircon_SetTempValue = Double(((Int(result3, radix: 16) ?? 0) - 128)) / 2.0
                self.Lb_1.text = "設定温度：" + String(self.Aircon_SetTempValue) + "度"
            })
        })
        
        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/getAirFlow")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:a0:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Aircon_AirFlowValue = (Int(result3, radix: 16) ?? 0) - 48
                if(self.Aircon_AirFlowValue == 17){
                    self.Lb_2.text = "風量：自動"
                    self.Aircon_AirFlowValue = 0
                }else{
                    self.Lb_2.text = "風量：" + String(self.Aircon_AirFlowValue)
                }
                
            })
        })
        
        url = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/getDriveMode")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:b0:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                self.Aircon_DriveModeValue = Int(result3, radix: 16) ?? 0
                if(result3 == "41"){
                    self.Lb_3.text = "運転モード：自動"
                }else if(result3 == "42"){
                    self.Lb_3.text = "運転モード：冷房"
                }else if(result3 == "43"){
                    self.Lb_3.text = "運転モード：暖房"
                }else if(result3 == "44"){
                    self.Lb_3.text = "運転モード：除湿"
                }else if(result3 == "45"){
                    self.Lb_3.text = "運転モード：送風"
                }else if(result3 == "40"){
                    self.Lb_3.text = "運転モード：その他"
                }
                
            })
        })
    }
    @IBAction func BT_TV(sender: AnyObject) {
        Flag_TV = true
        Flag_Aircon = false
        Flag_Light = false
        Flag_AirClean = false
        Flag_Remocon = false
        
        Im_TV.hidden = false
        Im_Aircon.hidden = true
        Im_Light.hidden = true
        Im_AirClean.hidden = true
        Im_Remocon.hidden = true
        BT_Setting.hidden = true
        
        BT_TV.backgroundColor = UIColorUtil.rgb(0xe0ffe2)
        BT_Aircon.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Light.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_AirClean.backgroundColor = UIColorUtil.rgb(0x27b54a)
        BT_Remocon.backgroundColor = UIColorUtil.rgb(0x27b54a)
        
        Lb_Type.text = "テレビ"
        
        Lb_1.hidden = true
        Lb_2.hidden = true
        Lb_3.hidden = true
        Lb_Power.hidden = false
        
        let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/getPower")!
        http_get(url, completionHandler: { data, response, error in
            let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let result2 = result.componentsSeparatedByString("epc:80:")
                let substrStartIndex = result2[1].startIndex.advancedBy(0)
                let substrEndIndex = substrStartIndex.advancedBy(2)
                let result3 = result2[1].substringWithRange(Range(start: substrStartIndex, end: substrEndIndex))
                
                if(result3 == "30"){
                    self.Lb_Power.text = "電源：ON"
                }else if(result3 == "31"){
                    self.Lb_Power.text = "電源：OFF"
                }
            })
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        Im_TV.hidden = true
        Im_Aircon.hidden = true
        Im_Light.hidden = true
        Im_AirClean.hidden = true
        Im_Remocon.hidden = true
        BT_Setting.hidden = true
        
        Lb_Type.text = ""
        
        Lb_1.hidden = true
        Lb_2.hidden = true
        Lb_3.hidden = true
        Lb_Power.hidden = true
        
        // single swipe up
        let swipeUpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeUp:")
        swipeUpGesture.numberOfTouchesRequired = 1  // number of fingers
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUpGesture)
        
        // single swipe down
        let swipeDownGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeDown:")
        swipeDownGesture.numberOfTouchesRequired = 1
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDownGesture)
        
        // single swipe left
        let swipeLeftGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeLeft:")
        swipeLeftGesture.numberOfTouchesRequired = 1  // number of fingers
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        // single swipe right
        let swipeRightGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipeRight:")
        swipeRightGesture.numberOfTouchesRequired = 1  // number of fingers
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRightGesture)
        
//        let data = DataModel(touchestype: "single", command1: "TV_Power_On", command2: "Nothing", command3: "Nothing", command4: "Nothing")
//        dbModel.update(data)
        
//        objects = dbModel.getAll()
//        for object in objects{
//            let id = object["ID"] as! Int
//            let touchestype = object["touchestype"] as! String
//            let command1 = object["command1"] as! String
//            let command2 = object["command2"] as! String
//            let command3 = object["command3"] as! String
//            let command4 = object["command4"] as! String
//            
//            print("ID:\(id), touchestype:\(touchestype), command1:\(command1), command2:\(command2), command3:\(command3), command4:\(command4)")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.first?.tapCount == 1{
            Lb_Text.text = "シングルタップ"
            
            timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "onSingle:", userInfo: nil, repeats: true)
            
        }else{
            timer.invalidate()
            
            Lb_Text.text = "ダブルタップ"
            
            if(Flag_TV){
                Lb_Text.text = "テレビ　ダブルタップ"
                let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/Power/On")!
                http_get(url, completionHandler: { data, response, error in
                    //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.Lb_Text.text = "電源ON"
                        self.Lb_Power.text = "電源：ON"
                    })
                })
            }else if(Flag_Aircon){
                Lb_Text.text = "エアコン　ダブルタップ"
                let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/Power/On")!
                http_get(url, completionHandler: { data, response, error in
                    //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.Lb_Text.text = "電源ON"
                        self.Lb_Power.text = "電源：ON"
                    })
                })
            }else if(Flag_Light){
                Lb_Text.text = "天井照明　ダブルタップ"
                let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/Power/On")!
                http_get(url, completionHandler: { data, response, error in
                    //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.Lb_Text.text = "電源ON"
                        self.Lb_Power.text = "電源：ON"
                    })
                })
            }else if(Flag_AirClean){
                Lb_Text.text = "空気清浄機　ダブルタップ"
                let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/AirClean/Power/On")!
                http_get(url, completionHandler: { data, response, error in
                    //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.Lb_Text.text = "電源ON"
                        self.Lb_Power.text = "電源：ON"
                    })
                })
            }else if(Flag_Remocon){
                Lb_Text.text = "ユーザ設定　ダブルタップ"
                sendCommand(double_dic["command1"] as! String)
                sendCommand(double_dic["command2"] as! String)
                sendCommand(double_dic["command3"] as! String)
                sendCommand(double_dic["command4"] as! String)
            }
            
        }
    }
    
    func handleSwipeUp(sender: UITapGestureRecognizer){
        Lb_Text.text = "Swiped up!"
        
        if(Flag_TV){
            Lb_Text.text = "テレビ　上スワイプ"
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/Volume/Up")!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "音量UP"
                })
            })
        }else if(Flag_Aircon){
            Lb_Text.text = "エアコン　上スワイプ"
            
            Aircon_SetTempValue = Aircon_SetTempValue + 0.5
            if(Aircon_SetTempValue > 40){
                Aircon_SetTempValue = 40
                self.Lb_Text.text = "設定温度　40度（これ以上，上げられません）"
            }
            let value = String(Aircon_SetTempValue)
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/SetTemp/" + value)!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "設定温度　" + value + "度"
                    self.Lb_1.text = "設定温度：" + value + "度"
                })
            })
        }else if(Flag_Light){
            Lb_Text.text = "天井照明　上スワイプ"
            
            Light_LightLevelValue = Light_LightLevelValue + 10
            if(Light_LightLevelValue > 100){
                Light_LightLevelValue = 100
            }
            let value = String(Light_LightLevelValue)
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/LightLevel/" + value)!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "明るさ　" + value + "％"
                    self.Lb_1.text = "明るさ：" + value + "％"
                })
            })
        }else if(Flag_Remocon){
            Lb_Text.text = "ユーザ設定　上スワイプ"
            sendCommand(up_dic["command1"] as! String)
            sendCommand(up_dic["command2"] as! String)
            sendCommand(up_dic["command3"] as! String)
            sendCommand(up_dic["command4"] as! String)
        }
    }
    
    func handleSwipeDown(sender: UITapGestureRecognizer){
        Lb_Text.text = "Swiped down!"
        
        if(Flag_TV){
            Lb_Text.text = "テレビ　下スワイプ"
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/Volume/Down")!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "音量Down"
                })
            })
        }else if(Flag_Aircon){
            Lb_Text.text = "エアコン　下スワイプ"
            
            Aircon_SetTempValue = Aircon_SetTempValue - 0.5
            if(Aircon_SetTempValue < 0){
                Aircon_SetTempValue = 0
                self.Lb_Text.text = "設定温度　0度（これ以上，下げられません）"
            }
            let value = String(Aircon_SetTempValue)
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/SetTemp/" + value)!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "設定温度　" + value + "度"
                    self.Lb_1.text = "設定温度：" + value + "度"
                })
            })
        }else if(Flag_Light){
            Lb_Text.text = "天井照明　下スワイプ"
            
            Light_LightLevelValue = Light_LightLevelValue - 10
            if(Light_LightLevelValue < 0){
                Light_LightLevelValue = 0
            }
            let value = String(Light_LightLevelValue)
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/LightLevel/" + value)!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "明るさ　" + value + "％"
                    self.Lb_1.text = "明るさ：" + value + "％"
                })
            })
        }else if(Flag_Remocon){
            Lb_Text.text = "ユーザ設定　下スワイプ"
            sendCommand(down_dic["command1"] as! String)
            sendCommand(down_dic["command2"] as! String)
            sendCommand(down_dic["command3"] as! String)
            sendCommand(down_dic["command4"] as! String)
        }
    }
    
    func handleSwipeLeft(sender: UITapGestureRecognizer){
        Lb_Text.text = "Swiped left!"
        
        if(Flag_TV){
            Lb_Text.text = "テレビ　左スワイプ"
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/CH/Down")!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "CH Down"
                })
            })
        }else if(Flag_Aircon){
            Lb_Text.text = "エアコン　左スワイプ"
            
            Aircon_DriveModeValue = Aircon_DriveModeValue - 1
            if(Aircon_DriveModeValue < 64){
                Aircon_DriveModeValue = 64
                self.Lb_Text.text = "運転モード：その他"
            }
            var value = "Auto"
            var display = "自動"
            if(Aircon_DriveModeValue == 64){
                value = "Other"
                display = "その他"
            }else if(Aircon_DriveModeValue == 65){
                value = "Auto"
                display = "自動"
            }else if(Aircon_DriveModeValue == 66){
                value = "Cool"
                display = "冷房"
            }else if(Aircon_DriveModeValue == 67){
                value = "Heat"
                display = "暖房"
            }else if(Aircon_DriveModeValue == 68){
                value = "Dehum"
                display = "除湿"
            }else if(Aircon_DriveModeValue == 69){
                value = "Blast"
                display = "送風"
            }
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/DriveMode/" + value)!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "運転モード　" + display
                    self.Lb_3.text = "運転モード：" + display
                })
            })
        }else if(Flag_Light){
            Lb_Text.text = "天井照明　左スワイプ"
            
            Light_LightingModeValue = Light_LightingModeValue - 1
            if(Light_LightingModeValue < 65){
                Light_LightingModeValue = 65
            }else if(Light_LightingModeValue == 68){
                Light_LightingModeValue = 67
            }
            var value = "Auto"
            var display = "自動"
            if(Light_LightingModeValue == 65){
                value = "Auto"
                display = "自動"
            }else if(Light_LightingModeValue == 66){
                value = "Normal"
                display = "通常灯"
            }else if(Light_LightingModeValue == 67){
                value = "Night"
                display = "常夜灯"
            }else if(Light_LightingModeValue == 69){
                value = "Color"
                display = "カラー灯"
            }
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/LightingMode/" + value)!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "点灯モード　" + display
                    self.Lb_3.text = "点灯モード：" + display
                })
            })
        }else if(Flag_Remocon){
            Lb_Text.text = "ユーザ設定　左スワイプ"
            sendCommand(left_dic["command1"] as! String)
            sendCommand(left_dic["command2"] as! String)
            sendCommand(left_dic["command3"] as! String)
            sendCommand(left_dic["command4"] as! String)
        }
    }
    
    func handleSwipeRight(sender: UITapGestureRecognizer){
        Lb_Text.text = "Swiped right!"
        
        if(Flag_TV){
            Lb_Text.text = "テレビ　右スワイプ"
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/CH/Up")!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "CH Up"
                })
            })
        }else if(Flag_Aircon){
            Lb_Text.text = "エアコン　右スワイプ"
            
            Aircon_DriveModeValue = Aircon_DriveModeValue + 1
            if(Aircon_DriveModeValue > 69){
                Aircon_DriveModeValue = 69
                self.Lb_Text.text = "運転モード：送風"
            }
            var value = "Auto"
            var display = "自動"
            if(Aircon_DriveModeValue == 64){
                value = "Other"
                display = "その他"
            }else if(Aircon_DriveModeValue == 65){
                value = "Auto"
                display = "自動"
            }else if(Aircon_DriveModeValue == 66){
                value = "Cool"
                display = "冷房"
            }else if(Aircon_DriveModeValue == 67){
                value = "Heat"
                display = "暖房"
            }else if(Aircon_DriveModeValue == 68){
                value = "Dehum"
                display = "除湿"
            }else if(Aircon_DriveModeValue == 69){
                value = "Blast"
                display = "送風"
            }
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/DriveMode/" + value)!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "運転モード　" + display
                    self.Lb_3.text = "運転モード：" + display
                })
            })
        }else if(Flag_Light){
            Lb_Text.text = "天井照明　右スワイプ"
            
            Light_LightingModeValue = Light_LightingModeValue + 1
            if(Light_LightingModeValue > 69){
                Light_LightingModeValue = 69
            }else if(Light_LightingModeValue == 68){
                Light_LightingModeValue = 69
            }
            var value = "Auto"
            var display = "自動"
            if(Light_LightingModeValue == 65){
                value = "Auto"
                display = "自動"
            }else if(Light_LightingModeValue == 66){
                value = "Normal"
                display = "通常灯"
            }else if(Light_LightingModeValue == 67){
                value = "Night"
                display = "常夜灯"
            }else if(Light_LightingModeValue == 69){
                value = "Color"
                display = "カラー灯"
            }
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/LightingMode/" + value)!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "点灯モード　" + display
                    self.Lb_3.text = "点灯モード：" + display
                })
            })
        }else if(Flag_Remocon){
            Lb_Text.text = "ユーザ設定　右スワイプ"
            sendCommand(right_dic["command1"] as! String)
            sendCommand(right_dic["command2"] as! String)
            sendCommand(right_dic["command3"] as! String)
            sendCommand(right_dic["command4"] as! String)
        }
    }
    
    func sendCommand(command:String){
        
        if(command == "Nothing"){
            
        }else if(command == "TV_Power_On"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/Power/On")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "TV_Power_Off"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/Power/Off")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Aircon_Power_On"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/Power/On")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Aircon_Power_Off"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/Power/Off")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Light_Power_On"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/Power/On")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Light_Power_Off"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/Power/Off")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "AirClean_Power_On"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/AirClean/Power/On")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "AirClean_Power_Off"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/AirClean/Power/Off")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "TV_CH_Up"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/CH/Up")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "TV_CH_Down"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/CH/Down")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "TV_Volume_Up"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/Volume/Up")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "TV_Volume_Down"){
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/Volume/Down")!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Aircon_SetTemp_Up"){
            Aircon_SetTempValue = Aircon_SetTempValue + 0.5
            if(Aircon_SetTempValue > 40){
                Aircon_SetTempValue = 40
            }
            let value = String(Aircon_SetTempValue)
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/SetTemp/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Aircon_SetTemp_Down"){
            Aircon_SetTempValue = Aircon_SetTempValue - 0.5
            if(Aircon_SetTempValue < 0){
                Aircon_SetTempValue = 0
            }
            let value = String(Aircon_SetTempValue)
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/SetTemp/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Aircon_AirFlow_Up"){
            Aircon_AirFlowValue = Aircon_AirFlowValue + 1
            if(Aircon_AirFlowValue > 6){
                Aircon_AirFlowValue = 6
            }
            var value = String(Aircon_AirFlowValue)
            if(value == "0"){
                value = "Auto"
            }
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/AirFlow/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Aircon_AirFlow_Down"){
            Aircon_AirFlowValue = Aircon_AirFlowValue - 1
            if(Aircon_AirFlowValue < 0){
                Aircon_AirFlowValue = 0
            }
            var value = String(Aircon_AirFlowValue)
            if(value == "0"){
                value = "Auto"
            }
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/AirFlow/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Aircon_DriveMode_Up"){
            Aircon_DriveModeValue = Aircon_DriveModeValue + 1
            if(Aircon_DriveModeValue > 69){
                Aircon_DriveModeValue = 69
            }
            var value = "Auto"
            if(Aircon_DriveModeValue == 65){
                value = "Auto"
            }else if(Aircon_DriveModeValue == 66){
                value = "Cool"
            }else if(Aircon_DriveModeValue == 67){
                value = "Heat"
            }else if(Aircon_DriveModeValue == 68){
                value = "Dehum"
            }else if(Aircon_DriveModeValue == 69){
                value = "Blast"
            }
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/DriveMode/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Aircon_DriveMode_Down"){
            Aircon_DriveModeValue = Aircon_DriveModeValue - 1
            if(Aircon_DriveModeValue < 65){
                Aircon_DriveModeValue = 65
            }
            var value = "Auto"
            if(Aircon_DriveModeValue == 65){
                value = "Auto"
            }else if(Aircon_DriveModeValue == 66){
                value = "Cool"
            }else if(Aircon_DriveModeValue == 67){
                value = "Heat"
            }else if(Aircon_DriveModeValue == 68){
                value = "Dehum"
            }else if(Aircon_DriveModeValue == 69){
                value = "Blast"
            }
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/DriveMode/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Light_LightLevel_Up"){
            Light_LightLevelValue = Light_LightLevelValue + 10
            if(Light_LightLevelValue > 100){
                Light_LightLevelValue = 100
            }
            let value = String(Light_LightLevelValue)
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/LightLevel/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Light_LightLevel_Down"){
            Light_LightLevelValue = Light_LightLevelValue - 10
            if(Light_LightLevelValue < 0){
                Light_LightLevelValue = 0
            }
            let value = String(Light_LightLevelValue)
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/LightLevel/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Light_LightColor_Up"){
            Light_LightColorValue = Light_LightColorValue + 1
            if(Light_LightColorValue > 68){
                Light_LightColorValue = 68
            }
            var value = "Daylight"
            if(Light_LightColorValue == 65){
                value = "LightBulb"
            }else if(Light_LightColorValue == 66){
                value = "White"
            }else if(Light_LightColorValue == 67){
                value = "NaturalWhite"
            }else if(Light_LightColorValue == 68){
                value = "Daylight"
            }
            
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/LightColor/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Light_LightColor_Down"){
            Light_LightColorValue = Light_LightColorValue - 1
            if(Light_LightColorValue < 65){
                Light_LightColorValue = 65
            }
            var value = "Daylight"
            if(Light_LightColorValue == 65){
                value = "LightBulb"
            }else if(Light_LightColorValue == 66){
                value = "White"
            }else if(Light_LightColorValue == 67){
                value = "NaturalWhite"
            }else if(Light_LightColorValue == 68){
                value = "Daylight"
            }
            
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/LightColor/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Light_LightingMode_Up"){
            Light_LightingModeValue = Light_LightingModeValue + 1
            if(Light_LightingModeValue > 69){
                Light_LightingModeValue = 69
            }else if(Light_LightingModeValue == 68){
                Light_LightingModeValue = 69
            }
            var value = "Auto"
            if(Light_LightingModeValue == 65){
                value = "Auto"
            }else if(Light_LightingModeValue == 66){
                value = "Normal"
            }else if(Light_LightingModeValue == 67){
                value = "Night"
            }else if(Light_LightingModeValue == 69){
                value = "Color"
            }
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/LightingMode/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }else if(command == "Light_LightingMode_Down"){
            Light_LightingModeValue = Light_LightingModeValue - 1
            if(Light_LightingModeValue < 65){
                Light_LightingModeValue = 65
            }else if(Light_LightingModeValue == 68){
                Light_LightingModeValue = 67
            }
            var value = "Auto"
            if(Light_LightingModeValue == 65){
                value = "Auto"
            }else if(Light_LightingModeValue == 66){
                value = "Normal"
            }else if(Light_LightingModeValue == 67){
                value = "Night"
            }else if(Light_LightingModeValue == 69){
                value = "Color"
            }
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/LightingMode/" + value)!
            http_get(url, completionHandler: { data, response, error in
                NSOperationQueue.mainQueue().addOperationWithBlock({})
            })
        }
    }
    
    func onSingle(_timer : NSTimer){
        timer.invalidate()
        if(Flag_TV){
            Lb_Text.text = "テレビ　シングルタップ"
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/TV/Power/Off")!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "電源OFF"
                    self.Lb_Power.text = "電源：OFF"
                })
            })
        }else if(Flag_Aircon){
            Lb_Text.text = "エアコン　シングルタップ"
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Aircon_LR/Power/Off")!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "電源OFF"
                    self.Lb_Power.text = "電源：OFF"
                })
            })
        }else if(Flag_Light){
            Lb_Text.text = "天井照明　シングルタップ"
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/Light_LR/Power/Off")!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "電源OFF"
                    self.Lb_Power.text = "電源：OFF"
                })
            })
        }else if(Flag_AirClean){
            Lb_Text.text = "空気清浄機　シングルタップ"
            let url: NSURL = NSURL(string: "http://ubi-t07.naist.jp:5000/AirClean/Power/Off")!
            http_get(url, completionHandler: { data, response, error in
                //let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.Lb_Text.text = "電源OFF"
                    self.Lb_Power.text = "電源：OFF"
                })
            })
        }else if(Flag_Remocon){
            Lb_Text.text = "ユーザ設定　シングルタップ"
            sendCommand(single_dic["command1"] as! String)
            sendCommand(single_dic["command2"] as! String)
            sendCommand(single_dic["command3"] as! String)
            sendCommand(single_dic["command4"] as! String)
        }
    }
    
    func http_get(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
    }


}

