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
    
    let session: NSURLSession = NSURLSession.sharedSession()
    
    let dbModel = DBModel()
    var objects = NSMutableArray()
    
    var Flag_TV = false
    var Flag_Aircon = false
    var Flag_Light = false
    var Flag_AirClean = false
    var Flag_Remocon = false
    
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
        
        objects = dbModel.getAll()
        for object in objects{
            let id = object["ID"] as! Int
            let touchestype = object["touchestype"] as! String
            let command1 = object["command1"] as! String
            let command2 = object["command2"] as! String
            let command3 = object["command3"] as! String
            let command4 = object["command4"] as! String
            
            print("ID:\(id), touchestype:\(touchestype), command1:\(command1), command2:\(command2), command3:\(command3), command4:\(command4)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.first?.tapCount == 1{
            Lb_Text.text = "シングルタップ"
            if(Flag_TV){
                Lb_Text.text = "テレビ　シングルタップ"
            }
            
        }else{
            Lb_Text.text = "ダブルタップ"
            
            if(Flag_TV){
                Lb_Text.text = "テレビ　ダブルタップ"
                
                let url: NSURL = NSURL(string: "http://163.221.132.156/Cats/api/user")!
                
                http_get(url, completionHandler: { data, response, error in
                    
                    let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.Lb_Text.text = result as String
                    })
                    
                })
                
            }
            
        }
    }
    
    func handleSwipeUp(sender: UITapGestureRecognizer){
        Lb_Text.text = "Swiped up!"
    }
    
    func handleSwipeDown(sender: UITapGestureRecognizer){
        Lb_Text.text = "Swiped down!"
    }
    
    func handleSwipeLeft(sender: UITapGestureRecognizer){
        Lb_Text.text = "Swiped left!"
    }
    
    func handleSwipeRight(sender: UITapGestureRecognizer){
        Lb_Text.text = "Swiped right!"
    }
    
    func http_get(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
    }


}

