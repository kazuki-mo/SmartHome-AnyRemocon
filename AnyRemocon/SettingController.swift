//
//  SettingController.swift
//  AnyRemocon
//
//  Created by 守谷 一希 on 2016/02/17.
//  Copyright © 2016年 守谷 一希. All rights reserved.
//

//import Cocoa
import UIKit

class SettingController: UIViewController {

    @IBAction func BT_GoMain(sender: AnyObject) {
        
        let myViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        myViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.navigationController?.pushViewController(myViewController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
