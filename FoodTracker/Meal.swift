//
//  Meal.swift
//  FoodTracker
//
//  Created by Fibiolla Plaath on 01/04/2021.
//

import UIKit //Also gives access to Foundation framework
import os.log //Unified logging system

class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    
    /// Defines basic properties for the data needed to store.
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archiving Paths
    
    //Persistent path on file system where data will be saved & loaded
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    
    struct PropertyKey {
        
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK: Initialization
    //Initializer prepares an instance of a class for use
    
    init?(name: String, photo: UIImage?, rating: Int) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
         
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        //Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    // ? - Failable initializer that might return nil
    required convenience init?(coder aDecoder: NSCoder) {
        
        /*decodeObject() decodes encoded info
        //Guard statement both unwraps optional & downcasts enclosed type to String
        */
 
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            
            return nil
        }
        
        //Photo is an optional property of Meal, use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        //Must call designated initializer
        self.init(name: name, photo: photo, rating: rating)
    }
}
