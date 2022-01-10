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
    func fetch()
}

public final class CardOnFileRepositoryImpl: CardOnFileRepository {
    
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentModel]> { paymentSubject }
    
    private let paymentSubject = CurrentValuePublisher<[PaymentModel]>([])
    
    private let network: Network
    private let baseUrl: URL
    private var cancellables: Set<AnyCancellable>
    
    public init(
        network: Network,
        baseUrl: URL
    ) {
        self.network = network
        self.baseUrl = baseUrl
        self.cancellables = .init()
    }
    
    public func fetch() {
        let request = CardOnFileRequest(baseUrl: baseUrl)
        
        network.send(request)
            .map(\.output.cards)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] cards in
                    self?.paymentSubject.send(cards)
                }
            )
            .store(in: &cancellables)
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
