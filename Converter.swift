import Foundation

struct Currency: Codable {
    let name: String
    let rateToUsd: Double
}

class CurrencyExchange {
    static let shared = CurrencyExchange()
    var toCurrency = Currency(name: "USD", rateToUsd: 1.1638)
    var fromCurrency = Currency(name: "KRW", rateToUsd: 1301.5)
}

var currencies: [Currency] = []

struct Response: Codable {
    var base: String
    var date: String
    var rates: [String: Double]
    
    func toCurrencies() -> [Currency] {
        let currenciesUnsorted = [Currency(name: self.base, rateToUsd: 1.0)] + self.rates.map { (key, value) in
            return Currency(name: key, rateToUsd: value)
        }
        return currenciesUnsorted.sorted(by: { $0.name < $1.name })
    }
}

func saveSelectedCurrencies(from: Currency, to: Currency) {
    UserDefaults.standard.setValue(from.name, forKey: "fromName")
    UserDefaults.standard.setValue(to.name, forKey: "toName")
}

func loadSelectedCurrencies() -> (from: Currency, to: Currency) {
    let fromName = UserDefaults.standard.string(forKey: "fromName")
    let toName = UserDefaults.standard.string(forKey: "toName")
    let from = currencies.filter { $0.name == fromName ?? "KRW" }.first ?? Currency(name: "KRW", rateToUsd: 1)
    let to = currencies.filter { $0.name == toName ?? "USD" }.first ?? Currency(name: "USD", rateToUsd: 0.001)
    return (from: from, to: to)
}

func saveToDisk(data: Data) {
    UserDefaults.standard.set(data, forKey: "currencies")
}

func loadFromDisk() -> [Currency] {
    var data: Data
    if let savedData = UserDefaults.standard.data(forKey: "currencies") {
        data = savedData
    } else {
        data = initialRates.data(using: .utf8)!
    }
    guard let response = try? JSONDecoder().decode(Response.self, from: data) else { return [] }
    return response.toCurrencies()
}

func initCurrencies() {
    currencies = loadFromDisk()
    fetchRates()
}

func fetchRates() {
    let url = URL(string: "https://api.fixer.io/latest")!
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let jsonData = data else { return }
        guard let ratesResponse = try? JSONDecoder().decode(Response.self, from: jsonData) else { return }
        
        currencies = ratesResponse.toCurrencies()
        saveToDisk(data: jsonData)
        
        }.resume()
}

func convert(amount: Double, from: Currency, to: Currency) -> Double {
    let amountInBase = amount / from.rateToUsd
    let amountInTarget = amountInBase * to.rateToUsd
    
    return amountInTarget
}

