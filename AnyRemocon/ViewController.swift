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
    
    var Flag_TV = false
    var Flag_Aircon = false
    var Flag_Light = false
    var Flag_AirClean = false
    var Flag_Remocon = false
    
    @IBOutlet weak var Lb_Text: UILabel!

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
    
    func http_get(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTaskWithRequest(request, completionHandler: completionHandler).resume()
    }


}

