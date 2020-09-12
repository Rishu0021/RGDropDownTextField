//
//  ListItem.swift
//  RGDropdownTextfield
//
//  Created by Rishu Gupta on 12/09/20.
//  Copyright © 2020 Rishu Gupta. All rights reserved.
//

import Foundation

struct ListItem {
    var id: String
    var name: String
    var icon: String?

    init(id: String, name: String, icon: String? = nil) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}
