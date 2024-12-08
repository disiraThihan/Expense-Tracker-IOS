//
//  EditPaymentView.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-18.
//

import UIKit

class EditPaymentView: UIViewController {

    var payment: Payment?
    var paymentId: String
    var viewModel = PaymentViewModel()
    var onDismiss: (() -> Void)?
    var selectedType: String?
    @IBOutlet weak var saveButtonUI: UIButton!
    @IBOutlet weak var cancleButtonUI: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var amountTxtFld: UITextField!
    @IBOutlet weak var paymentNameTxtFld: UITextField!
    @IBOutlet weak var deletePaymentButtonUI: UIButton!
    
    
    init(payment: Payment, paymentId: String) {
        self.payment = payment
        self.paymentId = paymentId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.payment = Payment(name: "", type: "", amount: 0.0)
        self.paymentId = ""
        super.init(coder: coder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBlurEffect()
    }
    
    func setupUI() {
        paymentNameTxtFld.text = payment?.name
        amountTxtFld.text = "\(payment?.amount ?? 0)"
        selectedType = payment?.type
        updateUI()
    }
    
    func setupBlurEffect() {
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
        
        let updatedPayment = Payment(name: name, type: type, amount: amount)
        
        viewModel.editPayment(paymentId: paymentId , updatedPayment: updatedPayment) { success, error in
            if success {
                self.dismiss(animated: true) {
                    self.onDismiss?()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        viewModel.deletePayment(paymentId: paymentId) { success, error in
            if success {
                self.dismiss(animated: true) {
                    self.onDismiss?()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
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
