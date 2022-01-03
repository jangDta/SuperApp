//
//  AddPaymentMethodInteractor.swift
//  SuperApp
//
//  Created by 장용범 on 2021/12/26.
//

import ModernRIBs
import Combine
import FinanceEntity

protocol AddPaymentMethodRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddPaymentMethodPresentable: Presentable {
    var listener: AddPaymentMethodPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol AddPaymentMethodListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func addPaymentMethodDidTapClose()
    func addPaymentMethodDidAddCard(_ model: PaymentModel)
}

protocol AddPaymentMethodInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable>, AddPaymentMethodInteractable, AddPaymentMethodPresentableListener {
    
    weak var router: AddPaymentMethodRouting?
    weak var listener: AddPaymentMethodListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    
    private let dependency: AddPaymentMethodInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: AddPaymentMethodPresentable,
        dependency: AddPaymentMethodInteractorDependency
    ) {
        self.dependency = dependency
        cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.addPaymentMethodDidTapClose()
    }
    
    func didConfirm(number: String, cvc: String, expiration: String) {
        let info = AddPaymentMethodInfo(
            number: number,
            cvc: cvc,
            expiration: expiration
        )
        
        dependency.cardOnFileRepository.addCard(info)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] model in
                    self?.listener?.addPaymentMethodDidAddCard(model)
                })
            .store(in: &cancellables)
        
    }
}
