//
//  MAD_FINANCETests.swift
//  MAD_FINANCETests
//
//  Created by Disira Thihan on 2024-04-11.
//

import XCTest
import FirebaseCore
import FirebaseAuth
@testable import MAD_FINANCE

final class MAD_FINANCETests: XCTestCase {
    
    // MARK: - Mocking Firebase Services
       
       class MockPaymentViewModel: PaymentViewModel {
           var payments: [Payment]?
           var error: Error?
           override func fetchPayments(userId: String, completion: @escaping ([Payment]?, Error?) -> Void) {
               completion(payments, error)
           }
       }
       
       // MARK: - Test Cases
       
       func testFetchPayments_Success() {
           // Given
           let viewModel = HomeItemViewModel()
           let mockPaymentViewModel = MockPaymentViewModel()
           viewModel.paymentViewModel = mockPaymentViewModel
           let expectedPayments = [
               Payment(name: "Payment1", type: "Income", amount: 100.0),
               Payment(name: "Payment2", type: "Expense", amount: 50.0)
           ]
           mockPaymentViewModel.payments = expectedPayments
           
           // When
           viewModel.fetchPayments()
           
           // Then
           XCTAssertEqual(viewModel.payments, expectedPayments)
       }
       
       func testFetchPayments_Failure() {
           // Given
           let viewModel = HomeItemViewModel()
           let mockPaymentViewModel = MockPaymentViewModel()
           viewModel.paymentViewModel = mockPaymentViewModel
           let expectedError = NSError(domain: "Test", code: 500, userInfo: nil)
           mockPaymentViewModel.error = expectedError
           
           // When
           viewModel.fetchPayments()
           
           // Then
           XCTAssertTrue(viewModel.payments.isEmpty)
       }
    


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension Payment: Equatable {
    public static func ==(lhs: Payment, rhs: Payment) -> Bool {
        return lhs.name == rhs.name && lhs.type == rhs.type && lhs.amount == rhs.amount
    }
}
