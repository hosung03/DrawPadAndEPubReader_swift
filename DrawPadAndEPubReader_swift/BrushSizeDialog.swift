//
//  BrushSizeDialog.swift
//  DrawPadAndEPubReader_swift
//
//  Created by Hosung, Lee on 2017. 7. 20..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit

class BrushSizeDialog: UIViewController {
    
    public var drawPadViewController: DrawPadViewController?
    public var brushSize : Float = 0.0

    @IBOutlet weak var brushSizeSlider: UISlider!
    @IBOutlet weak var brushSizeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.isOpaque = true
        
        brushSizeSlider.minimumValue = 0.0
        brushSizeSlider.maximumValue = 100.0
        brushSizeSlider.value = brushSize
    }

    @IBAction func changeBrushSize(_ sender: UISlider) {
        sender.value = roundf(sender.value)
        brushSize = sender.value
        brushSizeText.text = brushSize.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickCloseBtn(_ sender: UIButton) {
        if drawPadViewController != nil {
            drawPadViewController?.changeBrushSize(size: CGFloat(brushSize))
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
