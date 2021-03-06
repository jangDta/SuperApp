//
//  EnterAmountInteractor.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import Foundation
import ModernRIBs
import Combine
import CombineUtil
import FinanceEntity
import FinanceRepository
import CombineSchedulers

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
    func startLoading()
    func stopLoading()
}

protocol EnterAmountListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func enterAmountDidTapClose()
    func enterAmountDidTapPaymentMethod()
    func enterAmountDidFinishTopup()
}

protocol EnterAmountInteractorDependency {
    var selectedPayment: ReadOnlyCurrentValuePublisher<PaymentModel> { get }
    var superPayRepository: SuperPayRepository { get }
    var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {
    
    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    private let dependency: EnterAmountInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    init(
        presenter: EnterAmountPresentable,
        dependency: EnterAmountInteractorDependency
    ) {
        self.dependency = dependency
        cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.selectedPayment
            .sink { [weak self] model in
                self?.presenter.updateSelectedPaymentMethod(
                    with: SelectedPaymentMethodViewModel(model)
                )
            }
            .store(in: &cancellables)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - EnterAmountPresentableListener
    
    func didTapClose() {
        listener?.enterAmountDidTapClose()
    }
    
    func didTapPaymentMethod() {
        // ?????? ??????
        listener?.enterAmountDidTapPaymentMethod()
    }
    
    func didTapTopup(with amount: Double) {
        // ?????? ??????
        presenter.startLoading()
        
        dependency.superPayRepository.topup(
            amount: amount,
            paymentMethodID: dependency.selectedPayment.value.id
        )
            .receive(on: dependency.mainQueue)
            .sink { [weak self] _ in
                self?.presenter.stopLoading()
            } receiveValue: { [weak self] _ in
                self?.listener?.enterAmountDidFinishTopup()
            }
            .store(in: &cancellables)

    }
}
