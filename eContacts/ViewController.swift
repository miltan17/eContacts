//
//  ViewController.swift
//  eContacts
//
//  Created by Miltan on 5/26/18.
//  Copyright © 2018 Milton. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {
    
    let cellID = "ContactCell"
    var contactsDictionary = [ContactRow]()
    
    var contactDictionary = [ContactRow]()
        //ContactRow(isOpen: true, contacts: ["Aminul", "Arif","Asif","Anwar"].map{IndividualContact(isLiked: false, firstName: $0)}),
        //ContactRow(isOpen: true, contacts: ["Bashir", "Badhon","Biddut"].map{IndividualContact(isLiked: false, name: $0)}),
        //ContactRow(isOpen: true, contacts: ["Chandler","Chris"].map{IndividualContact(isLiked: false, name: $0)}),
//        ContactRow(isOpen: true, contacts: [IndividualContact(isLiked: false, firstName: "Diba", lastName: "Sarkar", phoneNo: "021545"), IndividualContact(isLiked: false, firstName: "Diba", lastName: "Sarkar", phoneNo: "021545")])
//    ]
    
    var showIndexPath = false
    
    func fetchContacts(){
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if error != nil {
                return
            }
            if granted{
                let keyToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keyToFetch as [CNKeyDescriptor])
                do{
                    var contacts = [IndividualContact]()
                    try store.enumerateContacts(with: request, usingBlock: { (contact, StopPointerIfYouWantToStopEnumerating) in
                        
                        contacts.append(IndividualContact(isLiked: false, name: contact.givenName + " " + contact.familyName, phone: (contact.phoneNumbers.first?.value.stringValue)!))
                    })
                    let contactRow = ContactRow(isOpen: true, contacts: contacts)
                    self.contactDictionary = [contactRow]
//                    for contact in [contacts]{
//                        for con in contact {
//                            var key = String(con.name.characters[sequentialAccess: 0]).uppercased()
//                            
//                            if let _ = self.contactsDictionary[key]{
//                                self.contactsDictionary[key]?.contacts.append(con)
//                            }else{
//                                self.contactsDictionary[key] = ContactRow(isOpen: true, contacts: [con])
//                            }
//                        }
//                    }
                }catch _{
                    
                    print("Failed to Enumerate contacts... ")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        
        navigationItem.title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Handler
    func handleShowIndexPath(){
        var indexPathToReload = [IndexPath]()
        for section in contactDictionary.indices{
            let isOpened = contactDictionary[section].isOpen
            if isOpened{
                indexPathToReload += getIndexPathsForSection(section: section)
            }
        }
        showIndexPath = !showIndexPath
        let animationStyle = showIndexPath ? UITableViewRowAnimation.left : .right
        tableView.reloadRows(at: indexPathToReload, with: animationStyle)
    }
    
    func handleOpenClose(button: UIButton){
        let section = button.tag
        let indexPaths = getIndexPathsForSection(section: section)
        let isOpened = contactDictionary[section].isOpen
        contactDictionary[section].isOpen = !isOpened
        button.setTitle(isOpened ? "Open" : "Close" , for: .normal)
        if isOpened{
            tableView.deleteRows(at: indexPaths, with: .fade)
        }else{
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    //MARK: - Essential Functions
    
    func callLikeOrDislikeFor(cell: ContactCell){
        var indexPath = tableView.indexPath(for: cell)
        let isLiked = contactDictionary[(indexPath?.section)!].contacts[(indexPath?.row)!].isLiked
        contactDictionary[(indexPath?.section)!].contacts[(indexPath?.row)!].isLiked = !isLiked
        
        tableView.reloadRows(at: [indexPath!], with: .fade)
    }
    
    func getIndexPathsForSection(section: Int) -> [IndexPath]{
        var indexPaths = [IndexPath]()
        for row in contactDictionary[section].contacts.indices{
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    
    
    //MARK: - Table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactDictionary.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        button.tag = section
        
        return button
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !contactDictionary[section].isOpen{
            return 0
        }
        return contactDictionary[section].contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellID)
        cell.VC = self
        
        let contact = contactDictionary[indexPath.section].contacts[indexPath.row]
        let name = contact.name
        
        cell.accessoryView?.tintColor = contact.isLiked ? UIColor.green : .darkGray
        cell.detailTextLabel?.text = contact.phone
        if showIndexPath {
            cell.textLabel?.text = "\(name) Section: \(indexPath.section) Row: \(indexPath.row)"
        }else{
            cell.textLabel?.text = name
        }
        
        return cell
    }
}

extension String.CharacterView {
    subscript (sequentialAccess i: Int) -> Character{
        return self[index(startIndex, offsetBy: i)]
    }
}



















