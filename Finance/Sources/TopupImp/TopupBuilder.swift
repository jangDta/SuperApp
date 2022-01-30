//
//  TopupBuilder.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import ModernRIBs
import FinanceRepository
import FinanceEntity
import AddPaymentMethod
import CombineUtil
import Topup
import CombineSchedulers

public protocol TopupDependency: Dependency {
    // Topup RIB을 띄운 RIB에서 지정해줄 ViewControllable
    var topupBaseViewController: ViewControllable { get }
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
    var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, EnterAmountDependency, CardOnFileDependency {
    fileprivate var topupBaseViewController: ViewControllable {
        dependency.topupBaseViewController
    }
    
    var mainQueue: AnySchedulerOf<DispatchQueue> {
        dependency.mainQueue
    }
    
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    var selectedPayment: ReadOnlyCurrentValuePublisher<PaymentModel> { selectedPaymentStream }
    let selectedPaymentStream: CurrentValuePublisher<PaymentModel>
    
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable }
    
    init(
        dependency: TopupDependency,
        selectedPaymentStream: CurrentValuePublisher<PaymentModel>
    ) {
        self.selectedPaymentStream = selectedPaymentStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    public override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: TopupListener) -> Routing {
        let selectedPaymentStream = CurrentValuePublisher(
            PaymentModel(id: "", name: "", digits: "", color: "", isPrimary: false)
        )
        
        let component = TopupComponent(dependency: dependency, selectedPaymentStream: selectedPaymentStream)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
        let enterAmount = EnterAmountBuilder(dependency: component)
        let cardOnFile = CardOnFileBuilder(dependency: component)
        
        return TopupRouter(
            interactor: interactor,
            viewController: component.topupBaseViewController,
            addPaymentMethod: component.addPaymentMethodBuildable,
            enterAmount: enterAmount,
            cardOnFile: cardOnFile
        )
    }
}
