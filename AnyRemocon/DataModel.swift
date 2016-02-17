//
//  DataModel.swift
//  AnyRemocon
//
//  Created by 守谷 一希 on 2016/02/18.
//  Copyright © 2016年 守谷 一希. All rights reserved.
//

import Foundation

class DataModel : NSObject {
    var touchestype:String
    var command1:String
    var command2:String
    var command3:String
    var command4:String
    
    init(touchestype:String, command1:String, command2:String, command3:String, command4:String){
        
        self.touchestype = touchestype
        self.command1 = command1
        self.command2 = command2
        self.command3 = command3
        self.command4 = command4
        
    }
    
}