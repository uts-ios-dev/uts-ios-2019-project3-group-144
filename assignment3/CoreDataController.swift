

import Foundation
import CoreData

// controller containing core data functions (CRUD)
class CoreDataController {
    
    // function to randomly generate unique id for recipe
    static func generateId() -> Int {
        let id: Int = Int(arc4random())
        
        // todo: implement code to ensure id is unique (jacob)
        
        return id
    }
    
    // function to get recipe data
    static func getRecipeData(delegate: AppDelegate) -> [NSManagedObject] {
        
        // array to contain recipes
        var recipes: [NSManagedObject] = []
        
        // setup context and fetch request
        let context = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RecipeData")
        
        // attempt to fetch recipe data
        do { recipes = try context.fetch(fetchRequest) }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
        
        // return the recipes
        return recipes
    }
    
    // function to get single recipe
    static func getRecipe(delegate: AppDelegate, id: Int) -> NSManagedObject {
        
        // get recipes
        let recipeData = getRecipeData(delegate: delegate)
        
        // return recipe that has the matching id
        for data in recipeData {
            if (data.value(forKey: "id") as? Int == id) {
                return data
            }
        }
        
        // if there are no recipes, return a null object
        return NSManagedObject()
        
    }
    
    // function to save recipe to core data
    static func saveRecipeData(delegate: AppDelegate, recipe: Recipe) {
        
        // set up context and entity data
        let context = delegate.persistentContainer.viewContext
        let entity =   NSEntityDescription.entity(forEntityName: "RecipeData", in: context)!
        
        // create object to be saved
        let recipeData = NSManagedObject(entity: entity, insertInto: context)
        
        // insert values into objectg
        recipeData.setValue(recipe.name, forKey: "name")
        recipeData.setValue(recipe.prepTime, forKey: "prepTime")
        recipeData.setValue(recipe.cookingTime, forKey: "cookingTime")
        recipeData.setValue(recipe.ingredients, forKey: "ingredients")
        recipeData.setValue(recipe.methods, forKey: "methods")
        
        // attempt to save new recipe to core data
        do { try context.save() }
        catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
    }
    
    // todo: implement function to update existing recipe (andy)
    static func updateRecipeData() {
        
    }
}
