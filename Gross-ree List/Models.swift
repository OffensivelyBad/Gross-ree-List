//
//  Models.swift
//  Gross-ree List
//
//  Created by Shawn Roller on 1/27/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import Foundation

enum GroceryCategory {
    static let categories = [
        "Produce",
        "Meat",
        "Deli",
        "Seafood",
        "Beverage",
        "Breakfast",
        "Condiments",
        "Dairy",
        "Snacks",
        "Canned"
    ]
}

struct GroceryItem {
    var name: String
    var isChecked: Bool
    var sortOrder: Int
    var category: String
}

enum Constants {
    static let ListCellID = "Cell"
    static let ListSegueID = "listAddSegue"
}
