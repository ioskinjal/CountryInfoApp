//
//  CountryListView.swift
//  CountryInfoApp
//
//  Created by Totochan on 27/05/25.
//

import SwiftUI

struct CountryListView: View {
    @StateObject private var viewModel = CountryListViewModel()

        var body: some View {
            NavigationView {
                VStack {
                    // Search bar
                    TextField("Search country...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    // Selected countries
                    if !viewModel.selectedCountries.isEmpty {
                        Section(header: Text("Selected Countries (max 5)").font(.headline)) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.selectedCountries, id: \.name) { country in
                                        NavigationLink(destination: CountryDetailView(country: country)) {
                                            VStack {
                                                Text(country.name)
                                                    .font(.subheadline)
                                                    .padding(8)
                                                    .background(Color.blue.opacity(0.2))
                                                    .cornerRadius(8)
                                            }
                                        }
                                        .contextMenu {
                                            Button("Remove") {
                                                viewModel.removeCountry(country)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    Divider()

                    // Filtered country list
                    List(viewModel.filteredCountries, id: \.name) { country in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(country.name)
                                    .font(.headline)
                                if let capital = country.capital {
                                    Text("Capital: \(capital)").font(.subheadline).foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Button(action: {
                                viewModel.addCountry(country)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                            }
                            .disabled(viewModel.selectedCountries.contains(where: { $0.name == country.name }) || viewModel.selectedCountries.count >= 5)
                        }
                    }
                    .listStyle(.plain)
                }
                .navigationTitle("Countries")
            }
        }
}

#Preview {
    CountryListView()
}
