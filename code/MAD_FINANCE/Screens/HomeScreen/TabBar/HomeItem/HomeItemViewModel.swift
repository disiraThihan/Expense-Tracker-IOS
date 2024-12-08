//
//  HomeViewModel.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-12.
//

import Foundation
import Firebase
class HomeItemViewModel {
    
    var payments: [Payment] = [] {
        didSet {
            self.bindPaymentsToView()
        }
    }
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    var bindPaymentsToView: (() -> Void) = {}
    
    var paymentViewModel = PaymentViewModel()
    
    func fetchPayments() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User login has not been performed.")
            return
        }
        
        paymentViewModel.fetchPayments(userId: userId) { [weak self] (payments, error) in
            if let payments = payments {
                self?.payments = payments
            } else {
                print(error?.localizedDescription ?? "An error occurred")
            }
        }
    }
    
    func fetchPaymentIdForPayment(payment: Payment, completion: @escaping (String?) -> Void) {
            guard let userId = Auth.auth().currentUser?.uid else {
                completion(nil)
                return
            }

            let db = Firestore.firestore()
            db.collection("payments")
                .whereField("userId", isEqualTo: userId)
                .whereField("name", isEqualTo: payment.name)
                .whereField("type", isEqualTo: payment.type)
                .whereField("amount", isEqualTo: payment.amount)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error fetching payment ID: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        if let document = querySnapshot?.documents.first {
                            let paymentId = document.documentID
                            completion(paymentId)
                        } else {
                            print("Payment not found.")
                            completion(nil)
                        }
                    }
                }
        }

    func calculateTotalBalance(labelMoney: UILabel, labelIncome:UILabel, labelExpense:UILabel) {
           guard let userId = Auth.auth().currentUser?.uid else {
               print("User login is not performed.")
               return
           }

           let db = Firestore.firestore()
           db.collection("payments")
             .whereField("userId", isEqualTo: userId)
             .getDocuments { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   var totalBalance: Double = 0.0
                   var totalIncome:Double = 0.0
                   var totalExpense:Double = 0.0
                   for document in querySnapshot!.documents {
                       let data = document.data()
                       if let amount = data["amount"] as? Double, let type = data["type"] as? String {
                           if type == "Income" {
                               totalBalance += amount
                               totalIncome += amount
                           } else if type == "Expense" {
                               totalBalance -= amount
                               totalExpense += amount
                           }
                       }
                   }
                   
                   DispatchQueue.main.async {
                       labelMoney.text = "Rs.\(totalBalance)"
                       labelIncome.text = "Rs.\(totalIncome)"
                       labelExpense.text = "Rs.\(totalExpense)"
                   }
               }
           }
       }
    
    
}
