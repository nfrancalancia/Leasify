//
//  ListingVC.swift
//  FrancalanciaNick_Leasify
//
//  Created by Nicholas on 5/2/21.
//
//  Email : nfrancal@usc.edu

import Foundation
import UIKit
// Google Sign-In API provided by: https://developers.google.com/identity/sign-in/ios
import GoogleSignIn

class ListingVC : UIViewController {
    
    // outlets for Listing page
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var listingAddress: UILabel!
    @IBOutlet weak var listingEmail: UILabel!
    @IBOutlet weak var favoriteStar: UIButton!
    @IBOutlet weak var listingBed: UILabel!
    @IBOutlet weak var listingBath: UILabel!
    @IBOutlet weak var listingPrice: UILabel!
    @IBOutlet weak var listingGender: UILabel!
    @IBOutlet weak var listingDates: UILabel!
    
    // public variable for user-selected listing
    public var selectedListing : Listing?
    
    // reference to the persistent container view context
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    // view did load method
    override func viewDidLoad() {
        super.viewDidLoad()
        // date formatter inialization
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        // set the outlets equal to the information in the selected listing
        if let data = selectedListing?.image {
            listingImage.image = UIImage(data: data)
        }

        listingAddress.text = selectedListing?.address
        listingEmail.text = selectedListing?.tenantEmail
        listingPrice.text = selectedListing?.pricePerMonth
        listingGender.text = "Preferred Gender: \(selectedListing?.preferredGender ?? "None")"
        listingDates.text = "Available from: \(dateFormatter.string(from: selectedListing?.dateFrom ?? Date())) to \(dateFormatter.string(from: selectedListing?.dateTo ?? Date()))"
        if let bed = selectedListing?.bed, let bath = selectedListing?.bath {
            listingBed.text = "\(bed) Beds"
            listingBath.text = "\(bath) Bath"
        }
    }
    
    // view will appear method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // before the view loads, know what color the like button will be
        if let testListing = selectedListing {
            if testListing.isFavorite{
                favoriteStar.backgroundColor = .yellow
            }
            else {
                favoriteStar.backgroundColor = .white
            }
        }
    }
    // favorite did tapped method
    @IBAction func favoriteDidTapped(_ sender: UIButton) {
        // check if that listing is already favorited
        if let testListing = selectedListing {
            // if the listing is already favorited, set the like button color to white and isFavorite to false
            if testListing.isFavorite{
                favoriteStar.backgroundColor = .white
                selectedListing?.isFavorite = false
                // remove favorite from userFavorites array of the Marketplace Model
                MarketplaceModel.shared.removeFavorite(listing : testListing)
            }
            // otherwise, set the like button color to yellow and isFavorite to true
            else {
                favoriteStar.backgroundColor = .yellow
                selectedListing?.isFavorite = true
                // append that listing into the userFavorites array of the Marketplace Model
                // avoid duplicate favorite entries
                if let test = MarketplaceModel.shared.userFavorites[GIDSignIn.sharedInstance().currentUser.userID]{
                    if !test.contains(testListing){
                        MarketplaceModel.shared.userFavorites[GIDSignIn.sharedInstance().currentUser.userID]?.append(testListing)
                    }
                }
            }
        }
//        // save with core data
//        do {
//            try context?.save()
//        }
//        catch {
//            print("COULD NOT SAVE NEW LISTING!")
//        }
    }
}
