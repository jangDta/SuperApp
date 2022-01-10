//
//  CardOnFileRepository.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/24.
//

import Foundation
import Combine
import FinanceEntity
import CombineUtil
import Network

public protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentModel]> { get }
    
    func addCard(_ info: AddPaymentMethodInfo) -> AnyPublisher<PaymentModel, Error>
}

public final class CardOnFileRepositoryImpl: CardOnFileRepository {
    
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentModel]> { paymentSubject }
    
    private let paymentSubject = CurrentValuePublisher<[PaymentModel]>([
        PaymentModel(id: "0", name: "신한은행", digits: "1234", color: "#f19a38ff", isPrimary: false),
        PaymentModel(id: "1", name: "국민은행", digits: "5678", color: "#3478f6ff", isPrimary: false),
        PaymentModel(id: "2", name: "우리은행", digits: "1357", color: "#78c5f5ff", isPrimary: false),
    ])
    
    private let network: Network
    private let baseUrl: URL
    
    public init(
        network: Network,
        baseUrl: URL
    ) {
        self.network = network
        self.baseUrl = baseUrl
    }
    
    public func addCard(_ info: AddPaymentMethodInfo) -> AnyPublisher<PaymentModel, Error> {
        let request = AddCardRequest(baseUrl: baseUrl, info: info)
        
        return network.send(request)
            .map(\.output.card)
            .handleEvents(
                receiveSubscription: nil,
                receiveOutput: { [weak self] card in
                    let cards = (self?.paymentSubject.value).map { $0 + [card] }
                    cards.map { self?.paymentSubject.send($0) }
                },
                receiveCompletion: nil,
                receiveCancel: nil,
                receiveRequest: nil
            )
            .eraseToAnyPublisher()
    }
}
