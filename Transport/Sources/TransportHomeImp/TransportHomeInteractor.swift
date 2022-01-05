import ModernRIBs
import Combine
import Foundation
import CombineUtil
import TransportHome

protocol TransportHomeRouting: ViewableRouting {
    func attachTopup()
    func detachTopup()
}

protocol TransportHomePresentable: Presentable {
    var listener: TransportHomePresentableListener? { get set }
    
    func setSuperPayBalance(_ balanceText: String)
}

protocol TransportHomeInteractorDependency {
    var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { get }
    var balanceFormatter: NumberFormatter { get }
}

final class TransportHomeInteractor: PresentableInteractor<TransportHomePresentable>, TransportHomeInteractable, TransportHomePresentableListener {
    
    weak var router: TransportHomeRouting?
    weak var listener: TransportHomeListener?
    
    private let dependency: TransportHomeInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    private let ridePrice: Double = 18000 // 택시 호출 비용
    
    init(
        presenter: TransportHomePresentable,
        dependency: TransportHomeInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.superPayBalance
            .receive(on: DispatchQueue.main)
            .map {
                NSNumber(value: $0)
            }
            .compactMap { [weak self] in
                self?.dependency.balanceFormatter.string(from: $0)
            }
            .sink { [weak self] in
                self?.presenter.setSuperPayBalance($0)
            }
            .store(in: &cancellables)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - TransportHomePresentable Listener
    
    func didTapBack() {
        listener?.transportHomeDidTapClose()
    }
    
    func didTapRideConfirm() {
        if dependency.superPayBalance.value < ridePrice {
            router?.attachTopup()
        } else {
            // success
        }
    }
    
    // MARK: - Topup Listener
    
    func topupDidClose() {
        router?.detachTopup()
    }
    
    func topupDidFinish() {
        router?.detachTopup()
    }
}
