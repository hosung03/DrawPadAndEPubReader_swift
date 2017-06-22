//
//  ListHeaderView.swift
//  DrawPadAndEPubReader
//
//  Created by Hosung, Lee on 2017. 6. 13..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {
    private var vc : ViewController?
    public var title : UILabel?
    public var addButton : UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }
    
    func initialize() {
        title = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 50))
        title?.textColor = UIColor(hexString: "#018d01")
        self.addSubview(title!)

        addButton = UIButton(frame: CGRect(x: self.frame.size.width-100, y: 15, width: 90, height: 30))
        addButton?.backgroundColor = UIColor(hexString: "#006400")
        addButton?.setTitle("ADD", for: .normal)
        addButton?.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        addButton?.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.addSubview(addButton!)
    }
    
    func setVC(vc : ViewController){
        self.vc = vc
    }
    
    @objc private func buttonClicked() {
        print("clicked")
        if vc != nil {
            vc?.goDrawPadViewController(no: 0)
        }
    }
    
}
