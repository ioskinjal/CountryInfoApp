import Foundation
import Combine
import CoreLocation

class CountryListViewModel: NSObject, ObservableObject {
    @Published var allCountries: [Country] = []
    @Published var selectedCountries: [Country] = []
    @Published var searchText: String = ""
    @Published var filteredCountries: [Country] = []

    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    override init() {
        super.init()
        setupSearch()
        loadPersistedCountries()
        fetchCountries()
        setupLocation()
    }

    // MARK: - Search
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .combineLatest($allCountries)
            .map { (search, countries) in
                guard !search.isEmpty else { return countries }
                return countries.filter { $0.name.lowercased().contains(search.lowercased()) }
            }
            .assign(to: \.filteredCountries, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Fetch API
    func fetchCountries() {
        CountryService.shared.fetchCountries()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching countries: \(error)")
                }
            }, receiveValue: { [weak self] countries in
                self?.allCountries = countries
                self?.filteredCountries = countries
            })
            .store(in: &cancellables)
    }

    // MARK: - Location
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    private func setDefaultCountry() {
        if let defaultCountry = allCountries.first(where: { $0.name.lowercased() == "india" }) {
            addCountry(defaultCountry)
        }
    }

    // MARK: - Country Actions
    func addCountry(_ country: Country) {
        guard selectedCountries.count < 5 else { return }
        guard !selectedCountries.contains(where: { $0.name == country.name }) else { return }

        selectedCountries.append(country)
        persistSelectedCountries()
    }

    func removeCountry(_ country: Country) {
        selectedCountries.removeAll { $0.name == country.name }
        persistSelectedCountries()
    }

    // MARK: - Persistence
    private func persistSelectedCountries() {
        PersistenceManager.save(countries: selectedCountries)
    }

    private func loadPersistedCountries() {
        selectedCountries = PersistenceManager.load()
    }
}

// MARK: - CLLocationManagerDelegate
extension CountryListViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            setDefaultCountry()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        setDefaultCountry()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            setDefaultCountry()
            return
        }

        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }

            if let error = error {
                print("Geocode error: \(error)")
                self.setDefaultCountry()
                return
            }

            if let countryName = placemarks?.first?.country {
                if let match = self.allCountries.first(where: { $0.name == countryName }) {
                    self.addCountry(match)
                } else {
                    self.setDefaultCountry()
                }
            } else {
                self.setDefaultCountry()
            }
        }
    }
}
