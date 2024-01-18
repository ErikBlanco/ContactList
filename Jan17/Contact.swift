import Foundation

class AppData {
    static let shared = AppData()
    var contacts: [Contact]
    private init() {
        self.contacts = [
            Contact(firstName: "John", lastName: "Doe", email: "jdoe@intekglobal.com"),
            Contact(firstName: "Mark", lastName: "Twain", email: "mtwain@intekglobal.com"),
            Contact(firstName: "Kent", lastName: "Beck", email: "kbeck@intekglobal.com"),
            Contact(firstName: "Martin", lastName: "Fowler", email: "mfowler@intekglobal.com"),
            Contact(firstName: "Erik", lastName: "Blanco", email: "eblanco@intekglobal.com"),
        ]
    }
}


struct Contact: Identifiable {
    let id = UUID()
    var firstName: String
    var lastName: String
    var email: String
}
