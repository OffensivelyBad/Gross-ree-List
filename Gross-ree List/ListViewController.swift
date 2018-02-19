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
    
    private var groceryList = GroceryList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true
        
        //load test data
        let item1 = GroceryItem(name: "Cinnamon Toast Crunch", isChecked: false, category: "Breakfast")
        let item2 = GroceryItem(name: "Ribeye Steak", isChecked: false, category: "Meat")
        groceryList.add(item: item1, to: item1.category)
        groceryList.add(item: item2, to: item2.category)
        tableView.reloadData()
        
        updateItemsLabel()
    }
    
    private func updateItemsLabel() {
        let totalCount = self.groceryList.totalCount
        let checkedItemsCount = self.groceryList.checkedItemsCount
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
        guard groceryList.contents.count > indexPath.section && groceryList.contents[indexPath.section].items.count > indexPath.row else { fatalError("Out of index: section: \(indexPath.section), row: \(indexPath.row). GroceryList: \(groceryList)") }
        let item = groceryList.contents[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ListCellID, for: indexPath) as UITableViewCell
        cell.textLabel?.text = item.name
        let accessoryType = item.isChecked ? UITableViewCellAccessoryType.checkmark : .none
        cell.accessoryType = accessoryType
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard groceryList.contents.count > section else { return 0 }
        let contents = groceryList.contents[section]
        return contents.items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groceryList.contents.count
    }
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard groceryList.contents.count > indexPath.section && groceryList.contents[indexPath.section].items.count > indexPath.row else { fatalError("Out of index: section: \(indexPath.section), row: \(indexPath.row). GroceryList: \(groceryList)") }
        
        let category = groceryList.contents[indexPath.section]
        let item = groceryList.contents[indexPath.section].items[indexPath.row]
        
        guard !self.tableView.isEditing else {
            self.tableView.setEditing(false, animated: false)
            performSegue(withIdentifier: Constants.ListSegueID, sender: item)
            return
        }
        
        var currentCategoryIndex = 0
        var newCategoryIndex = 0
        var currentItemIndex = 0
        var newItemIndex = 0
        
        if item.isChecked {
            ((currentCategoryIndex: currentCategoryIndex, newCategoryIndex: newCategoryIndex), (currentItemIndex: currentItemIndex, newItemIndex: newItemIndex)) = groceryList.unCheck(item: item, in: category)
        }
        else {
            ((currentCategoryIndex: currentCategoryIndex, newCategoryIndex: newCategoryIndex), (currentItemIndex: currentItemIndex, newItemIndex: newItemIndex)) = groceryList.checkOff(item: item, in: category)
        }
        
        // Update the table view
        let fromIndexPath = IndexPath(row: currentItemIndex, section: currentCategoryIndex)
        let toIndexPath = IndexPath(row: newItemIndex, section: currentCategoryIndex)
        self.tableView.moveRow(at: fromIndexPath, to: toIndexPath)
        self.tableView.moveSection(currentCategoryIndex, toSection: newCategoryIndex)
        
        // Set the totals label
        self.updateItemsLabel()
    }
        

    
}

extension ListViewController: AddViewDelegate {
    
    func addItem(_ item: GroceryItem, category: String) {
        self.groceryList.add(item: item, to: category)
        tableView.reloadData()
    }
    
}
