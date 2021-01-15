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
    var urlSession: URLSession!
    var webSocketTask: URLSessionWebSocketTask!

        
    // MARK: - Class functions
    func connect() {
        urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://bitcoinstat.org:9000")!)
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
