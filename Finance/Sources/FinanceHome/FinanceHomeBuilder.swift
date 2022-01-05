//
//  FinanceHomeBuilder.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/23.
//

import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import Topup

public protocol FinanceHomeDependency: Dependency {
    var superPayRepository: SuperPayRepository { get }
    
    var cardOnFileRepository: CardOnFileRepository { get }
    
    var topupBuildable: TopupBuildable { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency {
    
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    
    var topupBaseViewController: ViewControllable
    
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
    
    init(
        dependency: FinanceHomeDependency,
        topupBaseViewController: ViewControllable
    ) {
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {

    public override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
        let viewController = FinanceHomeViewController()
        let component = FinanceHomeComponent(
            dependency: dependency,
            topupBaseViewController: viewController
        )
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashboard = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDasahboard = CardOnFileDashboardBuilder(dependency: component)
        let addPaymentMethod = AddPaymentMethodBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboard: superPayDashboard,
            cardOnFileDashboard: cardOnFileDasahboard,
            addPaymentMethod: addPaymentMethod,
            topup: component.topupBuildable
        )
    }
}
