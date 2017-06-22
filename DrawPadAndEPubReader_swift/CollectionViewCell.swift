//
//  ItemCollectionViewCell.swift
//  DrawPadAndEPubReader
//
//  Created by Hosung, Lee on 2017. 6. 7..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit
import Material

class CollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    
    fileprivate var titleBar = UILabel()
    fileprivate var cellContent = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellContent.frame = bounds
        cellContent.backgroundColor = UIColor.lightGray
        cellContent.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cellContent.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cellContent.addSubview(imageView)
        
        titleBar.lineBreakMode = .byWordWrapping
        titleBar.backgroundColor = UIColor.white
        titleBar.textColor = UIColor.black
        titleBar.numberOfLines = 0
        titleBar.font = UIFont(name: "Helvetica", size: 18)
        cellContent.addSubview(titleBar)
        
        cellContent.layer.cornerRadius = 2.0
        cellContent.layer.borderWidth = 1.0
        cellContent.layer.borderColor = UIColor.lightGray.cgColor
        cellContent.layer.masksToBounds = true
        
        cellContent.layer.shadowColor = UIColor.lightGray.cgColor
        cellContent.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cellContent.layer.shadowRadius = 2.0
        cellContent.layer.shadowOpacity = 1.0
        cellContent.layer.masksToBounds = false
//        cellContent.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cellContent.layer.cornerRadius).cgPath
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(cellContent)
        
        let imagePad: CGFloat = 25
        imageView.frame = CGRect(x: imagePad,
                                 y: imagePad - 5,
                                 width: self.frame.size.width - imagePad * 2,
                                 height: self.frame.size.height - imagePad * 3 + 5)
        titleBar.frame = CGRect(x: 0,
                            y: self.frame.size.height - 30,
                            width: self.frame.size.width,
                            height: 30)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func populateCell(_ title: String,
                      imageName: UIImage) {
        titleBar.text = "   " + title
        imageView.image = imageName
    }
    
}

