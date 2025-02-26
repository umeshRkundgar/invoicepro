//
//  InvoiceViewModel.swift
//  SiyaInvoicePro
//
//  Created by Mac on 14/02/25.
//

import Foundation
import CoreData

class InvoiceViewModel {
    
    var allInvoices: [InvoiceItem] = []
    var isShowLoader: Bool = false
    weak var delegate: InvoiceViewModelDelegate?
    
    func fetchInvoices() {
        let request: NSFetchRequest<InvoiceEntity> = InvoiceEntity.fetchRequest()
        do {
            let fetchedInvoices = try CoreDataManager.shared.context.fetch(request)
            allInvoices = fetchedInvoices.map { InvoiceItem(name: $0.name ?? "", unitPrice: $0.unitPrice, quantity: Int($0.quantity)) }
            delegate?.didUpdateData()
        } catch {
            print("Error fetching invoices: \(error)")
        }
    }
    
    
    func addInvoice(name: String, unitPrice: String, quantity: String) -> (result: Bool, message: String) {
        let validationResult = self.validateInvoiceInputs(name: name, unitPrice: unitPrice, quantity: quantity)
        if validationResult.result == false {
            return (false, validationResult.message)
        } else {
            let invoice = InvoiceEntity(context: CoreDataManager.shared.context)
            invoice.name = name
            invoice.unitPrice = Double(unitPrice) ?? 0
            invoice.quantity = Int16(quantity) ?? 0
            
            CoreDataManager.shared.saveContext()
            
            isShowLoader = true
            fetchInvoices()
            isShowLoader = false
            self.delegate?.didUpdateData()
            
            return (true, "Invoice added successfully")
        }
    }
    
    func clearInvoices() {
        let request: NSFetchRequest<NSFetchRequestResult> = InvoiceEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try CoreDataManager.shared.context.execute(deleteRequest)
            CoreDataManager.shared.saveContext()
            
            
            isShowLoader = true
            allInvoices.removeAll()
            fetchInvoices()
            isShowLoader = false
            self.delegate?.didUpdateData()
        } catch {
            print("Error clearing invoices: \(error)")
        }
        
    }
    func deleteInvoice(at index: Int) {
        let invoiceItem = allInvoices[index]
        
        let fetchRequest: NSFetchRequest<InvoiceEntity> = InvoiceEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND unitPrice == %f AND quantity == %d", invoiceItem.name, invoiceItem.unitPrice, invoiceItem.quantity)
        
        do {
            let fetchedInvoices = try CoreDataManager.shared.context.fetch(fetchRequest)
            if let invoiceToDelete = fetchedInvoices.first {
                CoreDataManager.shared.context.delete(invoiceToDelete)
                CoreDataManager.shared.saveContext()
                fetchInvoices()
            }
        } catch {
            print("Error deleting invoice: \(error)")
        }
    }
    
    
    func getTotalQuantity() -> Int {
        allInvoices.reduce(0) { $0 + $1.quantity }
    }
    
    func getTotalBill() -> Double {
        Double(allInvoices.reduce(0) { $0 + $1.totalPrice })
    }
    
    func validateInvoiceInputs(name: String, unitPrice: String, quantity: String) -> (result: Bool, message: String) {
        if name.isEmpty || unitPrice.isEmpty || quantity.isEmpty {
            return (false, "Please fill all the fields.")
        }
        
        let unitPriceAllowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        if unitPrice.rangeOfCharacter(from: unitPriceAllowedCharacters.inverted) != nil {
            return (false, "Unit price should only contain numbers and decimal point.")
        }
        let quantityAllowedCharacters = CharacterSet(charactersIn: "0123456789")
        if quantity.rangeOfCharacter(from: quantityAllowedCharacters.inverted) != nil {
            return (false, "Quantity should only contain numbers.")
        }
        
        let quantity = Int(quantity) ?? 0
        
        if (quantity > 0 && quantity <= 99) {
            return (true, "")
        } else {
            return (false, "Quantity must be 1-99.")
        }
    }
}
