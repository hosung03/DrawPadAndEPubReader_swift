//
//  ColorSelection.swift
//  DrawPadAndEPubReader_swift
//
//  Created by Hosung, Lee on 2017. 6. 26..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit

class ColorDialog: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var drawPadViewController: DrawPadViewController?
    
    @IBOutlet weak var colorCollectionView: UICollectionView!

    var colorList = ["#000000",
    "#2062af","#58AEB7","#F4B528","#DD3E48","#BF89AE",
    "#5C88BE","#59BC10","#E87034","#f84c44","#8c47fb",
    "#51C1EE","#8cc453","#C2987D","#CE7777","#9086BA"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.isOpaque = true

        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        colorCollectionView.borderColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickCloseBtn(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        
        cell.layer.cornerRadius = cell.frame.size.width / 2
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.masksToBounds = true
        
        cell.cellColor = UIColor(hexString: colorList[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
        if drawPadViewController != nil {
            drawPadViewController?.changeColor(color: (cell.cellColor)!)
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
