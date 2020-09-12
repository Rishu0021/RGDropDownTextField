//
//  ViewController.swift
//  RGDropdownTextfield
//
//  Created by Rishu Gupta on 08/08/20.
//  Copyright © 2020 Rishu Gupta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchTextfield: RGDropDownTextfield!
    @IBOutlet weak var textFieldDropdown: TextFieldDropdownSearch!
    
    let dataList = [ListItem(id: "1", name: "San Francisco"),
                    ListItem(id: "2", name: "New York"),
                    ListItem(id: "3", name: "San Jose"),
                    ListItem(id: "4", name: "Chicago"),
                    ListItem(id: "5", name: "Austin"),
                    ListItem(id: "6", name: "Seattle"),
                    ListItem(id: "7", name: "Los Angeles")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextfield.dataList = dataList
        self.textFieldDropdown.dataList = dataList
    }


}

