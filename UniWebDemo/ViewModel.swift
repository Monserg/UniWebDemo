//
//  ViewModel.swift
//  UniWebDemo
//
//  Created by Sergey Monastyrskiy on 15.01.2021.
//

import Foundation

protocol ViewModelType {
    
}

class ViewModel: ViewModelType {
    // MARK: - Properties
    private let websocketService = WebsocketService()
    
    
    // MARK: - Initialization
    init() {
        websocketService.connect()
    }
}
