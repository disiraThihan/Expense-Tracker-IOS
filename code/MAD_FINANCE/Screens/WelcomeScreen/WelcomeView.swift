//
//  WelcomeViewController.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-12.
//

import UIKit

class WelcomeView: UIViewController {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginButtonUI: UIButton!
    
    var viewModel=WelcomeViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonUI()
        setupTextFieldsUI()
        setupBindings()
        setViewIdentifier()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTxtField.text, !email.isEmpty,
              let password = passwordTxtField.text, !password.isEmpty else {
            makeAlert(title:"Error", message: "Email or/and password cannot null.")
            return
        }
        viewModel.email = email
        viewModel.password = password
        viewModel.loginUser()
    }
    
    @IBAction func toRegisterButton(_ sender: Any) {
        viewModel.toRegisterView(toWhere: "toRegisterView")
    }
    
    
    func setViewIdentifier(){
        viewModel.navigateToScreen = { [weak self] screenIdentifier in
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: screenIdentifier, sender: nil)
            }
        }
    }
    func setupBindings(){
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.navigateToHomeView()
            }
        }
        viewModel.onLoginFailure = { [weak self] error in
            DispatchQueue.main.async {
                self?.makeAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func navigateToHomeView() {
        if let homeTabBarController = storyboard?.instantiateViewController(withIdentifier: "HomeView") as? UITabBarController {
            homeTabBarController.modalPresentationStyle = .fullScreen
            present(homeTabBarController, animated: true, completion: nil)
        }
    }
    
    func setupButtonUI() {
        loginButtonUI.layer.cornerRadius = 20
        loginButtonUI.layer.masksToBounds = true
    }
    func setupTextFieldsUI(){
        let textFields = [emailTxtField, passwordTxtField]
        
        for textField in textFields {
            textField?.layer.cornerRadius = 10
            textField?.layer.masksToBounds = true
            textField?.layer.borderWidth = 1.0
            textField?.layer.borderColor = UIColor(named: "TextFieldsBack")?.cgColor
            textField?.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField?.frame.height ?? 0))
            textField?.leftViewMode = .always
            textField?.translatesAutoresizingMaskIntoConstraints = false
            textField?.heightAnchor.constraint(equalToConstant: 50).isActive = true
            textField?.backgroundColor = .textFieldsBack
            if let placeholder = textField?.placeholder, let placeholderColor = UIColor(named: "PlaceholderColor") {
                textField?.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                      attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
            }
        }
    }
    func makeAlert(title: String, message: String, actionTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
