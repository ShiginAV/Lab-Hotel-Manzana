//
//  RegistrationViewController.swift
//  HotelManzana
//
//  Created by Alexander on 01/07/2019.
//  Copyright © 2019 Alexander Shigin. All rights reserved.
//

import UIKit

class RegistrationViewController: UITableViewController {
    let checkInDateLabelIndexPath = IndexPath(row: 0, section: 1)
    let checkInDatePikerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDateLabelIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePikerIndexPath = IndexPath(row: 3, section: 1)
    let roomTypeSelectionIndexPath = IndexPath(row: 0, section: 4)
    
    var isCheckInDatePikerShown = false {
        didSet {
            checkInDatePiker.isHidden = !isCheckInDatePikerShown
        }
    }
    
    var isCheckOutDatePikerShown = false {
        didSet {
            checkOutDatePiker.isHidden = !isCheckOutDatePikerShown
        }
    }
    
    var selectedRoomType: RoomType? {
        didSet {
            roomTypeLabel.text = selectedRoomType?.name
        }
    }
    
    var contact: Registration?
    
    //MARK: - Outlets
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePiker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePiker: UIDatePicker!
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    @IBOutlet var wifiSwitch: UISwitch!
    @IBOutlet var roomTypeLabel: UILabel!
    
    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contact = contact {
            firstNameTextField.text = contact.firstName
            lastNameTextField.text = contact.lastName
            emailTextField.text = contact.emailAddress
            checkInDatePiker.date = contact.checkInDate
            checkOutDatePiker.date = contact.checkOutDate
            numberOfAdultsStepper.value = Double(contact.numberOfAdults)
            numberOfChildrenStepper.value = Double(contact.numberOfChildren)
            wifiSwitch.isOn = contact.wifi
            selectedRoomType = contact.roomType
        }

        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePiker.minimumDate = midnightToday
        checkInDatePiker.date = midnightToday
        
        updateDoneBarButton()
        updateDateViews()
        updateNumberOfGuests()
    }
    
    func updateDoneBarButton() {
        doneBarButton.isEnabled =
            !firstNameTextField.text!.isEmpty &&
            !lastNameTextField.text!.isEmpty &&
            !emailTextField.text!.isEmpty &&
            !roomTypeLabel.text!.isEmpty
    }
    
    func updateDateViews() {
        checkOutDatePiker.minimumDate = checkInDatePiker.date.addingTimeInterval(60 * 60 * 24)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = .current
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePiker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePiker.date)
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    //MARK: - Actions
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateDoneBarButton()
    }
    
    @IBAction func doneBarButtonAction(_ sender: UIBarButtonItem) {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: true)
        guard let contactsController = navigationController.viewControllers.last as? ContactsTableViewController else { return }
        
        var registration = Registration()
        registration.firstName = firstNameTextField.text ?? ""
        registration.lastName = lastNameTextField.text ?? ""
        registration.emailAddress = emailTextField.text ?? ""
        registration.checkInDate = checkInDatePiker.date
        registration.checkOutDate = checkOutDatePiker.date
        registration.numberOfAdults = Int(numberOfAdultsStepper.value)
        registration.numberOfChildren = Int(numberOfChildrenStepper.value)
        registration.wifi = wifiSwitch.isOn
        if let selectedRoomType = selectedRoomType { registration.roomType = selectedRoomType }
        
        if let indexPath = contactsController.tableView.indexPathForSelectedRow {
            contactsController.contacts[indexPath.row] = registration
        } else {
            contactsController.contacts.append(registration);
        }
        contactsController.tableView.reloadData()
    }
    
    @IBAction func datePikerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    @IBAction func steperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
}

extension RegistrationViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePikerIndexPath:
            return isCheckInDatePikerShown ? UITableView.automaticDimension : 0
            
        case checkOutDatePikerIndexPath:
            return isCheckOutDatePikerShown ? UITableView.automaticDimension : 0
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        
        switch indexPath {
        case checkInDateLabelIndexPath:
            isCheckInDatePikerShown.toggle()
            if isCheckInDatePikerShown {
                isCheckOutDatePikerShown = false
            }
            
        case checkOutDateLabelIndexPath:
            isCheckOutDatePikerShown.toggle()
            if isCheckOutDatePikerShown {
                isCheckInDatePikerShown = false
            }
            
        case roomTypeSelectionIndexPath:
            let roomTypeController = storyboard!.instantiateViewController(withIdentifier: "RoomTypeID") as! RoomTypeTableViewController
            roomTypeController.selectedRoomType = selectedRoomType
            navigationController?.pushViewController(roomTypeController, animated: true)
        default:
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
