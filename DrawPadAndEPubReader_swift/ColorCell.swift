//
//  ColorCell.swift
//  DrawPadAndEPubReader_swift
//
//  Created by Hosung, Lee on 2017. 6. 26..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    public var cellColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if cellColor != nil {
            let cellPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            self.cellColor?.setFill()
            cellPath.fill()
        }
    }
    
}
