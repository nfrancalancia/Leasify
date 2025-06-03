////
////  Listing.swift
////  FrancalanciaNick_Leasify
////
////  Created by Nicholas on 4/29/21.
////
//
//import Foundation
//import UIKit
//import CoreData
//
//// object for each available house leasing
//class Listing {
//
//    // variables for each listing
//    public var address : String
//    public var pricePerMonth : String
//    public var tenantEmail : String
//    public var dateTo : Date
//    public var dateFrom : Date
//    public var bed : Int
//    public var bath : Double
//    public var image : Data?
//    public var preferredGender : String
//    public var isFavorite : Bool
//
//    init(address : String, pricePerMonth : String, tenantEmail : String, bed : Int, bath : Double, dateFrom : Date, dateTo : Date, image : Data?, preferredGender : String,isFavorite : Bool) {
//        self.address = address
//        self.pricePerMonth = pricePerMonth
//        self.tenantEmail = tenantEmail
//        self.dateTo = dateTo
//        self.dateFrom = dateFrom
//        self.bed = bed
//        self.bath = bath
//        self.image = image
//        self.preferredGender = preferredGender
//        self.isFavorite = isFavorite
//    }
//
//    func getImage() -> Data? {
//        return self.image
//    }
//
//}
//
//extension Listing {
//    // initializor
////    convenience init(address : String, pricePerMonth : String, tenantEmail : String, bed : Int, bath : Double, dateFrom : Date, dateTo : Date, image : UIImage, preferredGender : String, isFavorite : Bool) {
////        self.address = address
////        self.pricePerMonth = pricePerMonth
////        self.tenantEmail = tenantEmail
////        self.bed = bed
////        self.bath = bath
////        self.dateFrom = dateFrom
////        self.dateTo = dateTo
////        self.image = image
////        self.preferredGender = preferredGender
////        self.isFavorite = false
////    }
////

//}
