//
//  FinanceHomeRouter.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/23.
//

import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    private let superPayDashboard: SuperPayDashboardBuildable
    private var superPayRouting: Routing?
    
    private let cardOnFileDashboard: CardOnFileDashboardBuildable
    private var cardOnFileRouting: Routing?
    
    private let addPaymentMethod: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboard: SuperPayDashboardBuildable,
        cardOnFileDashboard: CardOnFileDashboardBuildable,
        addPaymentMethod: AddPaymentMethodBuildable
    ) {
        self.superPayDashboard = superPayDashboard
        self.cardOnFileDashboard = cardOnFileDashboard
        self.addPaymentMethod = addPaymentMethod
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSuperPayDashboard() {
        if superPayRouting != nil {
            return
        }
        
        let router = superPayDashboard.build(withListener: interactor)
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        superPayRouting = router
        attachChild(router)
    }
    
    func attachCardOnFileDashboard() {
        if cardOnFileRouting != nil {
            return
        }
        
        let router = cardOnFileDashboard.build(withListener: interactor)
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
        
        cardOnFileRouting = router
        attachChild(router)
    }
    
    func attachAddPaymentMethod() {
        if addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethod.build(withListener: interactor)
        let navigationControllable = NavigationControllable(root: router.viewControllable)
        navigationControllable.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        viewControllable.present(navigationControllable, animated: true, completion: nil)
        
        addPaymentMethodRouting = router
        attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouting else {
            return
        }
        
        viewControllable.dismiss(animated: true, completion: nil)
        detachChild(router)
        addPaymentMethodRouting = nil
    }
}
