//
//  FinanceHomeRouter.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/23.
//

import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    private let superPayDashboard: SuperPayDashboardBuildable
    
    private var superPayRouting: Routing?
    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboard: SuperPayDashboardBuildable
    ) {
        self.superPayDashboard = superPayDashboard
        
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
        
        attachChild(router)
        superPayRouting = router
    }
}
