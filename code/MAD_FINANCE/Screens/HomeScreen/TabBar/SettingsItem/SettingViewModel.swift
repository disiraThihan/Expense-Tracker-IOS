//
//  SettingViewModel.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-12.
//

import Foundation
import Firebase
class SettingsViewModel{
    func signOut(completion: @escaping (Error?) -> Void) {
            do {
                try Auth.auth().signOut()
                completion(nil)
                print("Exit process")
            } catch let signOutError {
                completion(signOutError)
            }
        }
    func factoryReset(completion: @escaping (Error?) -> Void) {
           guard let userId = Auth.auth().currentUser?.uid else {
               completion(NSError(domain: "Cashier", code: 0, userInfo: [NSLocalizedDescriptionKey: "The user has not logged in."]))
               return
           }
           
           let db = Firestore.firestore()
           db.collection("payments").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
               guard let documents = snapshot?.documents else {
                   completion(error)
                   return
               }
               
               for document in documents {
                   db.collection("payments").document(document.documentID).delete { error in
                       if let error = error {
                           completion(error)
                           return
                       }
                   }
               }
               completion(nil) 
           }
       }
    
    func getUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
}
