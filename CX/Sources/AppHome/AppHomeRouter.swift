//
//  AppHomeRouter.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/22.
//

import ModernRIBs
import TransportHome

protocol AppHomeInteractable: Interactable, TransportHomeListener {
    var router: AppHomeRouting? { get set }
    var listener: AppHomeListener? { get set }
}

protocol AppHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AppHomeRouter: ViewableRouter<AppHomeInteractable, AppHomeViewControllable>, AppHomeRouting {
    
    private let transportHome: TransportHomeBuildable
    private var transportHomeRouting: Routing?
    
    init(
        interactor: AppHomeInteractable,
        viewController: AppHomeViewControllable,
        transportHome: TransportHomeBuildable
    ) {
        self.transportHome = transportHome
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTransportHome() {
        if transportHomeRouting != nil {
            return
        }
        
        let router = transportHome.build(withListener: interactor)
        router.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        
        viewController.present(router.viewControllable, animated: true, completion: nil)
        attachChild(router)
        transportHomeRouting = router
    }
    
    func detachTransportHome() {
        guard let router = transportHomeRouting else {
            return
        }
        
        viewController.dismiss(animated: true, completion: nil)
        detachChild(router)
        self.transportHomeRouting = nil
    }
}
