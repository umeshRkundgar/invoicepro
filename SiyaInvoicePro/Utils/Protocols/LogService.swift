//
//  LogService.swift
//  SiyaInvoicePro
//
//  Created by Mac on 14/02/25.
//

import Foundation

class LogService {
        
    static let isShowLogs = true
    
    static func printLog(_ log: String) {
        if isShowLogs {
            print(log)
        }
    }
    
}
