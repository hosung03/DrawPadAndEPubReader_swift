//
//  SignupViewController.swift
//  DrawPadAndEPubReader_swift
//
//  Created by mac on 2017. 8. 8..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit
import Material
import RealmSwift
import SVProgressHUD

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwdTextField: TextField!
    @IBOutlet weak var repasswdTextField: TextField!
    @IBOutlet weak var btnSignup: RaisedButton!
    @IBOutlet weak var btnGoLogin: RaisedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#018d01")
        
        prepareNameField()
        prepareEmailField()
        preparePasswordField()
        prepareRePasswordField()
        prepareSignupButton()
        prepareGoLoginButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func clickBtnSignup(_ sender: RaisedButton) {
        if !validate()  {
            return
        }
        
        if ViewController.isSynced {
            self.onSignupProcess()
        } else {
            btnSignup.isEnabled = false
            
            SVProgressHUD.show(withStatus: "Authenticating...")
            SVProgressHUD.setDefaultMaskType(.black)
            
            let credentials = SyncCredentials.usernamePassword(username: ViewController.realmID, password: ViewController.realmPasswd)
            SyncUser.logIn(with: credentials, server: ViewController.syncAuthURL , onCompletion: { (user, error) in
                if let user = user {
                    Realm.Configuration.defaultConfiguration = Realm.Configuration(
                        syncConfiguration: SyncConfiguration(user: user, realmURL: ViewController.syncServerURL),
                        objectTypes: [UserProfile.self, DrawNote.self, DrawPath.self, DrawPoint.self, EPubHighLight.self]
                    )
                    //print(Realm.Configuration.defaultConfiguration.description)
                    ViewController.isSynced = true
                    //ViewController.createInitialDataIfNeeded()
                    
                    SVProgressHUD.dismiss()
                    self.btnSignup.isEnabled = true
                    self.onSignupProcess()
                } else if let error = error {
                    SVProgressHUD.dismiss()
                    self.btnSignup.isEnabled = true
                    
                    ViewController.showAlert(viewcontroller: self, title: "Connection Error", message: "Realm Server Connection Error!!")
                    print(error.localizedDescription)
                }
            })
        }
    }

    func validate() -> Bool {
        let name = nameTextField.text!
        if name.characters.count < 3 {
            nameTextField.becomeFirstResponder()
            ViewController.showAlert(viewcontroller: self, title: "aler", message: "Name must have at least 3 characters")
            return false
        }
        
        let email = emailTextField.text!
        if !email.isValidEmail() {
            emailTextField.becomeFirstResponder()
            ViewController.showAlert(viewcontroller: self, title: "aler", message: "Please enter a valid email address")
            return false
        }
        
        let password = passwdTextField.text!
        if password.characters.count < 4 || password.characters.count > 10 {
            ViewController.showAlert(viewcontroller: self, title: "aler", message: "Password must have between 4 and 10 alphanumeric characters")
            return false
        }
        
        let repassword = repasswdTextField.text!
        if password != repassword {
            ViewController.showAlert(viewcontroller: self, title: "aler", message: "RePassword  do not match with Password")
            return false
        }
        
        return true
    }
    
    private func onSignupProcess() {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "email = %@", emailTextField.text!)
        let user = realm.objects(UserProfile.self).filter(predicate).first
        
        if user == nil {
            let realm = try! Realm()
            try! realm.write {
                let userProfile = UserProfile()
                userProfile.id = realm.objects(UserProfile.self).max(ofProperty: "id")! + 1
                userProfile.name = nameTextField.text!
                userProfile.email = emailTextField.text!
                userProfile.passwd = passwdTextField.text!
                realm.add(userProfile)
            }
            
            dismiss()
        } else {
            ViewController.showAlert(viewcontroller: self, title: "Signup Error", message: "This email is in use!")
        }
    }
    
    @IBAction func clickBtnGoLogin(_ sender: RaisedButton) {
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

extension SignupViewController {
    fileprivate func prepareNameField() {
        nameTextField.delegate = self
        nameTextField.textColor = Color.darkGray
        nameTextField.placeholder = "Name"
        nameTextField.placeholderActiveColor = Color.white
        nameTextField.dividerActiveColor = Color.white
        nameTextField.detail = ""
        nameTextField.detailColor = Color.red
    }

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
    
    fileprivate func prepareRePasswordField() {
        repasswdTextField.delegate = self
        repasswdTextField.textColor = Color.darkGray
        repasswdTextField.placeholder = "RePassword"
        repasswdTextField.placeholderActiveColor = Color.white
        repasswdTextField.dividerActiveColor = Color.white
        repasswdTextField.detail = ""
        repasswdTextField.detailColor = Color.red
        repasswdTextField.isSecureTextEntry = true
    }
    
    fileprivate func prepareSignupButton() {
        btnSignup.backgroundColor = UIColor(hexString: "#006400")
        btnSignup.titleColor = Color.white
    }
    
    fileprivate func prepareGoLoginButton() {
        btnGoLogin.backgroundColor = UIColor(hexString: "#018d01")
        btnGoLogin.titleColor = Color.white
    }
    
}
