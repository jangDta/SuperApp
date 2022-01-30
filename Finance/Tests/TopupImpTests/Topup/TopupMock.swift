//
//  TopupMock.swift
//  
//
//  Created by 장용범 on 2022/01/30.
//

import Foundation
import FinanceRepository
import FinanceRepositoryTestSupport
import Combine
import CombineUtil
import RIBsUtil
import UIUtil
import FinanceEntity
import ModernRIBs
import Topup
@testable import TopupImp

final class TopupDependencyMock: TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository = CardOnFileRepositoryMock()
    
    var selectedPaymentStream: CurrentValuePublisher<PaymentModel> = .init(
        PaymentModel(
            id: "", name: "", digits: "", color: "", isPrimary: false
        )
    )
}

final class TopupRoutingMock: TopupRouting {
    init(interactable: Interactable) {
        self.interactable = interactable
    }
    
    var cleanupViewsCallCount = 0
    func cleanupViews() {
        cleanupViewsCallCount += 1
    }
    
    var attachAddPaymentMethodCallCount = 0
    var attachAddPaymentMethodDismissButtonType: DismissButtonType?
    func attachAddPaymentMethod(dismissButtonType: DismissButtonType) {
        attachAddPaymentMethodCallCount += 1
        attachAddPaymentMethodDismissButtonType = dismissButtonType
    }
    
    var detachAddPaymentMethodCallCount = 0
    func detachAddPaymentMethod() {
        detachAddPaymentMethodCallCount += 1
    }
    
    var attachEnterAmountCallCount = 0
    func attachEnterAmount() {
        attachEnterAmountCallCount += 1
    }
    
    var detachEnterAmountCallCount = 0
    func detachEnterAmount() {
        detachEnterAmountCallCount += 1
    }
    
    var attachCardOnFileCallCount = 0
    var attachCardOnFilePayments: [PaymentModel]?
    func attachCardOnFile(payments: [PaymentModel]) {
        attachCardOnFileCallCount += 1
        attachCardOnFilePayments = payments
    }
    
    var detachCardOnFileCallCount = 0
    func detachCardOnFile() {
        detachCardOnFileCallCount += 1
    }
    
    var popToRootCallCount = 0
    func popToRoot() {
        popToRootCallCount += 1
    }
    
    var interactable: Interactable {
        didSet {
            interactableSetCallCount += 1
        }
    }
    var interactableSetCallCount = 0
    
    var children: [Routing] = [Routing]() {
        didSet {
            childrenSetCallCount += 1
        }
    }
    var childrenSetCallCount = 0
    
    var loadCallCount = 0
    var loadHandler: (() -> ())?
    func load() {
        loadCallCount += 1
        if let loadHandler = loadHandler {
            return loadHandler()
        }
    }
    
    var attachChildCallCount = 0
    var attachChildHandler: ((_ child: Routing) -> ())?
    func attachChild(_ child: Routing) {
        attachChildCallCount += 1
        if let attachChildHandler = attachChildHandler {
            return attachChildHandler(child)
        }
    }
    
    var detachChildCallCount = 0
    var detachChildHandler: ((_ child: Routing) -> ())?
    func detachChild(_ child: Routing) {
        detachChildCallCount += 1
        if let detachChildHandler = detachChildHandler {
            return detachChildHandler(child)
        }
    }
    
    var lifecycle: AnyPublisher<RouterLifecycle, Never> {
        lifecycleSubject.eraseToAnyPublisher()
    }
    var lifecycleSubject = PassthroughSubject<RouterLifecycle, Never>() {
        didSet {
            lifecycleSubjectSetCallCount += 1
        }
    }
    var lifecycleSubjectSetCallCount = 0
}

final class TopupInteractableMock: TopupInteractable {
    var router: TopupRouting?
    var listener: TopupListener?
    var presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    
    var addPaymentMethodDidTapCloseCallCount = 0
    func addPaymentMethodDidTapClose() {
        addPaymentMethodDidTapCloseCallCount += 1
    }
    
    var addPaymentMethodDidAddCardCallCount = 0
    var addPaymentMethodDidAddCardPaymentMethod: PaymentModel?
    func addPaymentMethodDidAddCard(_ model: PaymentModel) {
        addPaymentMethodDidAddCardCallCount += 1
        addPaymentMethodDidAddCardPaymentMethod = model
    }
    
    var enterAmountDidTapCloseCallCount = 0
    func enterAmountDidTapClose() {
        enterAmountDidTapCloseCallCount += 1
    }
    
    var enterAmountDidTapPaymentMethodCallCount = 0
    func enterAmountDidTapPaymentMethod() {
        enterAmountDidTapPaymentMethodCallCount += 1
    }
    
    var enterAmountDidFinishTopupCallCount = 0
    func enterAmountDidFinishTopup() {
        enterAmountDidFinishTopupCallCount += 1
    }
    
    var cardOnFileDidTapCloseCallCount = 0
    func cardOnFileDidTapClose() {
        cardOnFileDidTapCloseCallCount += 1
    }
    
    var cardOnFileDidTapAddCardCallCount = 0
    func cardOnFileDidTapAddCard() {
        cardOnFileDidTapAddCardCallCount += 1
    }
    
    var cardOnFileDidTapSelectCardCallCount = 0
    var cardOnFileDidTapSelectCardIndex: Int?
    func cardOnFileDidTapSelectCard(at index: Int) {
        cardOnFileDidTapSelectCardCallCount += 1
        cardOnFileDidTapSelectCardIndex = index
    }
    
    func activate() {
        
    }
    
    func deactivate() {
        
    }
    
    var isActive: Bool { isActiveSubject.value }
    var isActiveStream: AnyPublisher<Bool, Never> { isActiveSubject.eraseToAnyPublisher() }
    private let isActiveSubject = CurrentValueSubject<Bool, Never>(false)
}
