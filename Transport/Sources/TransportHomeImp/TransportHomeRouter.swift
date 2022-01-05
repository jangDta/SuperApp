import ModernRIBs
import Topup
import TransportHome

protocol TransportHomeInteractable: Interactable, TopupListener {
    var router: TransportHomeRouting? { get set }
    var listener: TransportHomeListener? { get set }
}

protocol TransportHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TransportHomeRouter: ViewableRouter<TransportHomeInteractable, TransportHomeViewControllable>, TransportHomeRouting {
    
    private let topup: TopupBuildable
    private var topupRouting: Routing?
    
    init(
        interactor: TransportHomeInteractable,
        viewController: TransportHomeViewControllable,
        topup: TopupBuildable
    ) {
        self.topup = topup
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTopup() {
        if topupRouting != nil {
            return
        }
        
        let router = topup.build(withListener: interactor)
        
        attachChild(router)
        topupRouting = router
    }
    
    func detachTopup() {
        guard let router = topupRouting else {
            return
        }
        
        detachChild(router)
        topupRouting = nil
    }
    
}
