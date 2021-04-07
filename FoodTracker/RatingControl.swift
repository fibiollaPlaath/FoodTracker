//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Fibiolla Plaath on 31/03/2021.
//
// Custom view subclass of UIView

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    
    private var ratingButtons = [UIButton] ()
    
    var rating = 0 {
        
        //PROPERTY OBSERVER: Observes and responds to changes
        didSet {
            
            //Whenever ratings changes
            updateButtonSelectionStates()
        }
    }
    
    //Define size of buttons & # of buttons in my control
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        
        didSet {
            
            //Adds new buttons using updated size & count
            setupButtons()
        }
        
    }
    
    @IBInspectable var starCount: Int = 5 {
        
        didSet {
            
            //Adds new buttons using updated size & count
            setupButtons()
        }
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        
        //Calls superclass's initializer
        super.init(frame: frame)
        setupButtons()
    }
    
        required init(coder: NSCoder) {
            
            super.init(coder: coder)
            setupButtons()
        }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: button) else {
            
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        //Calculates the rating of selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            
            //If selected star represents current rating, reset rating to 0
            rating = 0
        } else {
            
            //Otherwise set rating to selected star
            rating = selectedRating
        }
        
    }
    
    //MARK: Private Methods
    
    private func setupButtons() {
        
        //Clear out existing buttons
        for button in ratingButtons {
            
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        //Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        //for-in loop iterates over a sequence
        for index in 0..<starCount {
            
            //Create button
            let button = UIButton()
            
            //Set button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            //ADDS CONSTRAINTS
            button.translatesAutoresizingMaskIntoConstraints = false //Removes button's autogenerated constraints
            
            //Defines button's height & width as fixed size
            //isActive property activates the constraint
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Sets accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            //Setup button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            //Adds button to stack
            addArrangedSubview(button)
            
            //New button added to rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    //Update selection states of buttons
    private func updateButtonSelectionStates() {
        
        for (index, button) in ratingButtons.enumerated() {
            
            //If index of button is < than rating, that button should be selected
            button.isSelected = index < rating
            
            //Sets hint string for currently selected star
            let hintString: String?
            if rating == index + 1 {
                
                hintString = "Tap to reset the rating to zero."
            } else {
                
                hintString = nil
            }
            
            //Calculates value string
            let valueString: String
            
            switch (rating) {
            
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            //Assigns hintString & valueString
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}