//
//  PostalCodeCell.swift
//  WTest
//
//  Created by Carlos Correa on 08/03/2021.
//

import UIKit

final class PostalCodeCell: UITableViewCell {

    @IBOutlet private weak var lblPostalCode: UILabel!
    @IBOutlet private weak var lblDescription: UILabel!
    
    func prepareCell(with postalCode: PostalCode) {
        lblPostalCode.text = postalCode.postalCode + "-" + postalCode.extPostalCode
        lblDescription.text = postalCode.designatedPostal
    }
    
    func reuse() {
        lblPostalCode.text = nil
        lblDescription.text = nil
    }
    
}
