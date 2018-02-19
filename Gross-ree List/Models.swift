//
//  Models.swift
//  Gross-ree List
//
//  Created by Shawn Roller on 1/27/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import Foundation

enum Constants {
    static let ListCellID = "Cell"
    static let ListSegueID = "listAddSegue"
}

enum Category {
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
        "Canned",
        "Frozen"
    ]
}

struct GroceryCategory {
    var name: String
    var items: [GroceryItem]
    var checkedCount: Int {
        return items.filter { $0.isChecked }.count
    }
    
    mutating func add(item: GroceryItem) {
        // Prevent duplicate items from being added
        let existingItems = items.filter { $0.name.uppercased() == item.name.uppercased() }
        if existingItems.count == 0 {
            items.append(item)
        }
    }
    
    mutating func remove(item: GroceryItem) {
        for (index, existingItem) in items.enumerated() {
            if item.name == existingItem.name {
                items.remove(at: index)
                break
            }
        }
    }
    
    mutating func checkOff(item: GroceryItem) {
        for (index, existingItem) in items.enumerated() {
            if item.name == existingItem.name {
                var newItem = item
                newItem.isChecked = true
                items[index] = newItem
                break
            }
        }
    }
}

struct GroceryItem {
    var name: String
    var isChecked: Bool
}

struct GroceryList {
    var contents: [GroceryCategory] = []
    var categoriesWithChecksCount: Int {
        var count = 0
        for content in contents {
            count += content.checkedCount > 0 ? 1 : 0
        }
        return count
    }

    mutating func add(item: GroceryItem, to category: String) {
        for (index, existingCategory) in contents.enumerated() {
            if existingCategory.name == category {
                // Add the new item to the existing category
                var newCategory = existingCategory
                newCategory.add(item: item)
                contents[index] = newCategory
                break
            }
        }
        // The category needs to be added
        let newCategory = GroceryCategory(name: category, items: [item])
        contents.append(newCategory)
    }
    
    mutating func remove(item: GroceryItem, from category: GroceryCategory) {
        for (index, existingCategory) in contents.enumerated() {
            if existingCategory.name == category.name {
                if existingCategory.items.count > 1 {
                    // Remove the item from the category
                    var newCategory = existingCategory
                    newCategory.remove(item: item)
                    contents[index] = newCategory
                }
                else {
                    // Remove the entire category
                    contents.remove(at: index)
                }
                break
            }
        }
    }
    
    // These functions should return index values so the tableview can be rearranged in an animated fashion
    mutating func checkOff(item: GroceryItem, in category: GroceryCategory) {
        // If the item is the first in the category to be checked:
            // If the category is the first on the list to have an item checked, move it to the first position in the contents array
            // Otherwise move the category to the position after the last category that has an item checked
            // Then move the item to the first position in the category
        // Otherwise the category position should remain the same
            // Move the item to the position after the last item that is checked in the category
        
        // Check the item off
        if category.checkedCount == 0 {
            if categoriesWithChecksCount == 0 {
                // Move the category to the first position in the array
                
            }
            else {
                // Move the category to the categoriesWithCheckCount index
            }
            // Move the item to the first position
        }
        else {
            // Move the item to the checkedCount position in the category
        }
    }
    
    mutating func unCheck(item: GroceryItem, in category: GroceryCategory) {
        // If no other items in the category are checked:
            // If the category is the only category on the list to have an item checked, keep the category positions the same
            // Otherwise, move the category to the position after the last category that has an item checked
            // The item should remain in the same position in the category
        // Otherwise the category position should remain the same
            // Move the item to the position after the last item that is checked in the category
        
        // Uncheck the item
        if category.checkedCount == 0 {
            if categoriesWithChecksCount > 0 {
                // Move the category to the categoriesWithCheckCount - 1 index
            }
        }
        else {
            // Move the item to the checkedCount - 1 index
        }
    }
    
}
