//
//  ListViewController.swift
//  Gross-ree List
//
//  Created by Shawn Roller on 1/27/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    private var groceryItems = [GroceryItem]()
    private var checkedItemsCount: Int {
        return groceryItems.reduce(0) { $0 + ($1.isChecked ? 1 : 0) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true
        
        //load test data
        let item1 = GroceryItem(name: "Cinnamon Toast Crunch", isChecked: false, sortOrder: 0, category: "Breakfast")
        let item2 = GroceryItem(name: "Ribeye Steak", isChecked: false, sortOrder: 0, category: "Meat")
        groceryItems.append(contentsOf: [item1, item2])
        tableView.reloadData()
        
        updateItemsLabel()
    }
    
    private func updateItemsLabel() {
        let totalCount = groceryItems.count
        itemsLabel.text = "\(checkedItemsCount)/\(totalCount) Items"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddViewController {
            addVC.delegate = self
            if let groceryItem = sender as? GroceryItem {
                addVC.groceryItem = groceryItem
            }
        }
    }

    @IBAction func editTapped(_ sender: Any) {
        if tableView.isEditing {
            editButton.title = "Edit"
            tableView.setEditing(false, animated: true)
        }
        else {
            editButton.title = "Done"
            tableView.setEditing(true, animated: true)
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.ListSegueID, sender: nil)
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure?", message: "Do you want to reset the shopping list and start over?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let reset = UIAlertAction(title: "Reset", style: .destructive) { (action) in
            var newItems = [GroceryItem]()
            for item in self.groceryItems {
                var newItem = item
                newItem.isChecked = false
                newItems.append(newItem)
            }
            self.groceryItems = newItems
            self.tableView.reloadData()
            self.updateItemsLabel()
        }
        alert.addAction(cancel)
        alert.addAction(reset)
        present(alert, animated: true, completion: nil)
    }

}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < groceryItems.count else { fatalError("Grocery item \(indexPath.row) is out of range: \(groceryItems.count)") }
        let groceryItem = groceryItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ListCellID, for: indexPath) as UITableViewCell
        cell.textLabel?.text = groceryItem.name
        let accessoryType = groceryItem.isChecked ? UITableViewCellAccessoryType.checkmark : .none
        cell.accessoryType = accessoryType
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < groceryItems.count else { fatalError("Grocery item \(indexPath.row) is out of range: \(groceryItems.count)") }
        var groceryItem = groceryItems[indexPath.row]
        
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: false)
            performSegue(withIdentifier: Constants.ListSegueID, sender: groceryItem)
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.setSelected(false, animated: true)
        
        groceryItem.isChecked = !groceryItem.isChecked
        let currentRow = indexPath.row
        var newRow = checkedItemsCount
        
        if groceryItem.isChecked {
            if checkedItemsCount == currentRow {
                // Row should remain in the same position
                newRow = currentRow
            }
            groceryItem.sortOrder = newRow
            
            if currentRow != newRow {
                self.tableView.performBatchUpdates({
                    let newIndexPath = IndexPath(row: newRow, section: 0)
                    let oldItem = groceryItems[newRow]
                    groceryItems[indexPath.row] = oldItem
                    groceryItems[newRow] = groceryItem
                    self.tableView.moveRow(at: indexPath, to: newIndexPath)
                    self.updateItemsLabel()
                }, completion: nil)
            } else {
                groceryItems[currentRow] = groceryItem
                self.tableView.reloadData()
            }
            
        }
        else {
//            groceryItem.sortOrder = -1
//            groceryItems[currentRow] = groceryItem
//            if currentRow == newRow - 1 {
//                // The last checked item was unchecked. Row should remain in the same position
//                newRow = currentRow
//            }
//            if newRow >= groceryItems.count {
//                // Move the item to the last position
//                newRow = groceryItems.count - 1
//            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        groceryItem.isChecked = !groceryItem.isChecked
        var newRow = checkedItemsCount
        if checkedItemsCount >= groceryItems.count {
            newRow -= 1
        }
        var accessoryType = UITableViewCellAccessoryType.checkmark
        
        if groceryItem.isChecked {
            groceryItem.sortOrder = newRow
        }
        else {
            groceryItem.sortOrder = -1
            accessoryType = .none
            if indexPath.row == checkedItemsCount - 1 {
                newRow = indexPath.row
            }
        }
        
        cell.accessoryType = accessoryType
        
        tableView.performBatchUpdates({
            let newIndexPath = IndexPath(row: newRow, section: 0)
            let oldItem = groceryItems[newRow]
            groceryItems[indexPath.row] = oldItem
            groceryItems[newRow] = groceryItem
            self.tableView.moveRow(at: indexPath, to: newIndexPath)
            self.updateItemsLabel()
        }, completion: nil)
        
    }
    
}

extension ListViewController: AddViewDelegate {
    
    func addItem(_ item: GroceryItem) {
        self.groceryItems.append(item)
        tableView.reloadData()
    }
    
}
