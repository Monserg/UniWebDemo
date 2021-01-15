//
//  ViewModel.swift
//  UniWebDemo
//
//  Created by Sergey Monastyrskiy on 15.01.2021.
//

import Foundation

enum CurrencyType: String {
    case usd = "usd"
    case euro = "eur"
}

protocol ViewModelType {
    func subscribe(currency: String, exchanger: String)
}

class ViewModel: ViewModelType {
    // MARK: - Properties
    private let websocketService = WebsocketService()
    
    
    // MARK: - Initialization
    init() {
        websocketService.connect()
    }
    
    
    // MARK: - ViewModelType protocol
    func subscribe(currency: String = CurrencyType.usd.rawValue, exchanger: String) {
        let stringRequest = "{\"subscribe\":\"trade.btc_\(currency)_\(exchanger)\"}"
        let message = URLSessionWebSocketTask.Message.string(stringRequest)
        websocketService.send(message: message)
        receiveMessage()
    }
    
    private func receiveMessage() {
        websocketService.receiveMessage()
    }
}
