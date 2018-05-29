

import Foundation
import Contacts

struct ContactRow {
    var isOpen: Bool
    var contacts: [IndividualContact]
}

struct IndividualContact{
    var isLiked: Bool
    var contact: CNContact
}
