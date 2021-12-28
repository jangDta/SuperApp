//
//  CardOnFileBuilder.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import ModernRIBs

protocol CardOnFileDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CardOnFileComponent: Component<CardOnFileDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CardOnFileBuildable: Buildable {
    func build(
        withListener listener: CardOnFileListener,
        payments: [PaymentModel]
    ) -> CardOnFileRouting
}

final class CardOnFileBuilder: Builder<CardOnFileDependency>, CardOnFileBuildable {

    override init(dependency: CardOnFileDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: CardOnFileListener,
        payments: [PaymentModel]
    ) -> CardOnFileRouting {
        let component = CardOnFileComponent(dependency: dependency)
        let viewController = CardOnFileViewController()
        let interactor = CardOnFileInteractor(
            presenter: viewController,
            payments: payments
        )
        interactor.listener = listener
        return CardOnFileRouter(interactor: interactor, viewController: viewController)
    }
}
