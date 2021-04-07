//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Fibiolla Plaath on 26/03/2021.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase
{
    //MARK: Meal Class Tests
    
    //Confirms that Meal initializer returns Meal object when passed valid parameters
    func testMealInitializationSucceeds()
    {
        //Zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        //Highest positive rating
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    //Confirms that Meal initializer returns nil when passed a - rating or empty name
    func testMealInitializationFails()
    {
        //Negative rating
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        //Rating exceeds max
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        //Empty String
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
    }
    
}
