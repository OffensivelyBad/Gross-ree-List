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
        "Canned",
        "Frozen"
    ]
}

struct Category {
    
}

struct GroceryItem {
    var name: String
    var isChecked: Bool
    var sortOrder: Int
    var category: String
}



struct GroceryList<Element: Hashable> {
    private var contents: [Element: [GroceryItem]] = [:]
    var categoryCount: Int {
        return contents.count
    }
    var checkedCount: Int {
        var count = 0
        for content in contents {
            count += content.value.reduce(0) { $0 + ($1.isChecked ? 1 : 0) }
        }
        return count
    }
    var totalCount: Int {
        var count = 0
        for content in contents {
            count += content.value.count
        }
        return count
    }
    
    init() { }
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Element, value: [GroceryItem]) {
        for (category, items) in sequence {
            for item in items {
                add(category, item: item)
            }
        }
    }
    
    private func checkItemExists(_ item: GroceryItem, in category: Element) -> Bool {
        var exists = false
        
        // Get the category that the item should be in
        guard let content = contents[category] else {
            return exists
        }
        
        // Filter to the items that match the name
        let items = content.filter { $0.name == item.name }
        exists = items.count > 0
        
        return exists
    }
    
    mutating func reset() {
        var newList = GroceryList<Element>()
        for (_, items) in contents {
            for item in items {
                var newItem = item
                newItem.isChecked = false
                guard let element = newItem.category as? Element else { continue }
                newList.add(element, item: newItem)
            }
        }
        contents = newList.contents
    }
    
    mutating func add(_ category: Element, item: GroceryItem) {
        if let _ = contents[category] {
            // The category is already in the list. Add the item to the category
            contents[category]?.append(item)
        }
        else {
            // The category is not in the list. Add the category and item
            contents[category] = [item]
        }
    }
    
    mutating func remove(_ category: Element, item: GroceryItem) {
        guard checkItemExists(item, in: category), let contentCategory = contents[category] else { return }
        
        if contentCategory.count > 1 {
            // Remove the item from the category
            let newContent = contentCategory.filter { $0.name != item.name }
            contents[category] = newContent
        }
        else {
            // Remove the entire category
            contents.removeValue(forKey: category)
        }
    }
}

extension GroceryList: CustomStringConvertible {
    var description: String {
        return String(describing: contents)
    }
}

extension GroceryList: ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (Element, [GroceryItem])...) {
        self.init(elements.map { (key: $0.0, value: $0.1) })
    }
}

//extension GroceryList: Collection {
//    typealias Index = DictionaryIndex<Element, [GroceryItem]>
//    var startIndex: Index {
//        return contents.startIndex
//    }
//    var endIndex: Index {
//        return contents.endIndex
//    }
//    subscript (position: Index) -> Iterator.Element {
//        guard indices.contains(position) else { fatalError() }
//        let dictionaryElement = contents[position]
//        return (element: dictionaryElement.key, items: dictionaryElement.value)
//    }
//    func index(after i: Index) -> Index {
//        return contents.index(after: i)
//    }
//}

