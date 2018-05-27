//
//  ViewController.swift
//  eContacts
//
//  Created by Miltan on 5/26/18.
//  Copyright © 2018 Milton. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let cellID = "ContactCell"
    
    var contactDictionary = [
        ContactRow(isOpen: true, contacts: ["Aminul", "Arif","Asif","Anwar"].map{IndividualContact(isLiked: false, name: $0)}),
        ContactRow(isOpen: true, contacts: ["Bashir", "Badhon","Biddut"].map{IndividualContact(isLiked: false, name: $0)}),
        ContactRow(isOpen: true, contacts: ["Chandler","Chris"].map{IndividualContact(isLiked: false, name: $0)}),
        ContactRow(isOpen: true, contacts: [IndividualContact(isLiked: false, name: "Diba"), IndividualContact(isLiked: false, name: "Dipu")])
    ]
    
    
    var showIndexPath = false
    
    func fetchContacts(){
        let device = Device();
        device.fetchContacts()
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
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ContactCell
        cell.VC = self
        
        let contact = contactDictionary[indexPath.section].contacts[indexPath.row]
        let name = contact.name
        
        cell.accessoryView?.tintColor = contact.isLiked ? UIColor.green : .darkGray
        
        if showIndexPath {
            cell.textLabel?.text = "\(name) Section: \(indexPath.section) Row: \(indexPath.row)"
        }else{
            cell.textLabel?.text = name
        }
        
        return cell
    }
}




















