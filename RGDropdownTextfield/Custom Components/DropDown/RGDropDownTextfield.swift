//
//  RGDropDownTextfield.swift
//  RGDropdownTextfield
//
//  Created by Rishu Gupta on 08/08/20.
//  Copyright © 2020 Rishu Gupta. All rights reserved.
//

import UIKit

class RGDropDownTextfield: UITextField, UITextFieldDelegate {
        
    // MARK: Variables
    private var currentController           : UIViewController?
    
    /// DropDown Methods
    public var sourceView                   : UIView?
    public var sourceRect                   : CGRect?
    public var arrowDirection               : UIPopoverArrowDirection = .any
    var tableVC                             : DropDownTableViewController?
    
    /// TableView Methods
    public var maxHeightForPopup: CGFloat   = 200.0
    public var heightForRow: CGFloat        = 50.0
    public var isMultiSelect                = true
    public var isDismissOnSelection         = true
    public var dataList                     = [ListItem]()
    public var resultsList                  = [ListItem]()
    
    
    // Initialization
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    func commonInit() {
        self.delegate = self
    }
    
    
    // MARK: Internal Methods
    private func presentController(vc: UIViewController, delegate: UIViewController, isPopover: Bool) {
        //let navigationController = UINavigationController(rootViewController: vc)
        //vc.navigationItem.title = title
        let navigationController = vc
        navigationController.modalPresentationStyle = .popover
        if isPopover, let presentationController = navigationController.popoverPresentationController {
            presentationController.delegate = delegate
            presentationController.permittedArrowDirections = self.arrowDirection
            presentationController.sourceView = self.sourceView
            presentationController.sourceRect = self.sourceRect ?? self.sourceView?.bounds ?? CGRect(x: delegate.view.center.x, y: delegate.view.center.y, width: 180, height: 200)
        } else {
            let navbackBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backButtonPressed))
            currentController = vc
            vc.navigationItem.leftBarButtonItem = navbackBtn
        }
        delegate.present(navigationController, animated: true)
    }
    
    @objc private func backButtonPressed() {
        currentController?.dismiss(animated: true)
    }
    
    // MARK: Public Methods
    private func setupDropDown() {
        self.tableVC = nil
        self.tableVC = DropDownTableViewController()
    }

    
    private func showDropDown(delegate: UIViewController, arrSelectedIndex: [Int], arrElements: [ListItem], sourceView: UIView? = nil, sourceRect: CGRect? = nil, isPopOver: Bool = true) {
        
        self.setupDropDown()
        
        self.sourceView = sourceView
        //self.sourceRect = sourceRect
        guard let dropDownVC = self.tableVC else {
            print("--- Error while getting DropDownTableViewController ---")
            return
        }
        dropDownVC.arrElement               = arrElements
        dropDownVC.heightForRow             = heightForRow
        dropDownVC.isMultiSelect            = isMultiSelect
        dropDownVC.isDismissOnSelection     = isDismissOnSelection
        
        //dropDownVC.delegate                 = delegate as? DropDownTableProtocol
        dropDownVC.delegate               = self
        
        if let customSize = sourceRect?.size {
            dropDownVC.preferredContentSize = customSize
        }
        self.presentController(vc: dropDownVC, delegate: delegate, isPopover: isPopOver)
    }
    
    
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        if self.tableVC == nil {
            self.textFieldDidBeginEditing(self)
        }
        // // Filtering data
        guard let searchText = textField.text else { return }
        self.resultsList = []
        self.resultsList = self.dataList.filter({ (data) -> Bool in
            let tmp: NSString = data.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if (self.resultsList.isEmpty) {
            self.tableVC?.arrElement = self.dataList
        } else {
            self.tableVC?.arrElement = self.resultsList
        }
        self.tableVC?.tableView?.reloadData()
    }

    
    // MARK: TextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            
        guard let parent = self.parentViewController else { return }
        self.arrowDirection = [.up, .down]
        var popupframe = self.frame
        popupframe.size.height = self.maxHeightForPopup
        self.showDropDown(delegate: parent, arrSelectedIndex: [], arrElements: self.dataList, sourceView: self, sourceRect: popupframe, isPopOver: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        DispatchQueue.main.async {
            self.tableVC?.dismiss(animated: true)
        }
    }
    
}

// MARK :- Dismiss popover
extension RGDropDownTextfield: DropDownTableProtocol {
    func didSelectCell(currentIndex: Int, arrSelectedIndex: [Int], currentData: ListItem) {
        self.text = currentData.name
    }
    
    func popOverIsDismissed() {
        self.tableVC = nil
    }
}

// MARK:- Extension for UIPopoverPresentationControllerDelegate
extension UIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}



