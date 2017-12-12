import UIKit

class ChooseCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var selectedCurrency: Currency?
    var inSegueIdentifier: String = ""
    var tableViewSource: [Currency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        filter(searchTerm: "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseCurrencyViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchTextField.becomeFirstResponder()
    }
    
    func filter(searchTerm: String) {
        let term = searchTerm.lowercased()
        tableViewSource = term.isEmpty ? currencies : currencies.filter { currency in
            let shortName = currency.name.lowercased()
            let longName = currencyLongNames[currency.name]?.lowercased() ?? ""
            return shortName.contains(term) || longName.contains(term)
        }
        resultsTableView.reloadData()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    @IBAction func searchTextChanged(_ sender: UITextField) {
        filter(searchTerm: sender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCurrency = tableViewSource[indexPath.row]
        performSegue(withIdentifier: "unwindToMain", sender: self)
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
