//
//  ObjSvrSettingViewController.swift
//  DrawPadAndEPubReader_swift
//
//  Created by mac on 2017. 8. 8..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit
import Material

class ObjSvrSettingViewController: UIViewController {

    @IBOutlet weak var serveripTextField: TextField!
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var userpwTextField: TextField!
    @IBOutlet weak var saveBtn: RaisedButton!
    @IBOutlet weak var cancelBtn: RaisedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#018d01")
        
        prepareSvrIPField()
        prepareUserNameField()
        prepareUserPWField()
        prepareSaveButton()
        prepareCancelButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    @IBAction func clickSaveBtn(_ sender: RaisedButton) {
        ViewController.serverURL = serveripTextField.text!
        ViewController.realmID = usernameTextField.text!
        ViewController.realmPasswd = userpwTextField.text!
    }

    @IBAction func clickCancelBtn(_ sender: RaisedButton) {
        dismiss()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ObjSvrSettingViewController {
    fileprivate func prepareSvrIPField() {
        serveripTextField.delegate = self
        serveripTextField.textColor = Color.darkGray
        serveripTextField.placeholder = "Server IP"
        serveripTextField.placeholderActiveColor = Color.white
        serveripTextField.dividerActiveColor = Color.white
        serveripTextField.detail = ""
        serveripTextField.detailColor = Color.red
        serveripTextField.text = ViewController.serverURL
    }
    
    fileprivate func prepareUserNameField() {
        usernameTextField.delegate = self
        usernameTextField.textColor = Color.darkGray
        usernameTextField.placeholder = "User Name"
        usernameTextField.placeholderActiveColor = Color.white
        usernameTextField.dividerActiveColor = Color.white
        usernameTextField.detail = ""
        usernameTextField.detailColor = Color.red
        usernameTextField.text = ViewController.realmID
    }
    
    fileprivate func prepareUserPWField() {
        userpwTextField.delegate = self
        userpwTextField.textColor = Color.darkGray
        userpwTextField.placeholder = "User Password"
        userpwTextField.placeholderActiveColor = Color.white
        userpwTextField.dividerActiveColor = Color.white
        userpwTextField.detail = ""
        userpwTextField.detailColor = Color.red
        userpwTextField.isSecureTextEntry = true
        userpwTextField.text = ViewController.realmPasswd
    }

    fileprivate func prepareSaveButton() {
        saveBtn.backgroundColor = UIColor(hexString: "#006400")
        saveBtn.titleColor = Color.white
    }
    
    fileprivate func prepareCancelButton() {
        cancelBtn.backgroundColor = UIColor(hexString: "#017601")
        cancelBtn.titleColor = Color.white
    }
    
}
