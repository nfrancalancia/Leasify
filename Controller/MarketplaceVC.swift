//
//  MarketplaceVC.swift
//  FrancalanciaNick_Leasify
//
//  Created by Nicholas on 4/28/21.
//
//  Email : nfrancal@usc.edu

import Foundation
import UIKit
// Google Sign-In API provided by: https://developers.google.com/identity/sign-in/ios
import GoogleSignIn
import CoreData

class MarketplaceVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
   
    // collection view outlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // reference to the persistent container view context
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    // viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // creates the custom collection view layout
        self.collectionView.collectionViewLayout = createLayout()
        self.fetchListings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // restores the previous sign-in
        GIDSignIn.sharedInstance().restorePreviousSignIn()
        // creates the custom collection view layout
        self.collectionView.collectionViewLayout = createLayout()
        self.fetchListings()
    }
    
    func fetchListings(){
        do{
            MarketplaceModel.shared.listings = try context?.fetch(Listing.fetchRequest()) as! [Listing]
            for i in 0..<MarketplaceModel.shared.listings.count {
                MarketplaceModel.shared.listings[i].isFavorite = false
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }catch{
            print("Could not fetch request")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // always 1 section for aggregate listings
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // contains the total number of listings in the array
        return MarketplaceModel.shared.listings.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // casts the selected cell as a collection view cell
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        // if there are listings in the marketplace...
        if MarketplaceModel.shared.listings.count > 0 {
            // sets the listing image from the model to the image view and sets appropriate address and price labels
            if let image = MarketplaceModel.shared.listings[indexPath.row].getImage() {
                cell.imageView.image = UIImage(data: image)
            }
            cell.addressLabel.text = MarketplaceModel.shared.listings[indexPath.row].address
            cell.priceLabel.text = MarketplaceModel.shared.listings[indexPath.row].pricePerMonth
        }
        // returns the cell for the delegate to generate
        return cell
    }
    
    // Apple's compositional layout guide, provided by : https://developer.apple.com/videos/play/wwdc2019/215/
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }
    
    // prepare for segue function when a user clicks on a listing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if there is a current user signed in...
        if let _ = GIDSignIn.sharedInstance().currentUser{
            // check if the segue identifier is equal to "loadListing"
            if segue.identifier == "loadListing" {
                // set segue destination to Listing VC
                let listing = segue.destination as! ListingVC
                // set the selectedListing for ListingVC as the selected listing in the marketplace model
                listing.selectedListing = MarketplaceModel.shared.listings[collectionView.indexPathsForSelectedItems!.first!.row]
            }
        }
        // if there is not an existing user...
        else{
            // create an alert saying that the user can not perform any segues w/o signing in
            let alert = UIAlertController(title: "Please Sign In at Profile", message: "Add/View Disabled :(", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
      
    }
    
    
}
