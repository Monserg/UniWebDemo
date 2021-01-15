//
//  WebsocketService.swift
//  UniWebDemo
//
//  Created by Sergey Monastyrskiy on 15.01.2021.
//

import Foundation

class WebsocketService: NSObject {
    // MARK: - Properties
    var isConnected = false
    let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "ws://bitcoinstat.org:9000")!)
    
    // MARK: - Class functions
    func connect() {
        webSocketTask.resume()
    }
}


// MARK: - URLSessionWebSocketDelegate
extension WebsocketService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        DispatchQueue.main.async {
            self.isConnected = true
        }
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
}
