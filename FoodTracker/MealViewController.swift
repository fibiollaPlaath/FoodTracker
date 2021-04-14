//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Fibiolla Plaath on 26/03/2021.
//

import UIKit
import os.log //Imports unified logging system (Allows sending of messages to console)

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    
    /// Outlets let you refer to interface elements in code. References in storyboard.
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by 'MealTableViewController' in
     'prepare(for: sender: )'
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    /// Called when UI is created & loaded on the screen.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        //Set up views if editing an existing Meal
        if let meal = meal {
            
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        //Enable Save button only if text field has a valid Meal name
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    /// Text field calls this method whenever user taps return button and then dismisses keyboard
    /// - Parameter textField: Text field whose return button was pressed
    /// - Returns: boolean value. Whether system should process the press of return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder() //Hide keyboard
        
        return true
    }
    
    //Gets called when editing session begins. Disables Save button while user is editing text field.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //Disable Save button while editing
        saveButton.isEnabled = false
    }
    
    /// Gives a chance to read info entered into text field & change value of label. Gets called after textFieldShouldReturn()
    /// - Parameter textField: Text field for which editing ended.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        updateSaveButtonState() //Checks if text field has text in it, which enables Save button if it does.
        navigationItem.title = textField.text //Sets title of scene to that text
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    /// Tells delegate that user cancelled pick photo operation
    /// - Parameter picker: Controller object managing image picker interface
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //Dismiss the picker if the user cancelled
        dismiss(animated: true, completion: nil)
    }
    
    /// Called when user selects photo & dismiss picker view
    /// - Parameters:
    ///   - picker: Controller object managing image picker interface
    ///   - info: Dictionary containing original image & edited image. Contains relevant editing info
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        //Info dictionary may contain multiple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        //Set photoImage to display the selected image
        photoImageView.image = selectedImage
        
        //Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        //Depending on style of presentation (modal/push), view controller needs to be dismissed in 2 ways
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            
            //Method dismiss modal scene & animates transition back to previous scene
            dismiss(animated: true, completion: nil)
            
        }
        
        /* Called when user is editing an existing meal.
           Unwraps view controller's navigationController property.
           popViewController() pops current view controller off navigation stack & animates the transition.
           Dismisses meal detail scene & returns user to meal list
         */
 
        else if let owningNavigationController = navigationController {
            
            owningNavigationController.popViewController(animated: true)
            
        } else {
            
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    //Allows configuration of view controller before its presented
    override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
        
        //Call to superclass's implementation
        super.prepare(for: seque, sender: sender)
        
        /*Configure the destination view controller only when the save button is pressed.
         === checks that the objects referenced by sender & saveButton outlets are the same. If not, else statement is executed.
         */
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
           
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            
            return
        }
        
        //Creates constants from current text field text
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        /*Set meal to be passed to MealTableViewController after the unwind segue. Configures meal property with appropriate values before segue executes.
         */
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    //MARK: Actions
    
    
    /// Gesture recognizer connected
    /// - Parameter sender: Interprets single or multiple taps
    @IBAction func selectImageFromPhotolibrary(_ sender: UITapGestureRecognizer) {
        
        //Hide keyboard
        nameTextField.resignFirstResponder() //If user taps image view while typing, keyboard is dismissed properly
        
        //UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        //Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        
        //Ensures view controller is notified when user picks image
        imagePickerController.delegate = self
        present (imagePickerController, animated: true, completion: nil) //Method being called on ViewController
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        
        //Helper meethod disable Save button if text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}


