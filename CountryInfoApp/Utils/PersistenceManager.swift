//
//  PersistenceManager.swift
//  CountryInfoApp
//
//  Created by Totochan on 27/05/25.
//

import Foundation

class PersistenceManager {
    private static let key = "savedCountries"

    static func save(countries: [Country]) {
        if let data = try? JSONEncoder().encode(countries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func load() -> [Country] {
        if let data = UserDefaults.standard.data(forKey: key),
           let countries = try? JSONDecoder().decode([Country].self, from: data) {
            return countries
        }
        return []
    }
}
