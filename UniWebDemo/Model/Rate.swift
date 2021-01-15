//
//  Rate.swift
//  UniWebDemo
//
//  Created by Sergey Monastyrskiy on 15.01.2021.
//

import Foundation

struct Conflicted: Codable, Equatable {
    public let doubleValue: Double?
    
    // Where we determine what type the value is
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        do {
            doubleValue = try container.decode(Double.self)
        } catch {
            do {
                doubleValue = Double(try container.decode(String.self))
            } catch {
                doubleValue = 0.0
            }
        }
    }
    
    // We need to go back to a dynamic type, so based on the data we have stored, encode to the proper type
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(doubleValue)
    }
    
    public init(string: String?) {
        doubleValue = Double(string ?? "0.0")
    }
}

struct Rate: Codable {
    let time: Double
    let price: Conflicted
    let quantity: Conflicted
    let type: String?
    
    var isRise: Bool?
}
