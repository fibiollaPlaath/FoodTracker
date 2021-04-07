//
//  Meal.swift
//  FoodTracker
//
//  Created by Fibiolla Plaath on 01/04/2021.
//

//UIKit also gives you access to Foundation
import UIKit

class Meal {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
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
}
