//
//  EnterAmountInteractorTests.swift
//  SuperApp
//
//  Created by a60105114 on 2022/01/28.
//

@testable import TopupImp
import XCTest
import FinanceEntity
import FinanceRepositoryTestSupport

final class EnterAmountInteractorTests: XCTestCase {

    private var sut: EnterAmountInteractor!
    
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    private var listener: EnterAmountListenerMock!
    
    private var repository: SuperPayRepositoryMock! {
        dependency.superPayRepository as? SuperPayRepositoryMock
    }

    override func setUp() {
        super.setUp()
        
        presenter = EnterAmountPresentableMock()
        dependency = EnterAmountDependencyMock()
        listener = EnterAmountListenerMock()
        
        sut = EnterAmountInteractor(
            presenter: presenter,
            dependency: dependency
        )
        
        sut.listener = listener
    }

    // MARK: - Tests
    
    func test_activate() {
        // Given
        let paymentModel = PaymentModel(
            id: "id_0",
            name: "name_0",
            digits: "digits_0",
            color: "color_0",
            isPrimary: false
        )
        
        dependency.selectedPaymentSubject.send(paymentModel)
        
        // When
        sut.activate()
        
        // Then
        XCTAssertEqual(presenter.updateSelectedPaymentMethodCallCount, 1)
        XCTAssertEqual(presenter.updateSelectedPaymentMethodViewModel?.name, "name_0 digits_0")
    }
    
    func test_didTapTopup_with_Amount() {
        // Given
        let paymentModel = PaymentModel(
            id: "id_0",
            name: "name_0",
            digits: "digits_0",
            color: "color_0",
            isPrimary: false
        )
        
        dependency.selectedPaymentSubject.send(paymentModel)
        
        // When
        sut.didTapTopup(with: 1_000_000)
        
        // Then
        XCTAssertEqual(presenter.startLoadingCallCount, 1)
        XCTAssertEqual(presenter.stopLoadingCallCount, 1)
        XCTAssertEqual(repository.topupCallCount, 1)
        XCTAssertEqual(repository.topupAmount, 1_000_000)
        XCTAssertEqual(repository.topupPaymentMethodID, "id_0")
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 1)
    }
    
    func test_didTapTopup_fail() {
        // Given
        let paymentModel = PaymentModel(
            id: "id_0",
            name: "name_0",
            digits: "digits_0",
            color: "color_0",
            isPrimary: false
        )
        
        dependency.selectedPaymentSubject.send(paymentModel)
        repository.shouldTopupSucceed = false
        
        // When
        sut.didTapTopup(with: 1_000_000)
        
        // Then
        XCTAssertEqual(presenter.startLoadingCallCount, 1)
        XCTAssertEqual(presenter.stopLoadingCallCount, 1)
        XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 0)
    }
    
    func test_didTapClose() {
        // Given
        
        // When
        sut.didTapClose()
        
        // Then
        XCTAssertEqual(listener.enterAmountDidTapCloseCallCount, 1)
    }
    
    func test_didTapPaymentMethod() {
        // Given
        
        // When
        sut.didTapPaymentMethod()
        
        // Then
        XCTAssertEqual(listener.enterAmountDidTapPaymentMethodCallCount, 1)
    }
}
