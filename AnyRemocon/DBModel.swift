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
    
    // DB内データの最新6件を取得
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
    
    // touchestypeが一致する行のcommand1〜4を更新
    func update(data:DataModel) -> Bool{
        if let _ = SD.executeChange("UPDATE anyremocon SET command1=?,command2=?,command3=?,command4=? WHERE touchestype = ?", withArgs: [data.command1, data.command2, data.command3, data.command4, data.touchestype]) {
            //there was an error during the insert, handle it here
        } else {
            return false
        }
        return true
    }
    
    // 指定されたtouchestypeのデータを削除
    func delete(touchestype:String) -> Bool {
        if let _ = SD.executeChange("DELETE FROM anyremocon WHERE touchestype = ?", withArgs: [touchestype]) {
            //there was an error during the insert, handle it here
            return false
        } else {
            //no error, the row was inserted successfully
            return true
        }
    }
    
    // DB内すべてのデータを削除
    func deleteAll() -> Bool{
        if let _ = SD.executeChange("DELETE FROM anyremocon") {
            //there was an error during the insert, handle it here
            return false
        } else {
            //no error, the row was inserted successfully
            return true
        }
    }
    
}