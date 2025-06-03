//
//  MarketplaceModel.swift
//  FrancalanciaNick_Leasify
//
//  Created by Nicholas on 5/1/21.
//
//  Email : nfrancal@usc.edu

import Foundation
// Google Sign-In API provided by: https://developers.google.com/identity/sign-in/ios
import GoogleSignIn
import CoreData

class MarketplaceModel {
    // singleton design pattern for the overall marketplace listings
    static let shared = MarketplaceModel()
    // collection of all listings in the marketplace
    public var listings = [Listing]()
    // collection of each user's favorite listing (user must be from marketplace)
    public var userFavorites = Dictionary<String,[Listing]>()

    // remove favorite listing method
    func removeFavorite(listing : Listing) {
        // check optional user
        if let user = GIDSignIn.sharedInstance().currentUser {
            // check optional favorites array
            if let array = MarketplaceModel.shared.userFavorites[user.userID] {
                for i in 0..<array.count {
                    if listing.address == array[i].address {
                        MarketplaceModel.shared.userFavorites[user.userID]!.remove(at: i)
                    }
                }
           }
        }
    }
}
