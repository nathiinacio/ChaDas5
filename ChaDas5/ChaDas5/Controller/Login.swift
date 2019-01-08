//
//  Login.swift
//  ChaDas5
//
//  Created by Gabriela Szpilman on 29/11/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Login: UIViewController {
    
    //outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        
        let forgotPasswordAlert = UIAlertController(title: "Esqueceu sua senha?", message: "Digite seu e-mail de login abaixo:", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Digite seu e-mail"
        }
        forgotPasswordAlert.view.tintColor = UIColor.buttonPink
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Redefinir senha", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                //Make sure you execute the following code on the main queue
                DispatchQueue.main.async {
                    //Use "if let" to access the error, if it is non-nil
                    if let error = error {
                        let resetFailedAlert = UIAlertController(title: "Redefinir senha falhou", message: "Não existe nenhuma conta com este e-mail", preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        resetFailedAlert.view.tintColor = UIColor.buttonPink
                        self.present(resetFailedAlert, animated: true, completion: nil)
                    } else {
                        let resetEmailSentAlert = UIAlertController(title: "E-mail enviado com sucesso!", message: "Cheque seu e-mail para redefinir sua senha", preferredStyle: .alert)
                        resetEmailSentAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        resetEmailSentAlert.view.tintColor = UIColor.buttonPink
                        self.present(resetEmailSentAlert, animated: true, completion: nil)
                    }
                }
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
        
    }
    
    var activityView:UIActivityIndicatorView!
    
    //action
    @IBAction func dismissButton(_ sender: Any) {
        dismiss()
    }    
    @IBAction func loginButton(_ sender: Any) {
        handleSignIn()
       
    }
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        passwordTextField.isSecureTextEntry = true
        
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.color = UIColor.buttonPink
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = loginButton.center
        
        view.addSubview(activityView)
        
        emailTextField.delegate = self as? UITextFieldDelegate
        passwordTextField.delegate = self as? UITextFieldDelegate
        emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

        setLoginButton(enabled: false)
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
        //NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        loginButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - loginButton.frame.height / 2)
        activityView.center = loginButton.center
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let email = emailTextField.text
        let password = passwordTextField.text
        let formFilled = email != nil && email != "" && password != nil && password != ""
        setLoginButton(enabled: formFilled)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            handleSignIn()
            break
        default:
            break
        }
        return true
    }
    
    /**
     Enables or Disables the **continueButton**.
     */
    
    
    @objc func handleSignIn() {
        guard let email = emailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        
        setLoginButton(enabled: false)
        loginButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                //self.dismiss(animated: false, completion: nil)
                print ("Logado com sucesso!")
                
                let userID = UserManager.instance.currentUser?.uid
                let docRef = FBRef.db.collection("users").document(userID!)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data()
                        AppSettings.displayName = dataDescription!["username"] as? String
                    } else {
                        print("Document does not exist")
                    }
                }
                
                if Auth.auth().currentUser != nil {
                    self.performSegue(withIdentifier: "Feed", sender: self)
                }
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                
                self.resetForm()
            }
        }
    }
    
    func resetForm() {
        
        let tentarNovamente = UIAlertAction(title: "Tentar Novamente", style: .default, handler: { (action) -> Void in
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
        })
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .default ) { (action) -> Void in
            self.dismiss()
        }
        
        let alert = UIAlertController(title: "Erro ao Logar", message: nil, preferredStyle: .alert)
        alert.addAction(tentarNovamente)
        alert.addAction(cancelar)
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.buttonPink
        
        setLoginButton(enabled: true)
        loginButton.setTitle("Fazer Login", for: .normal)
        activityView.stopAnimating()
    }
    
    @objc private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func setLoginButton(enabled:Bool) {
        if enabled {
            loginButton.alpha = 1.0
            loginButton.isEnabled = true
        } else {
            loginButton.alpha = 0.5
            loginButton.isEnabled = false
        }
    }
    
}
