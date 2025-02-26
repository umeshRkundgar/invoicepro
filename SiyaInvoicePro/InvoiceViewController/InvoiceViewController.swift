//
//  InvoiceViewController.swift
//  SiyaInvoicePro
//
//  Created by Mac on 13/02/25.
//

import UIKit

class InvoiceViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var totalQuantityLabel: UILabel!
    
    @IBOutlet var totalBillLabel: UILabel!
    
    var invoiceVM: InvoiceViewModel = InvoiceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        invoiceVM.fetchInvoices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    //
    //MARK: Button Actions
    //
    @IBAction func addItemAction(_ sender: UIBarButtonItem) {
        if let AddItemViewController = storyboard?.instantiateViewController(withIdentifier: AddItemViewController.storyboardIdentifier) as? AddItemViewController {
            AddItemViewController.invoiceVM = self.invoiceVM
            navigationController?.pushViewController(AddItemViewController, animated: true)
        } else {
            LogService.printLog("Unable to instantiate AddItemViewController from Main.storyboard. Please check the Storyboard Identifier and ensure it matches the one set in the AddItem ViewController")
        }
    }
    
    @IBAction func clearInvoiceAction(_ sender: UIBarButtonItem) {
        self.invoiceVM.clearInvoices()
    }
}
//
//MARK: UITableViewDelegate & UITableViewDataSource
//
extension InvoiceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invoiceVM.allInvoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.invoiceVM.allInvoices.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: InvoiceItemCell.identifier) as? InvoiceItemCell {
                cell.backgroundColor = .clear
                cell.alpha = 1
                let item = self.invoiceVM.allInvoices[indexPath.row]
                cell.configure(with: item)
                cell.selectionStyle = .none
                return cell
            }
        } else {
            LogService.printLog("Index out of range: \(indexPath.row)")
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            invoiceVM.deleteInvoice(at: indexPath.row)
        }
    }
}
//
//MARK: InvoiceViewModelDelegate
//
extension InvoiceViewController: InvoiceViewModelDelegate {
    
    func didUpdateData() {
        asyncQueue {
            self.tableView.reloadData()
            self.totalQuantityLabel.text = "Quantity\n\(self.invoiceVM.getTotalQuantity())".checkToShow()
            self.totalBillLabel.text = "Total\n\(self.invoiceVM.getTotalBill().formatCurrency())".checkToShow()
        }
    }
}
//
//MARK: Private Methods
//
private extension InvoiceViewController {
    func initialSetup() {
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .gray
        addButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.addTarget(self, action: #selector(addItemAction(_:)), for: .touchUpInside)
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.backgroundColor = .clear
        clearButton.layer.cornerRadius = 15
        clearButton.layer.borderWidth = 1
        clearButton.layer.borderColor = UIColor.gray.cgColor
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        clearButton.addTarget(self, action: #selector(clearInvoiceAction(_:)), for: .touchUpInside)
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            clearButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            clearButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
            addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        } else {
            clearButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
            clearButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        let stackView = UIStackView(arrangedSubviews: [clearButton, addButton])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        
        let barButtonItem = UIBarButtonItem(customView: stackView)
        navigationItem.rightBarButtonItem = barButtonItem
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        invoiceVM.delegate = self
        LogService.printLog("Invoice Items Count: \(invoiceVM.allInvoices.count)")
        didUpdateData()
        
    }
}
