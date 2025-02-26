//
//  CommonFunctions.swift
//  SiyaInvoicePro
//
//  Created by Mac on 14/02/25.
//

import Foundation


//MARK: Public Functions
func asyncQueue(completion: @escaping(()->())) {
    DispatchQueue.main.async {
        completion()
    }
}

func asyncAfter(_ sec: Double = 1, completion: @escaping(()->())) {
    DispatchQueue.main.asyncAfter(deadline: .now() + sec) {
        completion()
    }
}
