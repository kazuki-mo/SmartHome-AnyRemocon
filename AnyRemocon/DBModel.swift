//
//  DBModel.swift
//  AnyRemocon
//
//  Created by 守谷 一希 on 2016/02/18.
//  Copyright © 2016年 守谷 一希. All rights reserved.
//

import Foundation

class DBModel {
    
    init() {
        let (tb, _) = SD.existingTables()
        if !tb.contains("anyremocon") {
            if let _ = SD.createTable("anyremocon", withColumnNamesAndTypes: ["touchestype": .StringVal,"command1":.StringVal,"command2":.StringVal,"command3":.StringVal,"command4":.StringVal]) {
                //there was an error during this function, handle it here
            } else {
                //no error, the table was created successfully
            }
            
            var data = DataModel(touchestype: "single", command1: "Nothing", command2: "Nothing", command3: "Nothing", command4: "Nothing")
            add(data)
            
            data = DataModel(touchestype: "double", command1: "Nothing", command2: "Nothing", command3: "Nothing", command4: "Nothing")
            add(data)
            
            data = DataModel(touchestype: "up", command1: "Nothing", command2: "Nothing", command3: "Nothing", command4: "Nothing")
            add(data)
            
            data = DataModel(touchestype: "down", command1: "Nothing", command2: "Nothing", command3: "Nothing", command4: "Nothing")
            add(data)
            
            data = DataModel(touchestype: "right", command1: "Nothing", command2: "Nothing", command3: "Nothing", command4: "Nothing")
            add(data)
            
            data = DataModel(touchestype: "left", command1: "Nothing", command2: "Nothing", command3: "Nothing", command4: "Nothing")
            add(data)
            
        }
        print(SD.databasePath())
    }
    
    // DBに挿入
    func add(data:DataModel)->Int{
        var result: Int? = nil
        if let _ = SD.executeChange("INSERT INTO anyremocon (touchestype,command1,command2,command3,command4) VALUES (?,?,?,?,?)", withArgs: [data.touchestype,data.command1,data.command2,data.command3,data.command4]) {
            //there was an error during the insert, handle it here
        } else {
            //no error, the row was inserted successfully
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                //err
            }else{
                //ok
                result = id
            }
        }
        return result!
    }
    
    // DB内データの最新10件を取得
    func getAll()->NSMutableArray {
        let result = NSMutableArray()
        let (resultSet, err) = SD.executeQuery("SELECT * FROM anyremocon ORDER BY ID DESC LIMiT 6")
        _ = NSDateFormatter()
        if err != nil {
            
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let touchestype = row["touchestype"]?.asString()!
                    let command1 = row["command1"]?.asString()!
                    let command2 = row["command2"]?.asString()!
                    let command3 = row["command3"]?.asString()!
                    let command4 = row["command4"]?.asString()!
                    let dic = ["ID":id,"touchestype":touchestype!,"command1":command1!,"command2":command2!,"command3":command3!,"command4":command4!]
                    result.addObject(dic)
                }
            }
        }
        return result
    }
    
    // DB内にあるSenStickのデバイス名とUUIDの一覧を取得
    func getDevices()->NSMutableArray {
        let result = NSMutableArray()
        let (resultSet, err) = SD.executeQuery("SELECT ID,devicename,uuid FROM meta_values")
        _ = NSDateFormatter()
        if err != nil {
        } else {
            for row in resultSet {
                if let _ = row["ID"]?.asInt() {
                    let devicename = row["devicename"]?.asString()!
                    let uuid = row["uuid"]?.asString()!
                    let dic = ["devicename":devicename!,"uuid":uuid!]
                    if (!result.containsObject(dic)){
                        result.addObject(dic)
                    }
                }
            }
        }
        return result
    }
    
    // 指定されたDevice名とUUIDに一致するメタデータをすべて取得
    func getFiles(devicename:String, uuid:String)->NSMutableArray {
        let result = NSMutableArray()
        let (resultSet, err) = SD.executeQuery("SELECT * FROM meta_values WHERE devicename=? and uuid=?", withArgs: [devicename,uuid])
        _ = NSDateFormatter()
        if err != nil {
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    let filename = row["filename"]?.asString()!
                    let devicename = row["devicename"]?.asString()!
                    let macaddress = row["macaddress"]?.asString()!
                    let uuid = row["uuid"]?.asString()!
                    let totaltime = row["totaltime"]?.asInt()!
                    let startdate = row["startdate"]?.asString()!
                    let sensortypes = row["sensortypes"]?.asString()!
                    let csvpath = row["csvpath"]?.asString()!
                    let csvsize = row["csvsize"]?.asString()!
                    let movpath = row["movpath"]?.asString()!
                    let movsize = row["movsize"]?.asString()!
                    let location = row["location"]?.asString()!
                    let dic = ["ID":id,"filename":filename!,"devicename":devicename!,"macaddress":macaddress!,"uuid":uuid!,"totaltime":totaltime!,"startdate":startdate!,"sensortypes":sensortypes!,"csvpath":csvpath!,"csvsize":csvsize!,"movpath":movpath!,"movsize":movsize!,"location":location!]
                    result.addObject(dic)
                }
            }
        }
        return result
    }
    
    // 指定されたIDのメタデータのFile名，Record総時間，Record開始時刻を更新
    func update(data:DataModel) -> Bool{
        if let _ = SD.executeChange("UPDATE anyremocon SET command1=?,command2=?,command3=?,command4=? WHERE touchestype = ?", withArgs: [data.command1, data.command2, data.command3, data.command4, data.touchestype]) {
            //there was an error during the insert, handle it here
        } else {
            return false
        }
        return true
    }
    
    // 指定されたIDのデータを削除
    func delete(id:Int) -> Bool {
        if let _ = SD.executeChange("DELETE FROM meta_values WHERE ID = ?", withArgs: [id]) {
            //there was an error during the insert, handle it here
            return false
        } else {
            //no error, the row was inserted successfully
            return true
        }
    }
    
    // DB内すべてのデータを削除
    func deleteAll() -> Bool{
        if let _ = SD.executeChange("DELETE FROM meta_values") {
            //there was an error during the insert, handle it here
            return false
        } else {
            //no error, the row was inserted successfully
            return true
        }
    }
    
    // startdateが空文字のデータ(挿入したばかりのデータ)のIDを取得
    func lastInsertId() -> Int{
        var result: Int? = nil
        let (resultSet, err) = SD.executeQuery("SELECT * FROM meta_values WHERE startdate = ''")
        if err != nil{
            result = 0
        }else{
            for row in resultSet {
                result = row["ID"]?.asInt()
            }
        }
        return result!
    }
    
}