//
//  EnterAmountBuilder.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import ModernRIBs
import CombineUtil
import FinanceEntity

protocol EnterAmountDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    var selectedPayment: ReadOnlyCurrentValuePublisher<PaymentModel> { get }
    var superPayRepository: SuperPayRepository { get }
}

final class EnterAmountComponent: Component<EnterAmountDependency>, EnterAmountInteractorDependency {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    var selectedPayment: ReadOnlyCurrentValuePublisher<PaymentModel> { dependency.selectedPayment }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
}

// MARK: - Builder

protocol EnterAmountBuildable: Buildable {
    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting
}

final class EnterAmountBuilder: Builder<EnterAmountDependency>, EnterAmountBuildable {

    override init(dependency: EnterAmountDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
        let component = EnterAmountComponent(dependency: dependency)
        let viewController = EnterAmountViewController()
        let interactor = EnterAmountInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return EnterAmountRouter(interactor: interactor, viewController: viewController)
    }
}
