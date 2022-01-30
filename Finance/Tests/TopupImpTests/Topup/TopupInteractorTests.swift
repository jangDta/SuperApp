//
//  TopupInteractorTests.swift
//  SuperApp
//
//  Created by 장용범 on 2022/01/30.
//

@testable import TopupImp
import XCTest
import TopupTestSupport

final class TopupInteractorTests: XCTestCase {

    private var sut: TopupInteractor!
    private var dependency: TopupDependencyMock!
    private var listener: TopupListenerMock!

    // TODO: declare other objects and mocks you need as private vars

    override func setUp() {
        super.setUp()
        
        dependency = TopupDependencyMock()
        listener = TopupListenerMock()
        
        sut = TopupInteractor(dependency: dependency)
        sut.listener = listener
    }

    // MARK: - Tests

    func test_exampleObservable_callsRouterOrListener_exampleProtocol() {
        // This is an example of an interactor test case.
        // Test your interactor binds observables and sends messages to router or listener.
    }
}
