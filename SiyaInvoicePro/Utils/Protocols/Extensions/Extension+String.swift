//
//  Extension+String.swift
//  SiyaInvoicePro
//
//  Created by Mac on 14/02/25.
//

import Foundation

extension String {
    func checkToShow(_ defaultValue: String = "-") -> String {
        self.isEmpty ? defaultValue : self
    }
}
