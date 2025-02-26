//
//  InvoiceItemCell.swift
//  SiyaInvoicePro
//
//  Created by Mac on 13/02/25.
//

import UIKit

class InvoiceItemCell: UITableViewCell {
    
    @IBOutlet var itemNameLabel: UILabel!
    
    @IBOutlet var unitPriceLabel: UILabel!
    
    @IBOutlet var totalPriceLabel: UILabel!
    static let identifier: String = "InvoiceItemCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.layer.borderWidth = 0
    }
    
    func configure(with item: InvoiceItem) {
        itemNameLabel.text = item.name.checkToShow()
        unitPriceLabel.text = "\(item.unitPrice.formatCurrency()) × \(item.quantity)".checkToShow()
        totalPriceLabel.text = item.totalPrice.formatCurrency().checkToShow()
    }
}
