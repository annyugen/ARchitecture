//
//  ObjectCell.swift
//  ARchitectureWithUI
//
//  Created by An Nguyen on 7/22/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit

class ObjectCell: UITableViewCell {

    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var objectLabel: UILabel!
    
    func setObject(object: Object) {
        objectImage.image = object.image
        objectLabel.text = object.label 
    }
}
