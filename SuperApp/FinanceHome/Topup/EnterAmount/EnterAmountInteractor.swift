//
//  EnterAmountInteractor.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import ModernRIBs

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol EnterAmountListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func enterAmountDidTapClose()
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {

    weak var router: EnterAmountRouting?
    weak var listener: EnterAmountListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: EnterAmountPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
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
        // 카드 선택
    }
    
    func didTapTopup(with amount: Double) {
        // 잔액 충전
    }
}
