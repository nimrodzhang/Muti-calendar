//
//  UIImageExtension.swift
//  Muti-calendar
//
//  Created by Apple on 2017/12/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

extension UIImage {
    func tintColor(color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect.init(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        //let context = UIGraphicsGetCurrentContext()
        //CGContextClipToMask(context, drawRect, CGImage)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
