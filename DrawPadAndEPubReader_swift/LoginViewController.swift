//
//  LoginViewController.swift
//  DrawPadAndEPubReader
//
//  Created by Hosung, Lee on 2017. 6. 7..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit
import Material
import RealmSwift
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwdTextField: TextField!
    @IBOutlet weak var btnLogin: RaisedButton!
    @IBOutlet weak var btnSignup: RaisedButton!
    @IBOutlet weak var btnServerSetting: RaisedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#018d01")
        
        // for test
        emailTextField.text = "test@localhost.io"
        passwdTextField.text = "1234"
        
        prepareEmailField()
        preparePasswordField()
        prepareLoginButton()
        prepareSignupButton()
        prepareSeverSettingButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func clickBtnLogin(_ sender: RaisedButton) {
        if(!ViewController.isSynced){
            btnLogin.isEnabled = false
            
            SVProgressHUD.show(withStatus: "Authenticating...")
            SVProgressHUD.setDefaultMaskType(.black)
            
            let credentials = SyncCredentials.usernamePassword(username: ViewController.realmID, password: ViewController.realmPasswd)
            SyncUser.logIn(with: credentials, server: ViewController.syncAuthURL , onCompletion: { (user, error) in
                if let user = user {
                    Realm.Configuration.defaultConfiguration = Realm.Configuration(
                        syncConfiguration: SyncConfiguration(user: user, realmURL: ViewController.syncServerURL),
                        objectTypes: [UserProfile.self, DrawNote.self, DrawPath.self, DrawPoint.self]
                    )
                    //print(Realm.Configuration.defaultConfiguration.description)
                    ViewController.isSynced = true
                    //ViewController.createInitialDataIfNeeded()
                    
                    SVProgressHUD.dismiss()
                    self.btnLogin.isEnabled = true
                    self.onLoginProcess()
                 } else if let error = error {
                    SVProgressHUD.dismiss()
                    self.btnLogin.isEnabled = true

                    ViewController.showAlert(viewcontroller: self, title: "Connection Error", message: "Realm Server Connection Error!!")
                    print(error.localizedDescription)
                }
            })
        } else {
            self.onLoginProcess()
        }
    }
    
    @IBAction func clickBtnSignup(_ sender: RaisedButton) {
        
    }
    
    @IBAction func clickBtnServerSetting(_ sender: RaisedButton) {
        
    }
    
    private func onLoginProcess() {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "email = %@", emailTextField.text!)
        let user = realm.objects(UserProfile.self).filter(predicate).first
        //print(realm.objects(UserProfile.self).count)

        if user != nil {
            if user?.passwd == passwdTextField.text! {
                DispatchQueue.main.async {
                    ViewController.userEmail = self.emailTextField.text!
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                ViewController.showAlert(viewcontroller: self, title: "Login Error", message: "Your password is wrong!")
            }
        } else {
            ViewController.showAlert(viewcontroller: self, title: "Login Error", message: "Your email address is wrong!")
        }
    }
    
}

extension LoginViewController {
    fileprivate func prepareEmailField() {
        emailTextField.delegate = self
        emailTextField.textColor = Color.darkGray
        emailTextField.placeholder = "Email"
        emailTextField.placeholderActiveColor = Color.white
        emailTextField.dividerActiveColor = Color.white
        emailTextField.detail = ""
        emailTextField.detailColor = Color.red
    }
    
    fileprivate func preparePasswordField() {
        passwdTextField.delegate = self
        passwdTextField.textColor = Color.darkGray
        passwdTextField.placeholder = "Password"
        passwdTextField.placeholderActiveColor = Color.white
        passwdTextField.dividerActiveColor = Color.white
        passwdTextField.detail = ""
        passwdTextField.detailColor = Color.red
        passwdTextField.isSecureTextEntry = true
    }
    
    fileprivate func prepareLoginButton() {
        btnLogin.backgroundColor = UIColor(hexString: "#006400")
        btnLogin.titleColor = Color.white
    }
    
    fileprivate func prepareSignupButton() {
        btnSignup.backgroundColor = UIColor(hexString: "#018d01")
        btnSignup.titleColor = Color.white
    }
    
    fileprivate func prepareSeverSettingButton() {
        btnServerSetting.backgroundColor = UIColor(hexString: "#018d01")
        btnServerSetting.titleColor = Color.white
    }
    
}

extension UIViewController: TextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = Color.white
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = Color.darkGray
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
