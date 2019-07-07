//
//  ContactsTableViewController.swift
//  HotelManzana
//
//  Created by Alexander on 07/07/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    let storageManager = StorageManager()
    var contacts = [Registration]() {
        didSet {
            storageManager.save(contacts: contacts)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = storageManager.load() ?? []
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
    }
}

// MARK: - ContactsTableViewControllerDataSource
extension ContactsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = "\(contact.lastName) \(contact.firstName)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedContact = contacts.remove(at: sourceIndexPath.row)
        contacts.insert(movedContact, at: destinationIndexPath.row)
        tableView.reloadData()
    }
}

// MARK: - ContactsTableViewControllerDelegate
extension ContactsTableViewController {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            contacts.remove(at: indexPath.row)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let registrationController = storyboard!.instantiateViewController(withIdentifier: "RegistrationControllerID") as! RegistrationViewController
        registrationController.contact = contacts[indexPath.row]
        
        navigationController?.pushViewController(registrationController, animated: true)
    }
}
