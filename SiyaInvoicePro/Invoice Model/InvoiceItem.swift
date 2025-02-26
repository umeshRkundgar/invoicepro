//
//  InvoiceItem.swift
//  SiyaInvoicePro
//
//  Created by Mac on 13/02/25.
//

import Foundation

struct InvoiceItem:Codable{
    var name: String
    var unitPrice: Double
    var quantity: Int
    var totalPrice: Double {
        return unitPrice * Double(quantity)
    }
}
