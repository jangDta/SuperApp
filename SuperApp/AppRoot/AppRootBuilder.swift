//
//  AppRootBuilder.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/22.
//

import ModernRIBs

protocol AppRootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but won't be
    // created by this RIB.
}

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
    func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler)
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {

    override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler) {
        let component = AppRootComponent(dependency: dependency)
        
        let tabBarController = AppRootTabBarController()
        
        let interactor = AppRootInteractor(presenter: tabBarController)
        
        let appHome = AppHomeBuilder(dependency: component)
        let financeHome = FinanceHomeBuilder(dependency: component)
        let profileHome = ProfileHomeBuilder(dependency: component)
        
        let router = AppRootRouter(
            interactor: interactor,
            viewController: tabBarController,
            appHome: appHome,
            financeHome: financeHome,
            profileHome: profileHome
        )
        return (router, interactor)
    }
}
