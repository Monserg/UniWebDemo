//
//  ViewModel.swift
//  UniWebDemo
//
//  Created by Sergey Monastyrskiy on 15.01.2021.
//

import Foundation
import RxSwift
import RxCocoa

enum CurrencyType: String {
    case usd = "usd"
    case euro = "eur"
}

protocol ViewModelType {
    var rate: BehaviorRelay<Rate> { get set }
    var isConnected: BehaviorRelay<Bool> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }

    func changeSelectedCurrency(index: Int)
    func changeSelectedExchanger(index: Int)
}

class ViewModel: ViewModelType {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let websocketService = WebsocketService()
    private let currencies = ["usd", "eur"]
    private let exchangers = ["kraken", "bitstamp", "coinbasepro", "gemini"]
    
    private var selectedCurrencyIndex: Int = 0 {
        willSet {
            unsubscribe(currency: currencies[selectedCurrencyIndex], exchanger: exchangers[selectedExchangerIndex])
            subscribe(currency: currencies[newValue], exchanger: exchangers[selectedExchangerIndex])
        }
    }
    
    private var selectedExchangerIndex: Int = 0 {
        willSet {
            unsubscribe(currency: currencies[selectedCurrencyIndex], exchanger: exchangers[selectedExchangerIndex])
            subscribe(currency: currencies[selectedCurrencyIndex], exchanger: exchangers[newValue])
        }
    }

    
    // MARK: - Initialization
    init() {
        websocketService.connect()
        bind()
    }
    
    
    // MARK: - ViewModelType protocol
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var isConnected: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var rate: BehaviorRelay<Rate> = BehaviorRelay<Rate>(value: Rate(time: 0.0, price: Conflicted.init(string: nil), quantity: Conflicted.init(string: nil), type: "buy", isRise: false))

    func changeSelectedCurrency(index: Int) {
        selectedCurrencyIndex = index
    }
    
    func changeSelectedExchanger(index: Int) {
        selectedExchangerIndex = index
    }
    
    
    // MARK: - Custom functions
    private func bind() {
        websocketService.isConnected
            .subscribe(onNext: { (status) in
                self.isConnected.accept(status)
                
                if status {
                    self.subscribe(currency: self.currencies[self.selectedCurrencyIndex], exchanger: self.exchangers[self.selectedExchangerIndex])
                }
            },
            onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        websocketService.rate
            .subscribe(onNext: { (rateValue) in
                var rateTemp = rateValue
                rateTemp.isRise = rateValue.price.doubleValue ?? 0.0 >= self.rate.value.price.doubleValue ?? 0.0
                self.rate.accept(rateTemp)
            },
            onError: { (error) in
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribe(currency: String = CurrencyType.usd.rawValue, exchanger: String) {
        let stringRequest = "{\"subscribe\":\"trade.btc_\(currency)_\(exchanger)\"}"
        websocketService.send(message: stringRequest)
        isLoading.accept(true)
        print("send message: \(stringRequest)")
    }
    
    private func unsubscribe(currency: String = CurrencyType.usd.rawValue, exchanger: String) {
        let stringRequest = "{\"unsubscribe\":\"trade.btc_\(currency)_\(exchanger)\"}"
        websocketService.send(message: stringRequest)
        print("send message: \(stringRequest)")
    }
}
