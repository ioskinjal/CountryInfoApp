//
//  CountryService.swift
//  CountryInfoApp
//
//  Created by Totochan on 27/05/25.
//

import Foundation
import Combine

class CountryService {
    static let shared = CountryService()
    private let url = URL(string: "https://restcountries.com/v2/all")!

    func fetchCountries() -> AnyPublisher<[Country], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Country].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
