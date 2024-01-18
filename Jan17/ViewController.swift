import UIKit

protocol UpdateData {
    func updateContact(contact: Contact)
    // Added reloadTable function for practice. We make use of it as we are modifying our array of contacts directly on our singleton from AddEditViewController when adding a contact.
    func reloadTable()
}

enum Storyboard: String {
    case Main = "Main"
    case AddEditViewController = "AddEditViewController"
}

class ViewController: UIViewController, UpdateData {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        tableView.rowHeight = 70
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: Storyboard.Main.rawValue, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: Storyboard.AddEditViewController.rawValue) as? AddEditViewController {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateContact(contact: Contact) {
        print(contact.id)
        if let index = AppData.shared.contacts.firstIndex(where: { $0.id == contact.id }) {
            AppData.shared.contacts[index] = contact
            tableView.reloadData()
        }
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.shared.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell {
            let contact = AppData.shared.contacts[indexPath.row]
            cell.nameLabel.text = "\(contact.firstName) \(contact.lastName)"
            cell.emailLabel.text = contact.email
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.confirmationDialog(indexPath: indexPath)
        }
        
        let edit = UIContextualAction(style: .destructive, title: "Edit") { _, _, _ in
            let storyboard: UIStoryboard = UIStoryboard(name: Storyboard.Main.rawValue, bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: Storyboard.AddEditViewController.rawValue) as? AddEditViewController {
                vc.delegate = self
                vc.contact = AppData.shared.contacts[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        edit.backgroundColor =  .lightGray
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }
    
    func confirmationDialog(indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Are you sure you want to delete this contact?",
            message: "This action cannot be undone.",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { _ in
                AppData.shared.contacts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }))
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: { _ in }))
        present(alert,
                animated: true,
                completion: nil
        )
    }
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
