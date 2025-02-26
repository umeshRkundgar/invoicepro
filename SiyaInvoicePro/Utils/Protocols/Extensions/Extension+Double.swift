//
//  Extension+Double.swift
//  SiyaInvoicePro
//
//  Created by Mac on 14/02/25.
//

import Foundation

extension Double {
    
    func formatCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
