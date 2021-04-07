//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Fibiolla Plaath on 06/04/2021.
//

import UIKit
import os.log //Unified logging system

class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    
    //Declares and initializes property with default value
    var meals = [Meal] ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Load any saved meals, otherwise load sample data
        if let savedMeals = loadMeals() { 
            
            meals += savedMeals
            
        } else {
            
            //Load sample data
            loadSampleMeals()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //Makes table view show 1 section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Returns # of meals
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Table view cells are resued & should be dequeued using cell identifier
        let cellIdentifier = "MealTableViewCell"
        
        
        //Downcast type of cell to custom cell subclass
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        //Fetches appropriate meal from meals array
        let meal = meals[indexPath.row]

        //Sets views in table view cell to display to display corresponding data from meal object
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals() //saves meals array whenever a meal is deleted
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
 // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Call to superclass's implementation
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
            if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
                
                //Gets executed when existing meal is edited
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    
                    //Updates meals array
                    meals[selectedIndexPath.row] = meal
                    //Reloads appropriate row in table view
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    
                } else {
                
                    //Adds new meal
                    let newIndexPath = IndexPath(row: meals.count, section: 0)
                    
                    //Adds new meal to existing list of meals in data model
                    meals.append(meal)
                        tableView.insertRows(at: [newIndexPath], with: .automatic)
                    
                }
                
                //Save the meals
                saveMeals()
        }
    }
    
    //MARK: Private Methods
    
    //Helper method to load sample data into app
    private func loadSampleMeals() {
        
        //Loads 3 meal images
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        //Creates 3 meal objects
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unalbe to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal3")
        }
        
        //Adds Meal objects to meals array
        meals += [meal1, meal2, meal3]
        
    }
    
    //Attempts to archive meals array to specific location & returns true if successful
    private func saveMeals() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        
        //Logs a debug mess to console if save succeeds & error mess to console if save fails
        if isSuccessfulSave {
            
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
         
        //Attempts to unarchive object stored & downcast that object to array of Meal objects
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }

}
