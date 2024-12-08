//
//  SettingViewController.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-12.
//

import UIKit

class SettingsItemView: UIViewController {
    
    @IBOutlet weak var logoutButtonUI: UIButton!
    @IBOutlet weak var useMainLabel: UILabel!
    @IBOutlet weak var factoryResetButtonUI: UIButton!
    var viewModel = SettingsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        useMainLabel.text = viewModel.getUserEmail()
        setupButtonUI()
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        signOutTapped()
    }
    
    func makeFactoryResetAlert() {
           let alert = UIAlertController(title: "Factory Reset", message: "Are you sure you want to delete all your data? This action cannot be undone.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
               self.viewModel.factoryReset { error in
                   DispatchQueue.main.async {
                       if let error = error {
                           self.makeAlert(title: "Error", message: error.localizedDescription)
                       } else {
                           self.makeAlert(title: "Success", message: "All data has been reset.")
                       }
                   }
               }
           }))
           present(alert, animated: true, completion: nil)
       }
    
    func setupButtonUI(){
        logoutButtonUI.layer.cornerRadius = 15
        logoutButtonUI.layer.masksToBounds = true
        logoutButtonUI.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        factoryResetButtonUI.layer.cornerRadius = 15
        factoryResetButtonUI.layer.masksToBounds = true
        factoryResetButtonUI.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    @IBAction func factoryResetButtonTapped(_ sender: Any) {
        makeFactoryResetAlert()
    }
    @objc func signOutTapped() {
        makeAlert(title: "Log Out", message: "Do you want exit this app ?")
    }
    
    func navigateToWelcomeView() {

        if let welcomeViewController = storyboard?.instantiateViewController(withIdentifier: "welcomeView") {
          
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                return
            }
            
           
            window.rootViewController = welcomeViewController
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: nil, completion: nil)
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.cancel, handler: { alert in
            self.viewModel.signOut { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Some error to trying exit: \(error.localizedDescription)")
                    } else {
                        guard let self = self else { return }
                        
                        self.navigateToWelcomeView()
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

