//
//  AddPaymentViewController.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-12.
//

import UIKit

class AddPaymentView: UIViewController {
    
    var selectedType: String?
    var viewModel = PaymentViewModel()
    var onDismiss: (() -> Void)?
    @IBOutlet weak var saveButtonUI: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var amountTxtFld: UITextField!
    @IBOutlet weak var paymentNameTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupBlurEffect()
        setupCancelButton()
        setupButtonUI()
        selectedType = "Income"
        updateUI()
        
        //for keyboard
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        
        let bottomSpace = self.view.frame.size.height - (amountTxtFld.frame.origin.y + amountTxtFld.frame.size.height)
        
      
        if keyboardSize.height > bottomSpace {
            self.view.frame.origin.y = 0 - keyboardSize.height + bottomSpace
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = 0
    }
    
    
    func setupButtonUI(){
        saveButtonUI.layer.cornerRadius = 15
        saveButtonUI.layer.masksToBounds = true
    }
    func setupCancelButton(){
        let closeButton = UIButton(frame: CGRect(x: 20, y: 50, width: 80, height: 40))
        closeButton.setTitle("Cancel", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        closeButton.setTitleColor(.incomeView, for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    @objc func closeTapped() {
        self.dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
        }
    }
    func setupBlurEffect(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let name = paymentNameTxtFld.text, !name.isEmpty,
              let amountText = amountTxtFld.text, let amount = Double(amountText),
              let type = selectedType else {
            makeAlert(title: "Error", message: "Please enter valid data.")
            return
        }
        
        let payment = Payment(name: name, type: type, amount: amount)
        

        viewModel.addPayment(payment: payment) { success, error in
            if success {
             
                self.dismiss(animated: true) { [weak self] in
          
                    self?.onDismiss?()
                }
            } else if let error = error {
            
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func inComeSelected(_ sender: Any) {
        selectedType = "Income"
        updateUI()
    }
    
    @IBAction func expenseSelected(_ sender: Any) {
        selectedType = "Expense"
        updateUI()
    }
    
    func updateUI() {
        let incomeButtonRadius: CGFloat = 15
        let expenseButtonRadius: CGFloat = 15
        
        let incomeButtonPath = UIBezierPath(roundedRect: incomeButton.bounds,
                                            byRoundingCorners: [.topLeft, .bottomLeft],
                                            cornerRadii: CGSize(width: incomeButtonRadius, height: incomeButtonRadius))
        let incomeButtonMaskLayer = CAShapeLayer()
        incomeButtonMaskLayer.path = incomeButtonPath.cgPath
        incomeButton.layer.mask = incomeButtonMaskLayer
        
       
        let expenseButtonPath = UIBezierPath(roundedRect: expenseButton.bounds,
                                             byRoundingCorners: [.topRight, .bottomRight],
                                             cornerRadii: CGSize(width: expenseButtonRadius, height: expenseButtonRadius))
        let expenseButtonMaskLayer = CAShapeLayer()
        expenseButtonMaskLayer.path = expenseButtonPath.cgPath
        expenseButton.layer.mask = expenseButtonMaskLayer
        
        if selectedType == "Income" {
            incomeButton.backgroundColor = .incomeView
            incomeButton.tintColor = .white
            expenseButton.backgroundColor = .white
            expenseButton.tintColor = .black
        } else if selectedType == "Expense" {
            expenseButton.backgroundColor = .incomeView
            expenseButton.tintColor = .white
            incomeButton.backgroundColor = .white
            incomeButton.tintColor = .black
        } else {
            incomeButton.backgroundColor = .white
            incomeButton.tintColor = .black
            expenseButton.backgroundColor = .white
            expenseButton.tintColor = .black
        }
    }

    func makeAlert(title: String, message: String, actionTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated:true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}



