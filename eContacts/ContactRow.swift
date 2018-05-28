//
//  ContactRow.swift
//  eContacts
//
//  Created by Miltan on 5/26/18.
//  Copyright © 2018 Milton. All rights reserved.
//

import Foundation
import Contacts

struct ContactRow {
    var isOpen: Bool
    var contacts: [IndividualContact]
}

struct IndividualContact{
    var isLiked: Bool
    //var name: String
    //var phone: String
    var contact: CNContact
}
