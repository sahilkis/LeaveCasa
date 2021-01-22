//
//  UIButton+Extension.swift
//  T-Notebook
//
//  Created by Apple on 06/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ButtonWithImage: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 2, left: (bounds.width - 20), bottom: 2, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}

class UnderLineButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: self.titleLabel?.text ?? "", attributes: attrs)
        self.setAttributedTitle(attributeString, for: UIControl.State())
    }
}

class CircularButtonWithBorder: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}

class CircularButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
