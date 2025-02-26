//
//  AddItemViewController.swift
//  SiyaInvoicePro
//
//  Created by Mac on 13/02/25.
//

import UIKit

class AddItemViewController: UIViewController{
    
    static let storyboardIdentifier = "AddItemViewController"
    var invoiceVM: InvoiceViewModel?
    
    @IBOutlet var itemNameTextField: UITextField!
    
    @IBOutlet var unitPriceTextField: UITextField!
    @IBOutlet var quantityTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    @IBAction func addItemButtonTapped(_ sender: UIButton) {
        let addInvoiceResult = self.invoiceVM?.addInvoice(name: itemNameTextField.text ?? "", unitPrice: unitPriceTextField.text ?? "", quantity: quantityTextField.text ?? "")
        
        if addInvoiceResult?.result ?? false {
            navigationController?.popViewController(animated: true)
        } else {
            self.showAlert(message: addInvoiceResult?.message ?? "Invalid Input")
        }
    }
}

//MARK: UITextFieldDelegate
//
extension AddItemViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//
//MARK: Private methods
//
private extension AddItemViewController {
    func initialSetup() {
        navigationItem.title = StringConstants.addItem
        
        itemNameTextField.delegate = self
        unitPriceTextField.delegate = self
        quantityTextField.delegate = self
        itemNameTextField.layer.cornerRadius = 15
        unitPriceTextField.layer.cornerRadius = 15
        quantityTextField.layer.cornerRadius = 15
        itemNameTextField.layer.borderWidth = 2
        unitPriceTextField.layer.borderWidth = 2
        quantityTextField.layer.borderWidth = 2
        itemNameTextField.layer.borderColor = UIColor.gray.cgColor
        unitPriceTextField.layer.borderColor = UIColor.gray.cgColor
        quantityTextField.layer.borderColor = UIColor.gray.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: StringConstants.invalidInput, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.okay, style: .default))
        present(alert, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
