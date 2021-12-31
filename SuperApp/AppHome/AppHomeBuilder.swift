//
//  AppHomeBuilder.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/22.
//

import ModernRIBs

protocol AppHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppHomeComponent: Component<AppHomeDependency>, TransportHomeDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AppHomeBuildable: Buildable {
    func build(withListener listener: AppHomeListener) -> AppHomeRouting
}

final class AppHomeBuilder: Builder<AppHomeDependency>, AppHomeBuildable {

    override init(dependency: AppHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AppHomeListener) -> AppHomeRouting {
        let component = AppHomeComponent(dependency: dependency)
        let viewController = AppHomeViewController()
        let interactor = AppHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let transportHome = TransportHomeBuilder(dependency: component)
        
        return AppHomeRouter(
            interactor: interactor,
            viewController: viewController,
            transportHome: transportHome
        )
    }
}
