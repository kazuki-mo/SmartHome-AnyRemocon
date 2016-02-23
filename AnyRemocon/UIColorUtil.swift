//
//  UIColorUtil.swift
//  AnyRemocon
//
//  Created by 守谷 一希 on 2016/02/17.
//  Copyright © 2016年 守谷 一希. All rights reserved.
//

import UIKit

struct UIColorUtil {
    // ex. rgb(0x123456)
    static func rgb(rgbValue: UInt) -> UIColor{
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0,
            blue: CGFloat(rgbValue & 0x0000FF)/255.0,
            alpha: CGFloat(1.0)
        )
    }
}
