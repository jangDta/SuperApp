//
//  AppRootRouter.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/22.
//

import ModernRIBs
import UIKit
import RIBsUtil
import FinanceHome
import AppHome
import ProfileHome

protocol AppRootInteractable: Interactable, AppHomeListener, FinanceHomeListener, ProfileHomeListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
    
    // TODO: Constructor inject child builder protocols to allow building children.
    private let appHome: AppHomeBuildable
    private let financeHome: FinanceHomeBuildable
    private let profileHome: ProfileHomeBuildable
    
    init(
        interactor: AppRootInteractable,
        viewController: AppRootViewControllable,
        appHome: AppHomeBuildable,
        financeHome: FinanceHomeBuildable,
        profileHome: ProfileHomeBuildable
    ) {
        self.appHome = appHome
        self.financeHome = financeHome
        self.profileHome = profileHome
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        // Child Router 추가
        let appHomeRouting = appHome.build(withListener: interactor)
        attachChild(appHomeRouting)
        
        let financeHomeRouting = financeHome.build(withListener: interactor)
        attachChild(financeHomeRouting)
        
        let profileHomeRouting = profileHome.build(withListener: interactor)
        attachChild(profileHomeRouting)
        
        // Child Router의 VC 추가
        let viewControllers = [
            NavigationControllable(root: appHomeRouting.viewControllable),
            NavigationControllable(root: financeHomeRouting.viewControllable),
            NavigationControllable(root: profileHomeRouting.viewControllable)
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}
