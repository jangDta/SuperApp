//
//  TopupInteractor.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import ModernRIBs
import RIBsUtil
import FinanceEntity
import FinanceRepository
import CombineUtil
import UIUtil
import Topup

protocol TopupRouting: Routing {
    func cleanupViews()
    func attachAddPaymentMethod(dismissButtonType: DismissButtonType)
    func detachAddPaymentMethod()
    func attachEnterAmount()
    func detachEnterAmount()
    func attachCardOnFile(payments: [PaymentModel])
    func detachCardOnFile()
    func popToRoot()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var selectedPaymentStream: CurrentValuePublisher<PaymentModel> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    private let dependency: TopupInteractorDependency
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private var isEnterAmountRoot: Bool = false
    
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
            isEnterAmountRoot = true
            dependency.selectedPaymentStream.send(card)
            router?.attachEnterAmount()
        } else {
            // 카드 추가하기 RIB
            isEnterAmountRoot = false
            router?.attachAddPaymentMethod(dismissButtonType: .close)
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
    }
    
    // MARK: - AddPaymentMethod Listener
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        if isEnterAmountRoot == false {
            listener?.topupDidClose()
        }
    }
    
    func addPaymentMethodDidAddCard(_ model: PaymentModel) {
        // 카드 추가 후 잔액 충전으로 이동
        dependency.selectedPaymentStream.send(model)
        
        if isEnterAmountRoot {
            router?.popToRoot()
        } else {
            isEnterAmountRoot = true
            router?.attachEnterAmount()
        }
    }
    
    // MARK: - EnterAmount Listener
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        router?.attachCardOnFile(payments: payments)
    }
    
    func enterAmountDidFinishTopup() {
        listener?.topupDidFinish()
    }
    
    // MARK: - CardOnFile Listener
    
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        router?.attachAddPaymentMethod(dismissButtonType: .back)
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
