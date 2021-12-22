//
//  AppRootRouter.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/22.
//

import ModernRIBs
import UIKit

protocol AppRootInteractable: Interactable {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    // TODO: Constructor inject child builder protocols to allow building children.
    override init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable
    ) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    func attachTabs() {
        // TODO: - attach child tabs from router
    }
}
