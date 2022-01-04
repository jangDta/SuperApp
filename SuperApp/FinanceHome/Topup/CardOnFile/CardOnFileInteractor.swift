//
//  CardOnFileInteractor.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import ModernRIBs
import FinanceEntity

protocol CardOnFileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
    var listener: CardOnFilePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func update(with viewModels: [PaymentViewModel])
}

protocol CardOnFileListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func cardOnFileDidTapClose()
    func cardOnFileDidTapAddCard()
    func cardOnFileDidTapSelectCard(at index: Int)
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {
    
    weak var router: CardOnFileRouting?
    weak var listener: CardOnFileListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    
    private let payments: [PaymentModel]
    
    init(
        presenter: CardOnFilePresentable,
        payments: [PaymentModel]
    ) {
        self.payments = payments
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.update(with: payments.map { PaymentViewModel($0) })
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - CardOnFilePresentable Listener
    
    func didTapClose() {
        listener?.cardOnFileDidTapClose()
    }
    
    func didSelectItem(at index: Int) {
        if index >= payments.count {
            // 카드 추가하기
            listener?.cardOnFileDidTapAddCard()
        } else {
            // 카드 선택하기
            listener?.cardOnFileDidTapSelectCard(at: index)
        }
    }
}
