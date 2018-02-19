//
//  AddViewController.swift
//  Gross-ree List
//
//  Created by Shawn Roller on 1/27/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit

protocol AddViewDelegate {
    func addItem(_ item: GroceryItem, category: String)
}

class AddViewController: UIViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var groceryItem: GroceryItem?
    var delegate: AddViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        categoryTextField.isUserInteractionEnabled = false
        categoryTextField.allowsEditingTextAttributes = false
        self.picker.delegate = self
        self.picker.dataSource = self

        guard let item = groceryItem else {
            self.categoryTextField.text = Category.categories.first ?? ""
            return
        }
        self.nameTextField.text = item.name
        self.categoryTextField.text = item.category
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss keyboard
        view.endEditing(true)
    }
    
    @IBAction private func addTapped(_ sender: Any) {
        guard self.nameTextField.text != "" else {
            showAlertWithMessage("Please enter a name!")
            return
        }
        
        let newItem = GroceryItem(name: self.nameTextField.text ?? "", isChecked: false, category: self.categoryTextField.text ?? "")
        self.delegate?.addItem(newItem, category: newItem.category)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: "Sorry!", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

}

extension AddViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard Category.categories.count > row else { fatalError("Selected grocery is out of range") }
        let selectedGrocery = Category.categories[row]
        categoryTextField.text = selectedGrocery
    }
    
}

extension AddViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard Category.categories.count > row else { fatalError("Selected grocery is out of range") }
        return Category.categories[row]
    }
    
}

extension AddViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
