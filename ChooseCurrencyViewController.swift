import UIKit

class ChooseCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var isChangingFromCurrency: Bool = false
    var selectedCurrency: Currency?
    var inSegueIdentifier: String = ""
    var tableViewSource: [Currency] = [
       Currency(name: "AUD", rateToUsd: 1.521),
       Currency(name: "BGN", rateToUsd: 1.9558),
       Currency(name: "BRL", rateToUsd: 3.8059),
       Currency(name: "CAD", rateToUsd: 1.5004),
       Currency(name: "CHF", rateToUsd: 1.1622),
       Currency(name: "CNY", rateToUsd: 7.7177),
       Currency(name: "CZK", rateToUsd: 25.669),
       Currency(name: "DKK", rateToUsd: 7.4412),
       Currency(name: "GBP", rateToUsd: 0.87853),
       Currency(name: "HKD", rateToUsd: 9.0769),
       Currency(name: "HRK", rateToUsd: 7.5225),
       Currency(name: "HUF", rateToUsd: 311.64),
       Currency(name: "IDR", rateToUsd: 15787.0),
       Currency(name: "ILS", rateToUsd: 4.0992),
       Currency(name: "INR", rateToUsd: 75.356),
       Currency(name: "JPY", rateToUsd: 132.0),
       Currency(name: "KRW", rateToUsd: 1301.5),
       Currency(name: "MXN", rateToUsd: 22.296),
       Currency(name: "MYR", rateToUsd: 4.9252),
       Currency(name: "NOK", rateToUsd: 9.5238),
       Currency(name: "NZD", rateToUsd: 1.7005),
       Currency(name: "PHP", rateToUsd: 60.045),
       Currency(name: "PLN", rateToUsd: 4.244),
       Currency(name: "RON", rateToUsd: 4.6005),
       Currency(name: "RUB", rateToUsd: 67.874),
       Currency(name: "SEK", rateToUsd: 9.7415),
       Currency(name: "SGD", rateToUsd: 1.586),
       Currency(name: "THB", rateToUsd: 38.65),
       Currency(name: "TRY", rateToUsd: 4.4164),
       Currency(name: "USD", rateToUsd: 1.0),
       Currency(name: "ZAR", rateToUsd: 16.434)
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        filter(searchTerm: "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseCurrencyViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    //override func viewDidAppear(_ animated: Bool) {
        //searchTextField.becomeFirstResponder()
    //}
    
    func filter(searchTerm: String) {
//        let term = searchTerm.lowercased()
//        tableViewSource = term.isEmpty ? currencies : currencies.filter { currency in
//            let shortName = currency.name.lowercased()
//            let longName = currencyLongNames[currency.name]?.lowercased() ?? ""
//            return shortName.contains(term) || longName.contains(term)
//        }
//        resultsTableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //@IBAction func searchTextChanged(_ sender: UITextField) {
        //filter(searchTerm: sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
    //}
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCurrency = tableViewSource[indexPath.row]
        if isChangingFromCurrency {
            CurrencyExchange.shared.fromCurrency = selectedCurrency!
        } else {
            CurrencyExchange.shared.toCurrency = selectedCurrency!
        }
        self.dismiss(animated: true, completion: nil)
        //performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let shortName = tableViewSource[indexPath.row].name
        let longName = currencyLongNames[shortName] ?? ""
        cell.textLabel?.text = "\(shortName) - \(longName)"
        return cell
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            resultsTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        }
    }
}
