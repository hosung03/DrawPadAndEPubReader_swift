//
//  EPubRightMenuVC.swift
//  DrawPadAndEPubReader_swift
//
//  Created by mac on 2017. 7. 28..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit

protocol EPubRightMenuVCDelegate {
    func viewTOCList()
    func viewHighlightList()
    func viewFontSetting()
}

class EPubRightMenuVC: UIViewController {
    var delegate : EPubRightMenuVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickTOCBtn(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        if delegate != nil {
            delegate?.viewTOCList()
        }
    }

    @IBAction func clickHighlightListBtn(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        if delegate != nil {
            delegate?.viewHighlightList()
        }
    }
    
    @IBAction func clickFontBtn(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        if delegate != nil {
            delegate?.viewFontSetting()
        }
    }
    
}
