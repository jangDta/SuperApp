//
//  TopupBuilder.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import ModernRIBs

protocol TopupDependency: Dependency {
    // Topup RIB을 띄운 RIB에서 지정해줄 ViewControllable
    var topupBaseViewController: ViewControllable { get }
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
    fileprivate var topupBaseViewController: ViewControllable {
        return dependency.topupBaseViewController
    }
    
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    
    var selectedPayment: ReadOnlyCurrentValuePublisher<PaymentModel> { selectedPaymentStream }
    let selectedPaymentStream: CurrentValuePublisher<PaymentModel>
    
    init(
        dependency: TopupDependency,
        selectedPaymentStream: CurrentValuePublisher<PaymentModel>
    ) {
        self.selectedPaymentStream = selectedPaymentStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TopupListener) -> TopupRouting {
        let selectedPaymentStream = CurrentValuePublisher(
            PaymentModel(id: "", name: "", digits: "", color: "", isPrimary: false)
        )
        
        let component = TopupComponent(dependency: dependency, selectedPaymentStream: selectedPaymentStream)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
        let addPaymentMethod = AddPaymentMethodBuilder(dependency: component)
        let enterAmount = EnterAmountBuilder(dependency: component)
        let cardOnFile = CardOnFileBuilder(dependency: component)
        
        return TopupRouter(
            interactor: interactor,
            viewController: component.topupBaseViewController,
            addPaymentMethod: addPaymentMethod,
            enterAmount: enterAmount,
            cardOnFile: cardOnFile
        )
    }
}
