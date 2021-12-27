//
//  FinanceHomeBuilder.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/23.
//

import ModernRIBs

protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {
    
    var balance: ReadOnlyCurrentValuePublisher<Double> { balancePublisher }
    private let balancePublisher: CurrentValuePublisher<Double>
    
    let cardOnFileRepository: CardOnFileRepository
    
    var topupBaseViewController: ViewControllable
    
    init(
        dependency: FinanceHomeDependency,
        balancePublisher: CurrentValuePublisher<Double>,
        cardOnFileRepository: CardOnFileRepository,
        topupBaseViewController: ViewControllable
    ) {
        self.balancePublisher = balancePublisher
        self.cardOnFileRepository = cardOnFileRepository
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
        let balancePublisher = CurrentValuePublisher<Double>(1000)
        let viewController = FinanceHomeViewController()
        let component = FinanceHomeComponent(
            dependency: dependency,
            balancePublisher: balancePublisher,
            cardOnFileRepository: CardOnFileRepositoryImpl(),
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
