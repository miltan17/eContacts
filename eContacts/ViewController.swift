//
//  ViewController.swift
//  eContacts
//
//  Created by Miltan on 5/26/18.
//  Copyright © 2018 Milton. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellID = "ContactCell"
    var contactDictionary = [ContactRow]()
    var showIndexPath = false
    
    @IBOutlet weak var contactTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTable.dataSource = self
        contactTable.delegate = self
        fetchContacts()
        
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
        contactTable.reloadRows(at: indexPathToReload, with: animationStyle)
    }
    
    
    func handleOpenClose(button: UIButton){
        let section = button.tag
        let indexPaths = getIndexPathsForSection(section: section)
        let isOpened = contactDictionary[section].isOpen
        contactDictionary[section].isOpen = !isOpened
        button.setTitle(isOpened ? "Open" : "Close" , for: .normal)
        if isOpened{
            contactTable.deleteRows(at: indexPaths, with: .fade)
        }else{
            contactTable.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    
    //MARK: - Essential Functions
    func fetchContacts(){
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if error != nil {
                return
            }
            if granted{
                let keyToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keyToFetch as [CNKeyDescriptor])
                request.sortOrder = CNContactSortOrder.givenName
                do{
                    var contacts = [IndividualContact]()
                    try store.enumerateContacts(with: request, usingBlock: { (contact, StopPointerIfYouWantToStopEnumerating) in
                        contacts.append(IndividualContact(isLiked: false, contact: contact))
                    })
                    let contactRow = ContactRow(isOpen: true, contacts: contacts)
                    self.contactDictionary = [contactRow]
                }catch _{
                    print("Failed to Enumerate contacts... ")
                }
            }
        }
    }
    
    
    func callLikeOrDislikeFor(cell: ContactCell){
        var indexPath = contactTable.indexPath(for: cell)
        let isLiked = contactDictionary[(indexPath?.section)!].contacts[(indexPath?.row)!].isLiked
        contactDictionary[(indexPath?.section)!].contacts[(indexPath?.row)!].isLiked = !isLiked
        
        contactTable.reloadRows(at: [indexPath!], with: .fade)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactDictionary.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        button.tag = section
        return button
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDictionary[section].isOpen == false ? 0 : contactDictionary[section].contacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContactCell(style: .subtitle, reuseIdentifier: "contactCell")
        cell.VC = self
        let contact = contactDictionary[indexPath.section].contacts[indexPath.row]
        let name = contact.contact.givenName + " " + contact.contact.familyName
        cell.accessoryView?.tintColor = contact.isLiked ? UIColor.green : .darkGray
        cell.detailTextLabel?.text = contact.contact.phoneNumbers.first?.value.stringValue
        cell.textLabel?.text = showIndexPath == true ? "\(name) Section: \(indexPath.section) Row: \(indexPath.row)" : name
        return cell
    }
 
}

extension String.CharacterView {
    subscript (sequentialAccess i: Int) -> Character{
        return self[index(startIndex, offsetBy: i)]
    }
}














