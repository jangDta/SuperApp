import ModernRIBs
import Foundation
import FinanceRepository
import CombineUtil
import FoundationUtil
import Topup
import TransportHome

public protocol TransportHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    
    var superPayRepository: SuperPayRepository { get }
    
    var topupBuildable: TopupBuildable { get }
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency {
    var topupBaseViewController: ViewControllable
    
    var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
    
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }
    
    var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    
    var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }
    
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
    
    init(
        topupBaseViewController: ViewControllable,
        dependency: TransportHomeDependency
    ) {
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

public final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
    
    public override init(dependency: TransportHomeDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: TransportHomeListener) -> ViewableRouting {
        let viewController = TransportHomeViewController()
        let component = TransportHomeComponent(topupBaseViewController: viewController, dependency: dependency)
        let interactor = TransportHomeInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        return TransportHomeRouter(
            interactor: interactor,
            viewController: viewController,
            topup: component.topupBuildable
        )
    }
}
