//
//  TripInCellAnimator.swift
//  several levels
//
//  Created by Harrison McGuire on 6/24/16.
//  Copyright © 2016 severallevels. All rights reserved.
//


import UIKit
import QuartzCore

let TipInCellAnimatorStartTransform:CATransform3D = {
    let rotationDegrees: CGFloat = 0.0
    let rotationRadians: CGFloat = rotationDegrees * (CGFloat(M_PI)/180.0)
    let offset = CGPointMake(0, 100)
    var startTransform = CATransform3DIdentity
    startTransform = CATransform3DRotate(CATransform3DIdentity, rotationRadians, 0.0, 0.0, 1.0)
    startTransform = CATransform3DTranslate(startTransform, offset.x, offset.y, 0.0)
    
    return startTransform
}()

class TipInCellAnimator {
    class func animate(cell:UITableViewCell) {
        let view = cell.contentView
        
        view.layer.transform = TipInCellAnimatorStartTransform
        view.layer.opacity = 0.2
        
        UIView.animateWithDuration(1) {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        }
    }
}
