//
//  DropDownTableViewController.swift
//  RGDropdownTextfield
//
//  Created by Rishu Gupta on 08/08/20.
//  Copyright © 2020 Rishu Gupta. All rights reserved.
//

import UIKit

protocol DropDownTableProtocol: class {
    func popOverIsDismissed()
    func didSelectCell(currentIndex: Int, arrSelectedIndex: [Int], currentData: ListItem)
}

class DropDownTableViewController: UITableViewController {
        
    // MARK:- Variables
    var arrElement                      = [ListItem]()
    var arrSelectedIndex                = [Int]()
    
    var maxHeightForPopup: CGFloat      = 200.0
    var heightForRow: CGFloat           = 50.0
    var isMultiSelect                   = true
    var isDismissOnSelection            = true
    
    weak var delegate                   : DropDownTableProtocol?
    
    internal var isArrayOfString        = false
    private var contentSizeObserver     : NSKeyValueObservation?
        
    
    
    // MARK:- View LifeCycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contentSizeObserver = tableView.observe(\.contentSize) { [weak self] tableView, _ in
            guard let self = self else { return }
            
            let contentHeight = tableView.contentSize.height
            let height = contentHeight < self.maxHeightForPopup ? contentHeight : self.maxHeightForPopup
            self.preferredContentSize = CGSize(width: self.view.frame.width, height: height)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        delegate?.popOverIsDismissed()
        
        contentSizeObserver?.invalidate()
        contentSizeObserver = nil
    }
    
    
    
    // MARK:- Initial Setup
    private func initialSetup() {
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.tableFooterView   = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropdownCell")
    }
    
    
    // MARK:- Deinit
    deinit {
        tableView.removeFromSuperview()
        tableView = nil
        print("\(String(describing: self)) controller removed...")
    }
      

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrElement.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        
        // Set background color for selected cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.lightGray
        cell.selectedBackgroundView = backgroundView
        
        if arrElement.count > indexPath.row {
            cell.textLabel?.text = arrElement[indexPath.row].name
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrSelectedIndex.contains(indexPath.row) {
            arrSelectedIndex.removeAll(where: { $0 == indexPath.row })
        } else {
            if !isMultiSelect {
                arrSelectedIndex.removeAll()
            }
            arrSelectedIndex.append(indexPath.row)
        }
               
        if arrElement.count > indexPath.row {
            delegate?.didSelectCell(currentIndex: indexPath.row, arrSelectedIndex: arrSelectedIndex, currentData: arrElement[indexPath.row])
            if isDismissOnSelection {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
}
