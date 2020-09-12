//
//  RGView.swift
//  RGDropdownTextfield
//
//  Created by Rishu Gupta on 12/09/20.
//  Copyright © 2020 Rishu Gupta. All rights reserved.
//

import UIKit

//MARK:- View with Customizable corners

@IBDesignable
class RGCornerView: UIView {
    
    //MARK:- Corner Layer Properties
    private var enabledCorners = CACornerMask()
    
    @IBInspectable
    public var bezelArcSize: CGFloat = 7.0 {
        didSet {
            updateCorners()
        }
    }
    
    @IBInspectable
    public var topLeftBezel: Bool = false {
        didSet {
            topLeftBezel ? addCorner(corner: .layerMinXMinYCorner) : removeCorner(corner: .layerMinXMinYCorner)
        }
    }
    
    @IBInspectable
    public var topRightBezel: Bool = true {
        didSet {
            topRightBezel ? addCorner(corner: .layerMaxXMinYCorner) : removeCorner(corner: .layerMaxXMinYCorner)
        }
    }
    
    @IBInspectable
    public var bottomLeftBezel: Bool = true {
        didSet {
            bottomLeftBezel ? addCorner(corner: .layerMinXMaxYCorner) : removeCorner(corner: .layerMinXMaxYCorner)
        }
    }
    
    @IBInspectable
    public var bottomRightBezel: Bool = false {
        didSet {
            bottomRightBezel ? addCorner(corner: .layerMaxXMaxYCorner) : removeCorner(corner: .layerMaxXMaxYCorner)
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable
    public var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var showShadow: Bool = false {
        didSet {
            self.addShadow(offset: CGSize(width: 1.0, height: 1.0), color: .black, opacity: 0.11, radius: 4.0)
        }
    }
    
        
    override func awakeFromNib() {
        // Setup Bottom-Border
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    public func commonInit() {
        //self.backgroundColor = Theme.Colors.BackgroundPrimary
        
        self.updateCorners()
    }
    
    
    // Setup Corner layer
    private func addCorner(corner: CACornerMask) {
        enabledCorners.formUnion(corner)
        updateCorners()
    }
    
    private func removeCorner(corner: CACornerMask) {
        enabledCorners.subtract(corner)
        updateCorners()
    }
    
    private func updateCorners() {
        self.layer.cornerRadius = bezelArcSize
        self.layer.maskedCorners = enabledCorners
        self.setNeedsDisplay()
    }
    
    override var bounds: CGRect {
        didSet {
            updateCorners()
        }
    }
    
}


extension UIView {
    func addShadow(offset: CGSize = CGSize.zero, color: UIColor = .black, opacity: Float = 0.11, radius: CGFloat = 10.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
