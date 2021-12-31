import ModernRIBs
import Foundation

protocol TransportHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    
    var superPayRepository: SuperPayRepository { get }
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency, TopupDependency {
    var topupBaseViewController: ViewControllable
    
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    
    var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }
    
    init(
        topupBaseViewController: ViewControllable,
        dependency: TransportHomeDependency
    ) {
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol TransportHomeBuildable: Buildable {
    func build(withListener listener: TransportHomeListener) -> TransportHomeRouting
}

final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
    
    override init(dependency: TransportHomeDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: TransportHomeListener) -> TransportHomeRouting {
        let viewController = TransportHomeViewController()
        let component = TransportHomeComponent(topupBaseViewController: viewController, dependency: dependency)
        let interactor = TransportHomeInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let topup = TopupBuilder(dependency: component)
        
        return TransportHomeRouter(
            interactor: interactor,
            viewController: viewController,
            topup: topup
        )
    }
}
