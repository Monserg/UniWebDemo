//
//  WebsocketService.swift
//  UniWebDemo
//
//  Created by Sergey Monastyrskiy on 15.01.2021.
//

import Foundation
import Starscream
import RxSwift
import RxCocoa

class WebsocketService: NSObject {
    // MARK: - Properties
    var socket: WebSocket!
    
    var isConnected: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var rate: BehaviorRelay<Rate> = BehaviorRelay<Rate>(value: Rate(time: 0.0, price: Conflicted.init(string: nil), quantity: Conflicted.init(string: nil), type: "buy", isRise: false))

    
    // MARK: - Class functions
    func connect() {
        var request = URLRequest(url: URL(string: "ws://bitcoinstat.org:9000")!)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    private func disconnect() {
        isConnected.accept(false)
        socket.disconnect()
    }
    
    private func reset() {
        disconnect()
        connect()
    }

    
    
    func send(message: String) {
        socket.write(string: message)
    }
}


//
extension WebsocketService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            self.isConnected.accept(true)
            print("websocket is connected: \(headers)")
            
        case .disconnected(let reason, let code):
            self.isConnected.accept(false)
            print("websocket is disconnected: \(reason) with code: \(code)")
            
        case .text(let string):
            print("Received text: \(string)")
            
            guard let response = try? JSONDecoder().decode(Rate.self, from: Data(string.utf8)) else {
                return
            }
            
            if response.type == "buy" {
                return
            }
            
            rate.accept(response)
            
        case .binary(let data):
            print("Received data: \(data.count)")
            
        case .ping(_):
            break
            
        case .pong(_):
            break
            
        case .viabilityChanged(_):
            break
            
        case .reconnectSuggested(_):
            break
            
        case .cancelled:
            self.isConnected.accept(false)
            
        case .error:
            self.reset()
        }
    }
}
