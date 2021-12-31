//
//  SuperPayRepository.swift
//  SuperApp
//
//  Created by 장용범 on 2021/12/30.
//

import Foundation
import Combine

protocol SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
    func payRide(amount: Double, paymentMethodId: String) -> AnyPublisher<Void, Error>
}

final class SuperPayRepositoryImpl: SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
    
    private let balanceSubject = CurrentValuePublisher<Double>(0)
    
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            self?.bgQueue.async {
                Thread.sleep(forTimeInterval: 2)
                let newBalance = (self?.balanceSubject.value).map { $0 + amount }
                newBalance.map { self?.balanceSubject.send($0) }
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func payRide(amount: Double, paymentMethodId: String) -> AnyPublisher<Void, Error> {
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

