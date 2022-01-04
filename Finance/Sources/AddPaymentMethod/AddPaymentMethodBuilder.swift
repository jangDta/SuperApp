//
//  AddPaymentMethodBuilder.swift
//  SuperApp
//
//  Created by 장용범 on 2021/12/26.
//

import ModernRIBs
import FinanceRepository
import RIBsUtil


public protocol AddPaymentMethodDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodComponent: Component<AddPaymentMethodDependency>, AddPaymentMethodInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
}

// MARK: - Builder

public protocol AddPaymentMethodBuildable: Buildable {
    func build(withListener listener: AddPaymentMethodListener, dismissButtonType: DismissButtonType) -> ViewableRouting
}

public final class AddPaymentMethodBuilder: Builder<AddPaymentMethodDependency>, AddPaymentMethodBuildable {

    public override init(dependency: AddPaymentMethodDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: AddPaymentMethodListener, dismissButtonType: DismissButtonType) -> ViewableRouting {
        let component = AddPaymentMethodComponent(dependency: dependency)
        let viewController = AddPaymentMethodViewController(dismissButtonType: dismissButtonType)
        let interactor = AddPaymentMethodInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return AddPaymentMethodRouter(interactor: interactor, viewController: viewController)
    }
}
