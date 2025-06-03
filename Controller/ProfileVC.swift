//
//  ProfileVC.swift
//  FrancalanciaNick_Leasify
//
//  Created by Nicholas on 4/27/21.
//
//  Email : nfrancal@usc.edu

import Foundation
import UIKit
// Google Sign-In API provided by: https://developers.google.com/identity/sign-in/ios
import GoogleSignIn
// Message UI framework for email composition provided by: https://developer.apple.com/documentation/messageui
import MessageUI
import SafariServices

class ProfileVC : UIViewController, GIDSignInDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        // checks whether the text message has sent, cancelled, or failed
        
        // MessageComposeResult enums represent the possible results
        
        // this function is called everytime the user finishes composing a message
        switch result {
            case MessageComposeResult.sent:
                print("User sent message!")
            case MessageComposeResult.failed:
                print("Message Failed!")
            case MessageComposeResult.cancelled:
                print("Message Cancelled!")
        default:
            break
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    // IBOutlets for profile page
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var idLabel : UILabel!
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var myFavoritesLabel: UILabel!
    @IBOutlet weak var contactUsButton: UIButton!
    
    // reference to the persistent container view context
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    //let userDefaults = UserDefaults.standard
    
    // view did load method
    override func viewDidLoad() {
        super.viewDidLoad()
        // override these methods in viewDidLoad
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance().delegate = self
        
        // if the user has signed in, their information and only the sign-out button will show
        if let name = GIDSignIn.sharedInstance().currentUser?.profile.givenName {
            // if a user is still signed in... the sign-out button will be shown and not the sign-in
            signOutButton.isHidden = false
            signInButton.isHidden = true
            // make the welcome label fill in other appropriate labels
            welcomeLabel.text =  "Welcome back!"
            givenNameLabel.text = "Given Name: " + name
            familyNameLabel.text = "Family Name: " + GIDSignIn.sharedInstance().currentUser.profile.familyName
            emailLabel.text = "Email address: " + GIDSignIn.sharedInstance().currentUser.profile.email
            idLabel.text = "User ID: " + GIDSignIn.sharedInstance().currentUser.userID
            
            // check if the user has a profile image
            if GIDSignIn.sharedInstance().currentUser.profile.hasImage {
                do {
                    // load the data from the user's Google account
                    let data = try Data(contentsOf: GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 300))
                    profileImage.image = UIImage(data: data)
                } catch {
                    // print statement on console if there is not an image
                    print("No profile image")
                }
            }
        }
        // if the user has not signed in, the only pieces visible should be sign-in button and contact us button
        else {
            signOutButton.isHidden = true
            welcomeLabel.isHidden = true
            givenNameLabel.isHidden = true
            familyNameLabel.isHidden = true
            favoriteTableView.isHidden = true
            emailLabel.isHidden = true
            myFavoritesLabel.isHidden = true
            idLabel.isHidden = true
            profileImage.isHidden = true
        }
        self.favoriteTableView.reloadData()
    }
    
    // view will appear method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // program remembers the previous sign-in
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        // if there is an existing user, we reload the data of the table view
        if let _ = GIDSignIn.sharedInstance().currentUser {
            DispatchQueue.main.async {
                self.favoriteTableView.reloadData()
            }
        }
    }
    
    // table view content methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = GIDSignIn.sharedInstance().currentUser {
            if let favorites = MarketplaceModel.shared.userFavorites[GIDSignIn.sharedInstance().currentUser.userID] {
                // profile table view has as many items as the user has favorites
                return favorites.count
            }
        }
        return 0
    }
    
    // table view controller functions and material
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite", for: indexPath)
        
        if let favorites = MarketplaceModel.shared.userFavorites[GIDSignIn.sharedInstance().currentUser.userID] {
            if favorites.count > 0 {
                cell.textLabel?.text = favorites[indexPath.row].address
            }
        }
    
        return cell
    }
    
    // User successfully (or unsuccessfully) signs in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // sign-in error branch
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            }
            else {
                print("\(error.localizedDescription)")
            }
            // exit the sign-in
            return
        }
        
        // if the signed in user already has a key->value pair for their favorites, we reload their data
        if let _ = MarketplaceModel.shared.userFavorites[GIDSignIn.sharedInstance().currentUser.userID]{
            self.favoriteTableView.reloadData()
        }
        else {
            // otherwise, we assign an empty list to the new user as their favorites list
            MarketplaceModel.shared.userFavorites[GIDSignIn.sharedInstance().currentUser.userID] = [Listing]()
        }
        // check optional user again, and set labels and isHidden's for buttons appropriately
        if let user = GIDSignIn.sharedInstance().currentUser {
            welcomeLabel.text =  "Welcome back!"
            givenNameLabel.text = "Given Name: " + user.profile.givenName
            familyNameLabel.text = "Family Name: " + GIDSignIn.sharedInstance().currentUser.profile.familyName
            emailLabel.text = "Email address: " + GIDSignIn.sharedInstance().currentUser.profile.email
            idLabel.text = "User ID: " + GIDSignIn.sharedInstance().currentUser.userID
            welcomeLabel.isHidden = false
            myFavoritesLabel.isHidden = false
            favoriteTableView.isHidden = false
            givenNameLabel.isHidden = false
            familyNameLabel.isHidden = false
            emailLabel.isHidden = false
            idLabel.isHidden = false
            signOutButton.isHidden = false
            profileImage.isHidden = false
            signInButton.isHidden = true
            // check if the user has a profile image
            if user.profile.hasImage {
                do {
                    // load the image onto the image view, if so
                    let data = try Data(contentsOf: user.profile.imageURL(withDimension: 200))
                    profileImage.image = UIImage(data: data)
                } catch {
                    print("No profile image")
                }
            }
        }
    }
    
    // user did tap sign out
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        // GID sign-out method
        GIDSignIn.sharedInstance().signOut()
        // update appropriate isHidden's for labels and buttons
        welcomeLabel.isHidden = true
        givenNameLabel.isHidden = true
        familyNameLabel.isHidden = true
        myFavoritesLabel.isHidden = true
        emailLabel.isHidden = true
        favoriteTableView.isHidden = true
        idLabel.isHidden = true
        profileImage.isHidden = true
        signOutButton.isHidden = true
        signInButton.isHidden = false
    }
    
    // contact button did tapped --> NOTE: The iOS simulator can not send emails or text messages, so this must be checked with a device
    @IBAction func contactButtonDidTapped(_ sender: UIButton) {
        // if the device is able to send emails, sets a Compose View Controller from MessageUI and default subject line and recipient
        let alert = UIAlertController(title: "Contact Us:", message: "Choose method:", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Email", style: .default) { action in
            if MFMailComposeViewController.canSendMail() {
                let emailVC = MFMailComposeViewController()
                emailVC.delegate = self
                emailVC.setSubject("Contact us for Inquiries!")
                emailVC.setToRecipients(["nfrancal@usc.edu"])
                // presents that view controller to the view
                self.present(UINavigationController(rootViewController: emailVC), animated: true, completion: nil)
            }
            // if the device can not send emails (like the simulator), sets a SFSafari web view controller and presents it to the view
            else {
                guard let url = URL(string: "https://outlook.com") else {
                    return
                }
                let simulatorWebVC = SFSafariViewController(url : url)
                self.present(simulatorWebVC, animated: true)
            }
        }
        let action2 = UIAlertAction(title: "Text", style: .default) { action in
            // if the device is able to send texts, sets a Compose View Controller from MessageUI and default subject and recipient
            if MFMessageComposeViewController.canSendText() && MFMessageComposeViewController.canSendSubject(){
                    let messageVC = MFMessageComposeViewController()
                    messageVC.delegate = self
                    messageVC.subject = "Leasify Inquiry"
                    messageVC.recipients = ["7742492257"]
                // presents that view controller to the view
                self.present(UINavigationController(rootViewController: messageVC), animated: true, completion: nil)
            }
            // otherwise the simulator and other incompatible devices will go straight to groupme
            else {
                guard let url = URL(string: "https://groupme.com") else {
                    return
                }
                let simulatorWebVC = SFSafariViewController(url : url)
                self.present(simulatorWebVC, animated: true)
            }
        }
        let action3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        // present the alert modally through the tab bar controller
        tabBarController?.present(alert, animated: true,completion: nil)
    }
}
