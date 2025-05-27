//
//  Country.swift
//  CountryInfoApp
//
//  Created by Totochan on 27/05/25.
//

import Foundation

struct Country: Codable, Equatable {
    let name: String
    let capital: String?
    let currencies: [Currency]?

    var currencyDescription: String {
        currencies?.compactMap { $0.name }.joined(separator: ", ") ?? "N/A"
    }

    // Equatable conformance
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name
    }
}

struct Currency: Codable, Equatable {
    let code: String?
    let name: String?
    let symbol: String?
}
