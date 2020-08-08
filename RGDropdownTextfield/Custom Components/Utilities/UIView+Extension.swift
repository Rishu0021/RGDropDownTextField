//
//  UIView+Extension.swift
//  RGDropdownTextfield
//
//  Created by Rishu Gupta on 08/08/20.
//  Copyright © 2020 Rishu Gupta. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
