//
//  UITextfield+Extension.swift
//  LeaveCasa
//
//  Created by Dinker Malhotra on 09/09/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    var isBlank: Bool {
        return (self.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var trimmedText: String {
        return (self.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return self.placeholderColor
        } set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    @IBInspectable var leftPadding: CGFloat {
        get {
            return self.leftPadding
        } set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
    
    func setRightAccessory(image: UIImage) {
        let accessory = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        accessory.image = image
        self.rightViewMode = .always
        self.rightView = accessory
    }
}
