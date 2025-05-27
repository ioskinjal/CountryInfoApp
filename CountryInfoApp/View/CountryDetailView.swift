//
//  CountryDetailView.swift
//  CountryInfoApp
//
//  Created by Totochan on 27/05/25.
//

import SwiftUI

struct CountryDetailView: View {
    let country: Country

        var body: some View {
            VStack(spacing: 20) {
                Text("Capital: \(country.capital ?? "N/A")")
                Text("Currency: \(country.currencies?.first?.name ?? "N/A")")
            }
            .navigationTitle(country.name)
            .padding()
        }
}

#Preview {
    let mockCountry = Country(
            name: "Japan",
            capital: "Tokyo",
            currencies: [
                Currency(code: "JPY", name: "Japanese yen", symbol: "¥")
            ]
        )
        return CountryDetailView(country: mockCountry)
}
