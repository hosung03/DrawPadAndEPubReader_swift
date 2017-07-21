//
//  PopoverViewController.swift
//  Popover Presentation
//
//  Created by Richard Allen on 12/26/15.
//  Copyright © 2015 SoftwareDad. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    var drawPadViewController: DrawPadViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickColorMenu(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        drawPadViewController?.callColorSectionDlg()
    }

    @IBAction func clickBrushSizeMenu(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        drawPadViewController?.callBrushSizeDlg()
    }
    
    @IBAction func clickImageBackMenu(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        drawPadViewController?.callBackImageDlg()
    }
 
    
    @IBAction func clickSaveMenu(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        drawPadViewController?.saveDrawNote()
    }

}
