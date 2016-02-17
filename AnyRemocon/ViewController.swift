//
//  ViewController.swift
//  AnyRemocon
//
//  Created by 守谷 一希 on 2016/02/17.
//  Copyright © 2016年 守谷 一希. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

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
        Im_TV.hidden = true
        Im_Aircon.hidden = true
        Im_Light.hidden = true
        Im_AirClean.hidden = true
        Im_Remocon.hidden = false
        BT_Setting.hidden = false
    }
    @IBAction func BT_AirClean(sender: AnyObject) {
        Im_TV.hidden = true
        Im_Aircon.hidden = true
        Im_Light.hidden = true
        Im_AirClean.hidden = false
        Im_Remocon.hidden = true
        BT_Setting.hidden = true
    }
    @IBAction func BT_Light(sender: AnyObject) {
        Im_TV.hidden = true
        Im_Aircon.hidden = true
        Im_Light.hidden = false
        Im_AirClean.hidden = true
        Im_Remocon.hidden = true
        BT_Setting.hidden = true
    }
    @IBAction func BT_Aircon(sender: AnyObject) {
        Im_TV.hidden = true
        Im_Aircon.hidden = false
        Im_Light.hidden = true
        Im_AirClean.hidden = true
        Im_Remocon.hidden = true
        BT_Setting.hidden = true
    }
    @IBAction func BT_TV(sender: AnyObject) {
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


}

