//
//  AppRootComponent.swift
//  SuperApp
//
//  Created by a60105114 on 2022/01/05.
//

import Foundation
import ModernRIBs
import AppHome
import FinanceHome
import ProfileHome
import FinanceRepository
import TransportHome
import TransportHomeImp
import Topup
import TopupImp
import AddPaymentMethod
import AddPaymentMethodImp
import Network
import NetworkImp

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency, AddPaymentMethodDependency {
    
    lazy var addPaymentMethodBuildable: AddPaymentMethodBuildable = {
        return AddPaymentMethodBuilder(dependency: self)
    }()
    
    lazy var topupBuildable: TopupBuildable = {
        return TopupBuilder(dependency: self)
    }()
    
    var topupBaseViewController: ViewControllable {
        rootViewController.topViewControllable
    }
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    
    var cardOnFileRepository: CardOnFileRepository
    
    var superPayRepository: SuperPayRepository
    
    private let rootViewController: ViewControllable
    
    init(
        dependency: AppRootDependency,
        rootViewController: ViewControllable
    ) {
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [SuperAppURLProtocol.self]
        
        setupURLProtocol()
        
        let network = NetworkImp(session: URLSession(configuration: config))
        
        self.cardOnFileRepository = CardOnFileRepositoryImpl(
            network: network,
            baseUrl: BaseURL.financeBaseURL
        )
        self.superPayRepository = SuperPayRepositoryImpl(
            network: network,
            baseUrl: BaseURL.financeBaseURL
        )
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}
