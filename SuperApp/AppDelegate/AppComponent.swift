//
//  AppComponent.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/22.
//

import Foundation
import ModernRIBs

final class AppComponent: Component<EmptyDependency>, AppRootDependency {
    
    init() {
        super.init(dependency: EmptyComponent())
    }
}
