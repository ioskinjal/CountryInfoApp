//
//  CountryListViewModelTests.swift
//  CountryInfoAppTests
//
//  Created by Totochan on 27/05/25.
//

import XCTest
@testable import CountryInfoApp

final class CountryListViewModelTests: XCTestCase {

    var viewModel: CountryListViewModel!

        override func setUp() {
            super.setUp()
            viewModel = CountryListViewModel()
        }

        override func tearDown() {
            viewModel = nil
            super.tearDown()
        }

        func testAddCountryUpToLimit() {
            let countries = (1...5).map {
                Country(name: "Country\($0)", capital: "Capital\($0)", currencies: nil)
            }

            for country in countries {
                viewModel.addCountry(country)
            }

            XCTAssertEqual(viewModel.selectedCountries.count, 5)
        }

        func testAddMoreThanFiveCountriesFails() {
            let countries = (1...6).map {
                Country(name: "Country\($0)", capital: "Capital\($0)", currencies: nil)
            }

            for country in countries {
                viewModel.addCountry(country)
            }

            XCTAssertEqual(viewModel.selectedCountries.count, 5, "Should not allow more than 5 countries")
        }

        func testCountryIsNotAddedTwice() {
            let country = Country(name: "Japan", capital: "Tokyo", currencies: nil)
            viewModel.addCountry(country)
            viewModel.addCountry(country)

            XCTAssertEqual(viewModel.selectedCountries.count, 1, "Should not add duplicate country")
        }

        func testRemoveCountry() {
            let country = Country(name: "India", capital: "New Delhi", currencies: nil)
            viewModel.addCountry(country)
            viewModel.removeCountry(country)

            XCTAssertFalse(viewModel.selectedCountries.contains(country))
        }

}
