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

protocol FinanceHomeDependency: Dependency {
    var superPayRepository: SuperPayRepository { get }
    
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {
    
    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    
    var topupBaseViewController: ViewControllable
    
    init(
        dependency: FinanceHomeDependency,
        topupBaseViewController: ViewControllable
    ) {
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {

    override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
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
        let topup = TopupBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboard: superPayDashboard,
            cardOnFileDashboard: cardOnFileDasahboard,
            addPaymentMethod: addPaymentMethod,
            topup: topup
        )
    }
}
