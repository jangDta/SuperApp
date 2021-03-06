//
//  SuperPayRepository.swift
//  SuperApp
//
//  Created by 장용범 on 2021/12/30.
//

import Foundation
import Combine
import CombineUtil
import Network

public protocol SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
    func payRide(amount: Double, paymentMethodId: String) -> AnyPublisher<Void, Error>
}

public final class SuperPayRepositoryImpl: SuperPayRepository {
    public var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
    
    private let balanceSubject = CurrentValuePublisher<Double>(0)
    
    private let network: Network
    private let baseUrl: URL
    
    public init(
        network: Network,
        baseUrl: URL
    ) {
        self.network = network
        self.baseUrl = baseUrl
    }
    
    public func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        
        let request = TopupRequest(
            baseUrl: baseUrl,
            amount: amount,
            paymentMethodID: paymentMethodID
        )
        
        return network.send(request)
            .handleEvents(
                receiveSubscription: nil,
                receiveOutput: { [weak self] _ in
                    let newBalance = (self?.balanceSubject.value).map { $0 + amount }
                    newBalance.map { self?.balanceSubject.send($0) }
                },
                receiveCompletion: nil,
                receiveCancel: nil,
                receiveRequest: nil
            )
            .map({ _ in})
            .eraseToAnyPublisher()
    }
    
    public func payRide(amount: Double, paymentMethodId: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            self?.bgQueue.async {
                Thread.sleep(forTimeInterval: 2)
                let newBalance = (self?.balanceSubject.value).map { $0 - amount }
                newBalance.map { self?.balanceSubject.send($0) }
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private let bgQueue = DispatchQueue(label: "topup.repository.queue")
}

