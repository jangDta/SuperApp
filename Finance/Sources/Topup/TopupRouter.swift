//
//  TopupRouter.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import ModernRIBs
import AddPaymentMethod
import UIUtil
import RIBsUtil
import FinanceEntity

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {

    private var navigationControllable: NavigationControllable?
    
    private let addPaymentMethod: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let enterAmount: EnterAmountBuildable
    private var enterAmountRouting: Routing?
    
    private let cardOnFile: CardOnFileBuildable
    private var cardOnFileRouting: Routing?

    init(
        interactor: TopupInteractable,
        viewController: ViewControllable,
        addPaymentMethod: AddPaymentMethodBuildable,
        enterAmount: EnterAmountBuildable,
        cardOnFile: CardOnFileBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethod = addPaymentMethod
        self.enterAmount = enterAmount
        self.cardOnFile = cardOnFile
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if viewController.uiviewController.presentedViewController != nil,
           navigationControllable != nil {
            navigationControllable?.dismiss(animated: true, completion: nil)
        }
    }
    
    func popToRoot() {
        navigationControllable?.popToRoot(animated: true)
        resetChildRouting()
    }
    
    func attachAddPaymentMethod(dismissButtonType: DismissButtonType) {
        if addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethod.build(withListener: interactor, dismissButtonType: dismissButtonType)
        
        if let navigation = navigationControllable {
            // 네비게이션 스택에 push
            navigation.pushViewController(router.viewControllable, animated: true)
        } else {
            presentInsideNavigation(router.viewControllable)
        }
        
        addPaymentMethodRouting = router
        attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouting else {
            return
        }
        
        navigationControllable?.popViewController(animated: true)
        
        detachChild(router)
        addPaymentMethodRouting = nil
    }
    
    func attachEnterAmount() {
        if enterAmountRouting != nil {
            return
        }
        
        let router = enterAmount.build(withListener: interactor)
        
        if let navigation = navigationControllable {
            // 네비게이션 스택을 날리고 띄우기
            navigation.setViewControllers([router.viewControllable])
            // 자식 Router들을 모두 끊어준다
            resetChildRouting()
        } else {
            presentInsideNavigation(router.viewControllable)
        }
        
        enterAmountRouting = router
        attachChild(router)
    }
    
    func detachEnterAmount() {
        guard let router = enterAmountRouting else {
            return
        }
        
        dismissPresentedNavigation(completion: nil)
        
        detachChild(router)
        enterAmountRouting = nil
    }
    
    func attachCardOnFile(payments: [PaymentModel]) {
        if cardOnFileRouting != nil {
            return
        }
        
        let router = cardOnFile.build(
            withListener: interactor,
            payments: payments
        )
        
        navigationControllable?.pushViewController(router.viewControllable, animated: true)
        
        cardOnFileRouting = router
        attachChild(router)
    }
    
    func detachCardOnFile() {
        guard let router = cardOnFileRouting else {
            return
        }
        
        navigationControllable?.popViewController(animated: true)
        
        detachChild(router)
        cardOnFileRouting = nil
    }
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllable(root: viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.navigationControllable = navigation
        
        viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllable == nil {
            return
        }
        
        viewController.dismiss(animated: true, completion: nil)
        self.navigationControllable = nil
    }

    // MARK: - Private

    private let viewController: ViewControllable
    
    private func resetChildRouting() {
        if let cardOnFileRouting = cardOnFileRouting {
            detachChild(cardOnFileRouting)
            self.cardOnFileRouting = nil
        }
        
        if let addPaymentMethodRouting = addPaymentMethodRouting {
            detachChild(addPaymentMethodRouting)
            self.addPaymentMethodRouting = nil
        }
    }
}
