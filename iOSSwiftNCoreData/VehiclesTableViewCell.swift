//
//  VehiclesTableViewCell.swift
//  iOSSwiftNCoreData
//
//  Created by iPramodSinghRawat on 14/03/18.
//  Copyright © 2018 iPramodSinghRawat. All rights reserved.
//

import UIKit

class VehiclesTableViewCell: UITableViewCell {

    @IBOutlet weak var typeTxtLbl: UILabel!
    
    @IBOutlet weak var brandTxtLbl: UILabel!
    @IBOutlet weak var modelTxtLbl: UILabel!
    
    @IBOutlet weak var engineCapacityTxtLbl: UILabel!
    
    @IBOutlet weak var contactImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
