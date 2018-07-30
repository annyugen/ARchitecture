//
//  CustomCell.swift
//  TableView
//
//  Created by Pham Lam on 7/28/18.
//  Copyright © 2018 Pham Lam. All rights reserved.
//

import Foundation
import UIKit

class CustomCellView : UITableViewCell{
    var message: String?
    var images: UIImage?
    
    var messageView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var imagesView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(imagesView)
        self.addSubview(messageView)
        
        imagesView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imagesView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imagesView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imagesView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imagesView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        messageView.leftAnchor.constraint(equalTo: imagesView.rightAnchor).isActive = true
        messageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        messageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if let message = message {
            messageView.text = message
        }
        if let image = images{
            imagesView.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
