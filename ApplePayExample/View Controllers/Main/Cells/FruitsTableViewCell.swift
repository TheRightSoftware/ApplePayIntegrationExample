//
//  FruitsTableViewCell.swift
//  ApplePayExample
//
//  Created by Farrukh Javeid on 07/05/2019.
//  Copyright © 2019 The Right Software. All rights reserved.
//

import UIKit
import Kingfisher

class FruitsTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var fruitImageView: UIImageView!
    @IBOutlet weak var fruitNameLabel: UILabel!
    @IBOutlet weak var fruitPriceLabel: UILabel!
    
    //MARK:- Cell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Population
    func initCellWitFruit(fruit: Fruit) {
        
        let url = URL(string: fruit.image)
        fruitImageView.kf.setImage(with: url)
        fruitNameLabel.text = fruit.name
        fruitPriceLabel.text = String(format: "$ %d", fruit.price)
    }
}
