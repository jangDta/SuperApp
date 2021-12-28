//
//  TopupInteractor.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
    func attachEnterAmount()
    func detachEnterAmount()
    func attachCardOnFile(payments: [PaymentModel])
    func detachCardOnFile()
}

protocol TopupListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func topupDidClose()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var selectedPaymentStream: CurrentValuePublisher<PaymentModel> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    
    private let dependency: TopupInteractorDependency
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private var payments: [PaymentModel] {
        dependency.cardOnFileRepository.cardOnFile.value
    }
    
    init(dependency: TopupInteractorDependency) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
            // 카드 충전하기 RIB
            dependency.selectedPaymentStream.send(card)
            router?.attachEnterAmount()
        } else {
            // 카드 추가하기 RIB
            router?.attachAddPaymentMethod()
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    // MARK: - AddPaymentMethod Listener
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(_ model: PaymentModel) {
        router?.detachAddPaymentMethod()
        listener?.topupDidClose()
    }
    
    // MARK: - EnterAmount Listener
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(payments: payments)
    }
    
    // MARK: - CardOnFile Listener
    
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        router?.attachAddPaymentMethod()
    }
    
    func cardOnFileDidTapSelectCard(at index: Int) {
        if let payment = payments[safe: index] {
            dependency.selectedPaymentStream.send(payment)
        }
        router?.detachCardOnFile()
    }
    
    // MARK: - AdaptivePresentationControllerDelegate
    
    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }
}
