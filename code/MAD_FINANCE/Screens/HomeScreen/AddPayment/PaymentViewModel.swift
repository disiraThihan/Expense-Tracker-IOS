//
//  AddPaymentViewModel.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-12.
//

import Foundation
import Firebase

class PaymentViewModel {
    func addPayment(payment: Payment, completion: @escaping (Bool, Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "The user has not logged in."]))
            return
        }
        
        let db = Firestore.firestore()
        db.collection("payments").addDocument(data: [
            "userId": userId,
            "name": payment.name,
            "type": payment.type,
            "amount": payment.amount,
            "createdAt": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func fetchPayments(userId: String, completion: @escaping ([Payment]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("payments")
          .whereField("userId", isEqualTo: userId)
          .getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
            } else {
                var payments = [Payment]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let type = data["type"] as? String ?? ""
                    let amount = data["amount"] as? Double ?? 0.0
                    let payment = Payment(name: name, type: type, amount: amount)
                    payments.append(payment)
                }
                completion(payments, nil)
            }
        }
    }
    
    func editPayment(paymentId: String, updatedPayment: Payment, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        let paymentRef = db.collection("payments").document(paymentId)

        paymentRef.updateData([
            "name": updatedPayment.name,
            "type": updatedPayment.type,
            "amount": updatedPayment.amount
        ]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
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

    func deletePayment(paymentId: String, completion: @escaping (Bool, Error?) -> Void) {
            let db = Firestore.firestore()
            let paymentRef = db.collection("payments").document(paymentId)
            
            paymentRef.delete { error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
    }

}

