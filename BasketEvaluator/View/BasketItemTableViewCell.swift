//
//  BasketItemTableViewCell.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 27/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import UIKit

/// The protocol which allows to get informed about amount changes via delegtion
protocol BasketItemTableViewCellDelegate: class {
    
    func basketItemTableViewCell(_ basketItemTableViewCell: BasketItemTableViewCell,
                                 didChangeAmountWithNewValue newValue: Int)
    
}

/// The BasketItemTableViewCell presents the basic basket item information in a cell.
class BasketItemTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: BasketItemTableViewCellDelegate?
    
    var basketItem: BasketItem?

    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountStepper: UIStepper!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    // MARK: - Actions
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        delegate?.basketItemTableViewCell(self, didChangeAmountWithNewValue: Int(sender.value))
    }
    
}
