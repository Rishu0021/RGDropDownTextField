//
//  TextFieldDropdownSearch.swift
//  RGDropdownTextfield
//
//  Created by Rishu Gupta on 12/09/20.
//  Copyright © 2020 Rishu Gupta. All rights reserved.
//

import UIKit

// Drop down position
public enum Position {
    case top
    case bottom
}

public enum HeightStatus {
    case auto
    case manual
}


protocol DropDownDelegate: class {
    func didSelect(_ listName: String, _ index: Int)
    func didFilterList(_ filterList:[ListItem])
    func willOpen()
    func didLoad()
    func didClose()
    func show()
    func close()
}

class TextFieldDropdownSearch: VFTextFieldWithIconMedium {
        
    // MARK: Variables
    public weak var dropDownDelegate : DropDownDelegate?

    public var dataList = [ListItem]()
    private var resultsList = [ListItem]()
    private var viewDropDownContainer = RGCornerView()
    private var dropDownHeightConstant: NSLayoutConstraint?
    private var keyboardHeight: CGFloat?
    private var topLayerAlpha: CGFloat?
    private var contentSizeObserver: NSKeyValueObservation?
    
    // Configure
    public var parentView: UIView                               = UIView()
    public var alwaysOpen: Bool                                 = true
    public var isSearchEnable: Bool                             = false
    
    // Custom variable
    public var borderColor: UIColor                             = .clear
    public var cornerRadius: CGFloat                            = 7
    public var dropDownHeight: CGFloat                          = 180
    public var heightForRow: CGFloat                            = 46.0
    public var dropDownStatus: HeightStatus                     = .auto
    public var dropDownAnimation: UIView.AnimationOptions       = []
        
    fileprivate var tableView : UITableView! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    // Mark:- Private Methods
    private func create(position: Position = .bottom, positonAuto: Bool = true) {
        tableView = UITableView()
        viewDropDownContainer.tag = 99
        self.parentView.addSubview(viewDropDownContainer)
        viewDropDownContainer.addSubview(tableView)
        
        viewDropDownContainer.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        viewDropDownContainer.borderColor = borderColor
        viewDropDownContainer.bezelArcSize = cornerRadius
        viewDropDownContainer.bottomLeftBezel = true
        viewDropDownContainer.bottomRightBezel = true
        viewDropDownContainer.showShadow = true
        
        if isSearchEnable {
            self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        } else {
            self.resignFirstResponder()
        }
        
        // TableView setup
        self.setupTableView()
        
        //  Constraint Layout
        viewDropDownContainer.leftAnchor.constraint(equalTo:(self.leftAnchor), constant: 0).isActive = true
        viewDropDownContainer.rightAnchor.constraint(equalTo:(self.rightAnchor), constant: 0).isActive = true
        
        dropDownHeightConstant = viewDropDownContainer.heightAnchor.constraint(equalToConstant: 0)
        dropDownHeightConstant?.isActive = true
        
        tableView.topAnchor.constraint(equalTo: (viewDropDownContainer.topAnchor), constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: (viewDropDownContainer.leftAnchor), constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: (viewDropDownContainer.rightAnchor), constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: (viewDropDownContainer.bottomAnchor), constant: 0).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification,object: nil)
        
        self.dropDownPosition(position: position, positonAuto: positonAuto)
        
        
        guard let tableView = self.tableView else { return }
        contentSizeObserver = tableView.observe(\.contentSize) { [weak self] tableView, _ in
            guard let self = self else { return }
            let contentHeight = tableView.contentSize.height
            let height = contentHeight < self.dropDownHeightStatus() ? contentHeight : self.dropDownHeightStatus()
            self.dropDownHeightConstant?.constant = height
        }
        
    }
    
    private func dropDownPosition(position: Position, positonAuto: Bool) {
        var position = position
        if positonAuto == true {
            position = snapDropDownPosition()
        }
        
        switch position {
        case .top:
            viewDropDownContainer.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5).isActive = true
        case .bottom:
            viewDropDownContainer.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        }
    }
        
    private func snapDropDownPosition() -> Position {
        let myViewOriginY = self.frame.origin.y + self.frame.size.height + 5
        let myViewMaxY: CGFloat = 180
        let deviceMaxY = self.parentView.frame.size.height
        
        if myViewOriginY <= 0 {
            return Position.bottom
        } else if (myViewMaxY + myViewOriginY) >= deviceMaxY {
            return Position.top
        }
        return Position.bottom
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            
            self.dropDownHeightConstant?.constant = self.dropDownHeightStatus()
            self.parentView.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let _ : NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = 0
            
            self.dropDownHeightConstant?.constant = self.dropDownHeightStatus()
            self.parentView.layoutIfNeeded()
        }
    }
    
    private func dropDownHeightStatus() -> CGFloat {
        if dropDownStatus == .auto && snapDropDownPosition() == .bottom {
            let dropDownAutoHeight  = self.parentView.frame.size.height - (self.frame.origin.y) - self.frame.size.height - (keyboardHeight ?? 0)  - 15
            
            return dropDownAutoHeight
        } else {
            return dropDownHeight
        }
    }
    
    private func dropDownAnimation(status:Bool) {
        // Status : true -> Show || false -> Hide
        UIView.animate(withDuration: 0.3, delay:0, options: [dropDownAnimation], animations: {
            if status {
                self.dropDownDelegate?.willOpen()
                self.dropDownHeightConstant?.constant = self.dropDownHeightStatus()
                self.dropDownDelegate?.didLoad()
            } else {
                self.dropDownHeightConstant?.constant = 0
                self.dropDownDelegate?.didClose()
                self.dropDownHeightConstant?.isActive = false
            }
            self.parentView.layoutIfNeeded()
            self.viewDropDownContainer.layoutIfNeeded()
        })
    }
    
    
    private func hideAnimation() {
        if self.parentView.viewWithTag(99) != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.parentView.viewWithTag(99)?.removeFromSuperview()
                self.contentSizeObserver?.invalidate()
                self.contentSizeObserver = nil
            })
            self.parentView.endEditing(true)
            self.dropDownAnimation(status: false)
            
            if !self.resultsList.contains(where: { ($0.name.lowercased() == self.text?.lowercased() ?? "") }) {
                if self.resultsList.count > 0 {
                    self.text = self.resultsList.first?.name
                    self.dropDownDelegate?.didSelect(self.resultsList[0].name, 0)
                }
            }
        }
    }
    
    
    private func showDropDown() {
        guard let parent = self.parentViewController else { return }
        self.parentView = parent.view
        self.cornerRadius = 7
        self.create()
    }
    
    
    // MARK: TextField Delegate Methods
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if self.tableView == nil {
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
        
        if !self.resultsList.isEmpty {
            self.dropDownAnimation(status: true)
        } else {
            self.resultsList = self.dataList
            self.dropDownAnimation(status: alwaysOpen)
        }
        
        self.reloadTableView()
    }

    override func textFieldDidBeginEditing(_ textField: UITextField) {
        self.placeholderColor = Theme.Colors.TextPlaceholder
        self.hasError = false
        
        self.showDropDown()
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        self.placeholderColor = Theme.Colors.TextQuaternary
        self.hasError = false
        
        if isSearchEnable {
            self.hideAnimation()
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideAnimation()
        return true
    }
    
}

// MARK: TableView Delegate Methods
extension TextFieldDropdownSearch : UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        // TableView Configure
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        
        self.tableView.layer.cornerRadius = 7
        self.tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        
        self.resultsList = self.dataList
        self.reloadTableView()
    }
    
    private func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightForRow
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultsList.isEmpty {
            return 1
        }
        return self.resultsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = Theme.Colors.TextPrimary
        cell.textLabel?.font = Theme.getFont(style: .Regular, size: .Medium)
        
        if self.resultsList.isEmpty {
            cell.textLabel?.text = "No data available."
            return cell
        }
        
        // Set background color for selected cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = Theme.Colors.Selection
        cell.selectedBackgroundView = backgroundView
        
        if self.resultsList.indices.contains(indexPath.row) {
            let data = self.resultsList[indexPath.row]
            if let icon = data.icon {
                cell.imageView?.image = UIImage(named: icon)
            }
            cell.textLabel?.text = data.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resultsList.isEmpty {
            self.hideAnimation()
            return
        }
        if self.resultsList.indices.contains(indexPath.row) {
            let data = self.resultsList[indexPath.row]
            if let icon = data.icon {
                self.leftImage = UIImage(named: icon)
            }
            self.text = data.name
            
            self.dropDownDelegate?.didSelect(self.resultsList[indexPath.row].name, indexPath.row)
            self.dropDownDelegate?.didFilterList(self.resultsList)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.hideAnimation()
            }
        }
    }
    
}
