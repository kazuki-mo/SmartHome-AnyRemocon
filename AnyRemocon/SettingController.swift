//
//  SettingController.swift
//  AnyRemocon
//
//  Created by 守谷 一希 on 2016/02/17.
//  Copyright © 2016年 守谷 一希. All rights reserved.
//

//import Cocoa
import UIKit

class SettingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dbModel = DBModel()
    var objects = NSMutableArray()
    var objects_single = NSMutableArray()
    var objects_double = NSMutableArray()
    var objects_up = NSMutableArray()
    var objects_down = NSMutableArray()
    var objects_right = NSMutableArray()
    var objects_left = NSMutableArray()
    
    var single_dic = NSMutableDictionary()
    var double_dic = NSMutableDictionary()
    var up_dic = NSMutableDictionary()
    var down_dic = NSMutableDictionary()
    var right_dic = NSMutableDictionary()
    var left_dic = NSMutableDictionary()
    
    @IBOutlet weak var Tv_Setting: UITableView!
    @IBAction func BT_Cancel(sender: AnyObject) {
        
        let myViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        myViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.navigationController?.pushViewController(myViewController, animated: true)
        
    }
    @IBAction func BT_Set(sender: AnyObject) {
        
        var data = DataModel(touchestype: "single", command1: single_dic["command1"] as! String, command2: single_dic["command2"] as! String, command3: single_dic["command3"] as! String, command4: single_dic["command4"] as! String)
        dbModel.update(data)
        
        data = DataModel(touchestype: "double", command1: double_dic["command1"] as! String, command2: double_dic["command2"] as! String, command3: double_dic["command3"] as! String, command4: double_dic["command4"] as! String)
        dbModel.update(data)
        
        data = DataModel(touchestype: "up", command1: up_dic["command1"] as! String, command2: up_dic["command2"] as! String, command3: up_dic["command3"] as! String, command4: up_dic["command4"] as! String)
        dbModel.update(data)
        
        data = DataModel(touchestype: "down", command1: down_dic["command1"] as! String, command2: down_dic["command2"] as! String, command3: down_dic["command3"] as! String, command4: down_dic["command4"] as! String)
        dbModel.update(data)
        
        data = DataModel(touchestype: "right", command1: right_dic["command1"] as! String, command2: right_dic["command2"] as! String, command3: right_dic["command3"] as! String, command4: right_dic["command4"] as! String)
        dbModel.update(data)
        
        data = DataModel(touchestype: "left", command1: left_dic["command1"] as! String, command2: left_dic["command2"] as! String, command3: left_dic["command3"] as! String, command4: left_dic["command4"] as! String)
        dbModel.update(data)
        
        let myViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        myViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.navigationController?.pushViewController(myViewController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        Tv_Setting.dataSource = self
        Tv_Setting.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Cellが選択された際に呼び出される.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 4 || indexPath.row == 9 || indexPath.row == 14 || indexPath.row == 19 || indexPath.row == 24){
            return
        }
        
        var value = ""
        
        let alert:UIAlertController = UIAlertController(title:"リモコン操作の設定",
            message: "設定するリモコン操作を選んで下さい",
            preferredStyle: UIAlertControllerStyle.Alert)
        presentViewController(alert, animated: true, completion: nil)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "キャンセル",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction) -> Void in
                print("キャンセルボタン")
        })
        
        let Nothing_Action:UIAlertAction = UIAlertAction(title: "なし",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "なし"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        let TV_Power_On_Action:UIAlertAction = UIAlertAction(title: "テレビ　電源ON",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "テレビ　電源ON"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        let TV_Power_Off_Action:UIAlertAction = UIAlertAction(title: "テレビ　電源OFF",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "テレビ　電源OFF"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        let TV_Ch_Up_Action:UIAlertAction = UIAlertAction(title: "テレビ　チャンネル↑",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "テレビ　チャンネル↑"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                //self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        let TV_Ch_Down_Action:UIAlertAction = UIAlertAction(title: "テレビ　チャンネル↓",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "テレビ　チャンネル↓"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                //self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        let Aircon_Power_On_Action:UIAlertAction = UIAlertAction(title: "エアコン　電源ON",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "エアコン　電源ON"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        let Aircon_Power_Off_Action:UIAlertAction = UIAlertAction(title: "エアコン　電源OFF",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "エアコン　電源OFF"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        let Light_Power_On_Action:UIAlertAction = UIAlertAction(title: "天井照明　電源ON",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "天井照明　電源ON"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        let Light_Power_Off_Action:UIAlertAction = UIAlertAction(title: "天井照明　電源OFF",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "天井照明　電源OFF"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        let AirClean_Power_On_Action:UIAlertAction = UIAlertAction(title: "空気清浄機　電源ON",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "空気清浄機　電源ON"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        let AirClean_Power_Off_Action:UIAlertAction = UIAlertAction(title: "空気清浄機　電源OFF",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in
                value = "空気清浄機　電源OFF"
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 0))?.detailTextLabel?.text = "\(value)"
                
                self.setDictionary(indexPath.row, value: self.changeName_Display("\(value)"))
        })
        
        
        alert.addAction(cancelAction)
        alert.addAction(Nothing_Action)
        alert.addAction(TV_Power_On_Action)
        alert.addAction(TV_Power_Off_Action)
        alert.addAction(TV_Ch_Up_Action)
        alert.addAction(TV_Ch_Down_Action)
        alert.addAction(Aircon_Power_On_Action)
        alert.addAction(Aircon_Power_Off_Action)
        alert.addAction(Light_Power_On_Action)
        alert.addAction(Light_Power_Off_Action)
        alert.addAction(AirClean_Power_On_Action)
        alert.addAction(AirClean_Power_Off_Action)
        
        self.navigationController?.pushViewController(alert, animated: true)
        
    }
    
    // Cellの総数を返す.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 29
        
    }
    
    // Cellに値を設定する.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = UITableViewCell()
        
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier:"SettingCell" )
        
        cell.backgroundColor = UIColor.clearColor()
        // Cellに値を設定.
        cell.textLabel!.sizeToFit()
        cell.textLabel!.textColor = UIColor.blackColor()
        if(indexPath.row == 0){
            cell.textLabel!.text = "シングルタップ　　　1"
            cell.detailTextLabel!.text = changeName_DB((single_dic["command1"] as? String)!)
        }else if(indexPath.row == 1){
            cell.textLabel!.text = "　　　　　　　　　　2"
            cell.detailTextLabel!.text = changeName_DB((single_dic["command2"] as? String)!)
        }else if(indexPath.row == 2){
            cell.textLabel!.text = "　　　　　　　　　　3"
            cell.detailTextLabel!.text = changeName_DB((single_dic["command3"] as? String)!)
        }else if(indexPath.row == 3){
            cell.textLabel!.text = "　　　　　　　　　　4"
            cell.detailTextLabel!.text = changeName_DB((single_dic["command4"] as? String)!)
        }else if(indexPath.row == 4){
            cell.textLabel!.text = ""
            cell.detailTextLabel!.text = ""
        }else if(indexPath.row == 5){
            cell.textLabel!.text = "ダブルタップ　　　　1"
            cell.detailTextLabel!.text = changeName_DB((double_dic["command1"] as? String)!)
        }else if(indexPath.row == 6){
            cell.textLabel!.text = "　　　　　　　　　　2"
            cell.detailTextLabel!.text = changeName_DB((double_dic["command2"] as? String)!)
        }else if(indexPath.row == 7){
            cell.textLabel!.text = "　　　　　　　　　　3"
            cell.detailTextLabel!.text = changeName_DB((double_dic["command3"] as? String)!)
        }else if(indexPath.row == 8){
            cell.textLabel!.text = "　　　　　　　　　　4"
            cell.detailTextLabel!.text = changeName_DB((double_dic["command4"] as? String)!)
        }else if(indexPath.row == 9){
            cell.textLabel!.text = ""
            cell.detailTextLabel!.text = ""
        }else if(indexPath.row == 10){
            cell.textLabel!.text = "上スワイプ　　　　　1"
            cell.detailTextLabel!.text = changeName_DB((up_dic["command1"] as? String)!)
        }else if(indexPath.row == 11){
            cell.textLabel!.text = "　　　　　　　　　　2"
            cell.detailTextLabel!.text = changeName_DB((up_dic["command2"] as? String)!)
        }else if(indexPath.row == 12){
            cell.textLabel!.text = "　　　　　　　　　　3"
            cell.detailTextLabel!.text = changeName_DB((up_dic["command3"] as? String)!)
        }else if(indexPath.row == 13){
            cell.textLabel!.text = "　　　　　　　　　　4"
            cell.detailTextLabel!.text = changeName_DB((up_dic["command4"] as? String)!)
        }else if(indexPath.row == 14){
            cell.textLabel!.text = ""
            cell.detailTextLabel!.text = ""
        }else if(indexPath.row == 15){
            cell.textLabel!.text = "下スワイプ　　　　　1"
            cell.detailTextLabel!.text = changeName_DB((down_dic["command1"] as? String)!)
        }else if(indexPath.row == 16){
            cell.textLabel!.text = "　　　　　　　　　　2"
            cell.detailTextLabel!.text = changeName_DB((down_dic["command2"] as? String)!)
        }else if(indexPath.row == 17){
            cell.textLabel!.text = "　　　　　　　　　　3"
            cell.detailTextLabel!.text = changeName_DB((down_dic["command3"] as? String)!)
        }else if(indexPath.row == 18){
            cell.textLabel!.text = "　　　　　　　　　　4"
            cell.detailTextLabel!.text = changeName_DB((down_dic["command4"] as? String)!)
        }else if(indexPath.row == 19){
            cell.textLabel!.text = ""
            cell.detailTextLabel!.text = ""
        }else if(indexPath.row == 20){
            cell.textLabel!.text = "右スワイプ　　　　　1"
            cell.detailTextLabel!.text = changeName_DB((right_dic["command1"] as? String)!)
        }else if(indexPath.row == 21){
            cell.textLabel!.text = "　　　　　　　　　　2"
            cell.detailTextLabel!.text = changeName_DB((right_dic["command2"] as? String)!)
        }else if(indexPath.row == 22){
            cell.textLabel!.text = "　　　　　　　　　　3"
            cell.detailTextLabel!.text = changeName_DB((right_dic["command3"] as? String)!)
        }else if(indexPath.row == 23){
            cell.textLabel!.text = "　　　　　　　　　　4"
            cell.detailTextLabel!.text = changeName_DB((right_dic["command4"] as? String)!)
        }else if(indexPath.row == 24){
            cell.textLabel!.text = ""
            cell.detailTextLabel!.text = ""
        }else if(indexPath.row == 25){
            cell.textLabel!.text = "左スワイプ　　　　　1"
            cell.detailTextLabel!.text = changeName_DB((left_dic["command1"] as? String)!)
        }else if(indexPath.row == 26){
            cell.textLabel!.text = "　　　　　　　　　　2"
            cell.detailTextLabel!.text = changeName_DB((left_dic["command2"] as? String)!)
        }else if(indexPath.row == 27){
            cell.textLabel!.text = "　　　　　　　　　　3"
            cell.detailTextLabel!.text = changeName_DB((left_dic["command3"] as? String)!)
        }else if(indexPath.row == 28){
            cell.textLabel!.text = "　　　　　　　　　　4"
            cell.detailTextLabel!.text = changeName_DB((left_dic["command4"] as? String)!)
        }
        cell.textLabel!.font = UIFont.systemFontOfSize(16)
        // Cellに値を設定(下).
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12)
        
        return cell
        
    }
    
    func setDictionary(row:Int, value:String){
        if(row == 0){
            self.single_dic.setValue(value, forKey: "command1")
        }else if(row == 1){
            self.single_dic.setValue(value, forKey: "command2")
        }else if(row == 2){
            self.single_dic.setValue(value, forKey: "command3")
        }else if(row == 3){
            self.single_dic.setValue(value, forKey: "command4")
        }else if(row == 5){
            self.double_dic.setValue(value, forKey: "command1")
        }else if(row == 6){
            self.double_dic.setValue(value, forKey: "command2")
        }else if(row == 7){
            self.double_dic.setValue(value, forKey: "command3")
        }else if(row == 8){
            self.double_dic.setValue(value, forKey: "command4")
        }else if(row == 10){
            self.up_dic.setValue(value, forKey: "command1")
        }else if(row == 11){
            self.up_dic.setValue(value, forKey: "command2")
        }else if(row == 12){
            self.up_dic.setValue(value, forKey: "command3")
        }else if(row == 13){
            self.up_dic.setValue(value, forKey: "command4")
        }else if(row == 15){
            self.down_dic.setValue(value, forKey: "command1")
        }else if(row == 16){
            self.down_dic.setValue(value, forKey: "command2")
        }else if(row == 17){
            self.down_dic.setValue(value, forKey: "command3")
        }else if(row == 18){
            self.down_dic.setValue(value, forKey: "command4")
        }else if(row == 20){
            self.right_dic.setValue(value, forKey: "command1")
        }else if(row == 21){
            self.right_dic.setValue(value, forKey: "command2")
        }else if(row == 22){
            self.right_dic.setValue(value, forKey: "command3")
        }else if(row == 23){
            self.right_dic.setValue(value, forKey: "command4")
        }else if(row == 25){
            self.left_dic.setValue(value, forKey: "command1")
        }else if(row == 26){
            self.left_dic.setValue(value, forKey: "command2")
        }else if(row == 27){
            self.left_dic.setValue(value, forKey: "command3")
        }else if(row == 28){
            self.left_dic.setValue(value, forKey: "command4")
        }
    }
    
    func changeName_DB(before:String) -> String{
        var after:String = ""
        
        if(before == "Nothing"){
            after = "なし"
        }else if(before == "TV_Power_On"){
            after = "テレビ　電源ON"
        }else if(before == "TV_Power_Off"){
            after = "テレビ　電源OFF"
        }else if(before == "Aircon_Power_On"){
            after = "エアコン　電源ON"
        }else if(before == "Aircon_Power_Off"){
            after = "エアコン　電源OFF"
        }else if(before == "Light_Power_On"){
            after = "天井照明　電源ON"
        }else if(before == "Light_Power_Off"){
            after = "天井照明　電源OFF"
        }else if(before == "AirClean_Power_On"){
            after = "空気清浄機　電源ON"
        }else if(before == "AirClean_Power_Off"){
            after = "空気清浄機　電源OFF"
        }
        
        return after
    }
    
    func changeName_Display(before:String) -> String{
        var after:String = ""
        
        if(before == "なし"){
            after = "Nothing"
        }else if(before == "テレビ　電源ON"){
            after = "TV_Power_On"
        }else if(before == "テレビ　電源OFF"){
            after = "TV_Power_Off"
        }else if(before == "エアコン　電源ON"){
            after = "Aircon_Power_On"
        }else if(before == "エアコン　電源OFF"){
            after = "Aircon_Power_Off"
        }else if(before == "天井照明　電源ON"){
            after = "Light_Power_On"
        }else if(before == "天井照明　電源OFF"){
            after = "Light_Power_Off"
        }else if(before == "空気清浄機　電源ON"){
            after = "AirClean_Power_On"
        }else if(before == "空気清浄機　電源OFF"){
            after = "AirClean_Power_Off"
        }
        
        return after
    }
}
