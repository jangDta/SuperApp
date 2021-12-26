//
//  CardOnFileDashboardInteractor.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/24.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func updatePayment(with viewModels: [PaymentViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    
    private let dependency: CardOnFileInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: CardOnFileDashboardPresentable,
        dependency: CardOnFileInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.cardOnFileRepository.cardOnFile
            .sink { [weak self] models in
                let viewModels = models.prefix(5).map { PaymentViewModel($0) }
                self?.presenter.updatePayment(with: viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapAddPaymentMethod() {
        listener?.cardOnFileDashboardDidTapAddPaymentMethod()
    }
}
