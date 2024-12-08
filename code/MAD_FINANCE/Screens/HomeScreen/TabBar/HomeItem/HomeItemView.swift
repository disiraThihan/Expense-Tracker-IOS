//
//  HomeViewController.swift
//  MAD_FINANCE
//
//  Created by Disira Thihan on 2024-04-12.
//

import UIKit

class HomeItemView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addCostButtonUI: UIButton!
    @IBOutlet weak var addCostLabel: UILabel!
    @IBOutlet weak var balanceViewUI: UIView!
    @IBOutlet weak var balanceMoneyLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var incomeViewUI: UIView!
    @IBOutlet weak var expenseViewUI: UIView!
    @IBOutlet weak var incomeExpenseView: UIView!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var expenseLbl: UILabel!
    
    var viewModel=HomeItemViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonsUI()
        setupView()
        setupTableUI()
        setupRoundedCornersForViews()
        viewModel.bindPaymentsToView = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.calculateTotalBalance(labelMoney: balanceMoneyLbl, labelIncome: incomeLbl, labelExpense: expenseLbl)
        
        viewModel.fetchPayments()

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? EditPaymentView, let paymentInfo = sender as? (payment: Payment, paymentId: String) {
            editVC.payment = paymentInfo.payment
            editVC.paymentId = paymentInfo.paymentId
            editVC.onDismiss = { [weak self] in
                self?.viewModel.fetchPayments()
                self?.viewModel.calculateTotalBalance(labelMoney: self!.balanceMoneyLbl, labelIncome: self!.incomeLbl, labelExpense: self!.expenseLbl)
            }
        }
    }

    @IBAction func addCostButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addPaymentVC = storyboard.instantiateViewController(withIdentifier: "AddPaymentView") as? AddPaymentView {
            addPaymentVC.modalPresentationStyle = .overFullScreen
            addPaymentVC.modalTransitionStyle = .crossDissolve
            addPaymentVC.onDismiss = { [weak self] in
                self?.viewModel.fetchPayments()
                self?.viewModel.calculateTotalBalance(labelMoney: self!.balanceMoneyLbl, labelIncome: self!.incomeLbl, labelExpense: self!.expenseLbl)
            }
            self.present(addPaymentVC, animated: true, completion: nil)
        }
    }
    
    func setupButtonsUI(){
        let buttons = [addCostButtonUI]
        
        for button in buttons {
            button?.layer.cornerRadius = 25
            button?.layer.masksToBounds = true
        }
    }
    func setupRoundedCornersForViews() {
        roundCorners(view: incomeViewUI, corners: [.topRight, .topLeft], radius: 10)
        roundCorners(view: expenseViewUI, corners: [.bottomRight, .bottomLeft], radius: 10)
        incomeExpenseView.layer.cornerRadius=20
    }
    
    func roundCorners(view: UIView, corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    func setupView() {
        balanceViewUI.layer.cornerRadius = 15
        balanceViewUI.layer.masksToBounds = true
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
        
        let selectedPayment = viewModel.payments[indexPath.row]
        
        viewModel.fetchPaymentIdForPayment(payment: selectedPayment) { [weak self] paymentId in
            guard let self = self, let paymentId = paymentId else {
                print("Weak reference to self is nil or failed to fetch payment ID.")
                return
            }
            
            // Create a tuple containing both the payment and its ID
            let paymentInfo = (payment: selectedPayment, paymentId: paymentId)
            
            // Perform segue and pass the tuple as the sender
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "editPaymentSegue", sender: paymentInfo)
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        let payment = viewModel.payments[indexPath.row]
        content.text = payment.name
        content.secondaryText = "\(payment.type): \(payment.amount)"
        cell.contentConfiguration = content
        content.textProperties.color = .white
        content.secondaryTextProperties.color = .yellow
        
        if payment.type == "Expense" {
            content.image = UIImage(named: "expense")
        } else if payment.type == "Income" {
            content.image = UIImage(named: "income")
        }
        content.imageProperties.maximumSize = CGSize(width: 60, height: 60)
        content.imageProperties.cornerRadius = 30
        
        
        
        
        cell.contentConfiguration = content
        // Set cell background color and style
        cell.backgroundColor = .clear
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5) // Adjust opacity as needed
        backgroundView.layer.cornerRadius = 12
        backgroundView.layer.masksToBounds = true
        cell.backgroundView = backgroundView
        
        // Set cell selection style
        cell.selectionStyle = .none
        
      
        return cell
    }
    
    func setupBlurEffect(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
    // Adjust the gap between cells
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Adjust the separator inset to create a gap between cells
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 8 , right: 0) // Adjust the left and right insets as needed
    }
    
    func setupTableUI(){
        tableView.tintColor = .white
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

