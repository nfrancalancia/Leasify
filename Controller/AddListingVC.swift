//
//  AddListingVC.swift
//  FrancalanciaNick_Leasify
//
//  Created by Nicholas on 4/28/21.
//
//  Email : nfrancal@usc.edu

import Foundation
import UIKit
// Google Sign-In API provided by: https://developers.google.com/identity/sign-in/ios
import GoogleSignIn
// Message UI framework for email composition provided by: https://developer.apple.com/documentation/messageui
import MessageUI
import CoreData

class AddListingVC : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // outlets for AddListingVC
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var choosePhotoButton: UIButton!
    @IBOutlet weak var addressTextField : UITextField!
    @IBOutlet weak var priceTextField : UITextField!
    @IBOutlet weak var bedLabel: UILabel!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var bathLabel: UILabel!
    @IBOutlet weak var bathStepper: UIStepper!
    @IBOutlet weak var bedStepper: UIStepper!
    @IBOutlet weak var dateFromPicker: UIDatePicker!
    @IBOutlet weak var dateToPicker: UIDatePicker!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    // reference to the persistent container view context
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    // view did load method
    override func viewDidLoad() {
        super.viewDidLoad()
        // restores previos Google Sign-in
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    // function for image picker controller for PhotoKit
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[.originalImage] as? UIImage
        mainImageView.image = originalImage
        choosePhotoButton.isHidden = true
        mainImageView.backgroundColor = .white
        picker.dismiss(animated: true)
    }

    // image button did tapped
    @IBAction func imageButtonDidTapped(_ sender: UIButton) {
        // creates a UIImagePickerController
        let picker = UIImagePickerController()
        // sets the delegate as itself
        picker.delegate = self
        // sets allowsEditing to true
        picker.allowsEditing = true
        // allows access to the photo library
        picker.sourceType = .photoLibrary
        // presents that pickerView to the user
        present(picker, animated: true, completion: nil)
    }
    
    // bed stepper method
    @IBAction func bedStepper(_ sender: UIStepper) {
        // bed label automatically updates
        bedLabel.text = "Bed: " + String(Int(sender.value))
    }
    
    // bath stepper method
    @IBAction func bathStepper(_ sender: UIStepper) {
        bathLabel.text = "Bath: \(sender.value)"
    }
    
    // save button did tapped method
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        // check if all optional values for inputs are there
        if let address = addressTextField.text, let price = priceTextField.text, let tenantEmail = emailTextField.text, let image = mainImageView.image, price.count > 0 && tenantEmail.count > 0 && address.count > 0 {
            if let context = context {
                let newListing = Listing(context: context)
                newListing.address = address
                newListing.pricePerMonth = price
                newListing.tenantEmail = tenantEmail
                newListing.bed = Int32(Int(bedStepper.value))
                newListing.bath = bathStepper.value
                newListing.dateTo = dateToPicker.date
                newListing.dateFrom = dateFromPicker.date
                newListing.image = image.pngData()
                newListing.preferredGender = genderSegmentedControl.titleForSegment(at:genderSegmentedControl.selectedSegmentIndex) ?? "None"
                newListing.isFavorite = false
                MarketplaceModel.shared.listings.append(newListing)
                
                do {
                    try context.save()
                }
                catch {
                    print("COULD NOT SAVE NEW LISTING!")
                }
            }
        }
        else {
            // alert that there is missing data
            let alert = UIAlertController(title: "Missing Information", message: "Please make sure all fields are completed.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // cancel button did tapped function
    @IBAction func cancelButtonDidTapped(_ sender: Any) {
        resignFirstResponder()
        // dismisses the view controller and does not save the data
        dismiss(animated: true, completion: nil)
    }
    
}

