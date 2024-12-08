//
//  WelcomeViewModel.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-12.
//

import Foundation
import UIKit
import Firebase

class WelcomeViewModel{
    weak var viewController: UIViewController?
    var email:String?
    var password:String?
    var onLoginSuccess:(()->Void)?
    var onLoginFailure:((Error)->Void)?
    var navigateToScreen: ((String) -> Void)?
    func loginUser() {
        guard let email = email, let password = password else {
            print("The email or password cannot be empty.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.onLoginFailure?(error)
                }
                return
            }
            
            guard authResult?.user != nil else {
                print("User information could not be obtained.")
                return
            }
            
            print("Login successful.")
            DispatchQueue.main.async {
                self?.onLoginSuccess?()
            }
        }
    }

    func toRegisterView(toWhere:String){
        viewController?.performSegue(withIdentifier: toWhere, sender: nil)
    }
}
