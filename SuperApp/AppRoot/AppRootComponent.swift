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

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency {
    
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
        cardOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository,
        rootViewController: ViewControllable
    ) {
        self.cardOnFileRepository = cardOnFileRepository
        self.superPayRepository = superPayRepository
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}
