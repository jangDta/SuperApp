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

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency {
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    
    var cardOnFileRepository: CardOnFileRepository
    
    var superPayRepository: SuperPayRepository
    
    init(
        dependency: AppRootDependency,
        cardOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository
    ) {
        self.cardOnFileRepository = cardOnFileRepository
        self.superPayRepository = superPayRepository
        super.init(dependency: dependency)
    }
}
