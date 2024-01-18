import UIKit

class AddEditViewController: UIViewController {
    var delegate: UpdateData?
    var contact: Contact?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var lastNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let contact = contact {
            titleLabel.text = "Edit contact"
            button.setTitle("Save changes", for: .normal)
            emailTextField.text = contact.email
            firstNameTextField.text = contact.firstName
            lastNameTextField.text = contact.lastName
        } else {
            titleLabel.text = "Add contact"
            button.setTitle("Add contact", for: .normal)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        // Add
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else { return }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty, isValidEmail(email: email) else { return }
        
        if var contact = contact {
            contact.firstName = firstName
            contact.lastName = lastName
            contact.email = email
            
            delegate?.updateContact(contact: contact)
            self.navigationController?.popViewController(animated: true)
        } else {
            // Here we actually make use of our singleton directly, to show we can use singletons in other view controllers as long as we access its shared property
            AppData.shared.contacts.append(Contact(firstName: firstName, lastName: lastName, email: email))
            delegate?.reloadTable()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
}
