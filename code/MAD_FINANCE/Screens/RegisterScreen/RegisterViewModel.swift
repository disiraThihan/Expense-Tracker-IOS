//
//  RegisterViewModel.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-12.
//

import Foundation
import UIKit
import Firebase
class RegisterViewModel{
    weak var viewController : UIViewController?
    var email:String?
    var password:String?
    var onCreateSuccess:(()->Void)?
    var onCreateFailure:((Error)->Void)?
    func createUser() {
        guard let email = email, let password = password else {
            print("Email or/and password cannot null")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                
                self?.onCreateFailure?(error)
                return
            }
            
            
            self?.onCreateSuccess?()
        }
    }
    func backButtonTapped(){
        viewController?.dismiss(animated: true, completion: nil)
    }
    
}
