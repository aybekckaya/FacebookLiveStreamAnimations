//
//  UIView+Constraints.swift
//  FacebookLiveStreamAnimations
//
//  Created by aybek can kaya on 27.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func addLengthConstraints(height:CGFloat? , width:CGFloat?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let height = height {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height).isActive = true
        }
        if let width = width {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width).isActive = true
        }
    }
    
    func addSnapConstraints(baseView:UIView , top:CGFloat? , bottom:CGFloat? , leading:CGFloat? , trailing:CGFloat?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: baseView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: top).isActive = true
        }
        if let bottom = bottom {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: baseView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: bottom).isActive = true
        }
        if let leading = leading {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: baseView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: leading).isActive = true
        }
        if let trailing = trailing {
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: baseView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: trailing).isActive = true
        }
    }
    
    
}
