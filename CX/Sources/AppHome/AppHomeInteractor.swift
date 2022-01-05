//
//  AppHomeInteractor.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/22.
//

import ModernRIBs

protocol AppHomeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachTransportHome()
    func detachTransportHome()
}

protocol AppHomePresentable: Presentable {
    var listener: AppHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func updateWidget(_ viewModels: [HomeWidgetViewModel])
}

public protocol AppHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AppHomeInteractor: PresentableInteractor<AppHomePresentable>, AppHomeInteractable, AppHomePresentableListener {

    weak var router: AppHomeRouting?
    weak var listener: AppHomeListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AppHomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        let homeWidgetViewModels = [
            HomeWidgetViewModel(
                HomeWidgetModel(title: "슈퍼택시", imageName: "car", tapHandler: { [weak self] in
                    self?.router?.attachTransportHome()
                })
            ),
            HomeWidgetViewModel(
                HomeWidgetModel(title: "슈퍼마트", imageName: "cart", tapHandler: {})
            )
        ]
        
        presenter.updateWidget(homeWidgetViewModels)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func transportHomeDidTapClose() {
        router?.detachTransportHome()
    }
}
