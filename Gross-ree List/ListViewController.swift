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
    
    private var groceryList = GroceryList<String>()
    
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
        groceryList.add(item1.category, item: item1)
        groceryList.add(item2.category, item: item2)
        tableView.reloadData()
        
        updateItemsLabel()
    }
    
    private func updateItemsLabel() {
        let totalCount = self.groceryList.totalCount
        let checkedItemsCount = self.groceryList.checkedCount
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
            self.groceryList.reset()
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
            
            if currentRow > newRow {
                self.tableView.performBatchUpdates({
                    let newIndexPath = IndexPath(row: newRow, section: 0)
                    groceryItems.remove(at: currentRow)
                    groceryItems.insert(groceryItem, at: newRow)
                    self.tableView.moveRow(at: indexPath, to: newIndexPath)
                }, completion: { (_) in
                    self.tableView.reloadData()
                })
            } else {
                groceryItems[currentRow] = groceryItem
                self.tableView.reloadData()
            }
            
        }
        else {
            
            groceryItem.sortOrder = -1
            newRow = checkedItemsCount - 1
            
            if currentRow == newRow {
                self.groceryItems[currentRow] = groceryItem
                self.tableView.reloadData()
            }
            else {
                self.tableView.performBatchUpdates({
                    let newIndexPath = IndexPath(row: newRow, section: 0)
                    self.tableView.moveRow(at: indexPath, to: newIndexPath)
                    groceryItems.remove(at: currentRow)
                    groceryItems.insert(groceryItem, at: newRow)
                }, completion: { (_) in
                    self.tableView.reloadData()
                })
            }
        }
        
        self.updateItemsLabel()
        
    }
        

    
}

extension ListViewController: AddViewDelegate {
    
    func addItem(_ item: GroceryItem) {
        self.groceryItems.append(item)
        tableView.reloadData()
    }
    
}
