//
//  RecipeListViewController.swift
//  assignment3
//
//  Created by Jacob Efendi on 5/18/19.
//  Copyright © 2019 group144. All rights reserved.
//Commit

import UIKit

// view controller to view recipe list
class RecipeListViewController: UIViewController {

    // outlets
    @IBOutlet weak var recipeSearchBr: UISearchBar!
    @IBOutlet weak var recipeTblView: UITableView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    // array for recipes
    var recipes: [Recipe] = []
    var originalRecipes: [Recipe] = []
    var sortedByTimeMax: [Recipe] = []
    var sortedByTimeMin: [Recipe] = []
    var sortedAlphabetically: [Recipe] = []
    
    // function called when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        recipeTblView.tableFooterView = UIView(frame: CGRect.zero)
        getRecipes()
        if (recipes.count < 1) { btnMenu.isEnabled = false }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // if all data has been deleted, update the recipe list and tableview
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if (CoreDataController.isDataEmpty(delegate: delegate)) {
            recipes = []
            recipeTblView.reloadData()
            getRecipes()
            recipeTblView.reloadData()
        }
        
        self.tabBarController?.tabBar.isHidden = false
        if (recipes.count < 1) { btnMenu.isEnabled = false }
    }
    
    // function called before sefue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if segue is to the view recipe view, get recipe data from selected tablecell
        if (segue.identifier == "RecipeListToViewRecipe") {
            if let indexPath = sender as? IndexPath {
                let recipe = recipes[indexPath.row]
                let dest = segue.destination as! ViewRecipeViewController
                dest.recipe = recipe
            }
        }
    }
    
    // function to get the recipe data from the core data
    func getRecipes() {
        
        // get the view delegate
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // get the recipe data
        let recipeData = CoreDataController.getRecipeData(delegate: delegate)
        
        // create recipe objects based off the recipe data
        for data in recipeData {
            
            // initialise recipe variables
            let id = data.value(forKey: "id") as? Int ?? 0
            let name = data.value(forKey: "name") as? String ?? "NULL"
            let imageName = data.value(forKey: "imageName") as? String ?? "NULL"
            let prepTime = data.value(forKey: "prepTime") as? Int ?? 0
            let cookingTime = data.value(forKey: "cookingTime") as? Int ?? 0
            let ingredients = data.value(forKey: "ingredients") as? [String] ?? []
            let methods = data.value(forKey: "methods") as? [String] ?? []
            
            // create the recipe and add it to the recipe list
            let recipe = Recipe(id: id, name: name, imageName: imageName, prepTime: prepTime, cookingTime: cookingTime, ingredients: ingredients, methods: methods)
            recipes.append(recipe)
        }
        
        originalRecipes = recipes
        sortedByTimeMax = recipes.sorted(by: { $0.prepTime > $1.prepTime })
        sortedByTimeMin = recipes.sorted(by: { $0.prepTime < $1.prepTime })
        sortedAlphabetically = recipes.sorted(by: { $0.name < $1.name })
    }
    
    @IBAction func onPressSortBtn(_ sender: Any) {
        showActionSheet()
    }
    
    
    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: "sort recipes", message: "", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let orignal = UIAlertAction(title: "by date created", style: .default) { action in
            self.recipes = self.originalRecipes
            self.recipeTblView.reloadData()
        }
        
        let timeSortMax = UIAlertAction(title: "by time (max - min)", style: .default) { action in
            self.recipes = self.sortedByTimeMax
            self.recipeTblView.reloadData()
        }
        
        let timeSortMin = UIAlertAction(title: "by time (min - max)", style: .default) { action in
            self.recipes = self.sortedByTimeMin
            self.recipeTblView.reloadData()
        }
        
        let alphabetically = UIAlertAction(title: "by name", style: .default) { action in
            self.recipes = self.sortedAlphabetically
            self.recipeTblView.reloadData()
        }
        
        actionSheet.addAction(orignal)
        actionSheet.addAction(timeSortMax)
        actionSheet.addAction(timeSortMin)
        actionSheet.addAction(alphabetically)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

// tableview functions
extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (recipes.count > 0) {
            placeholderLbl.isHidden = true
            btnMenu.isEnabled = true
        }
        else {
            placeholderLbl.isHidden = false
            btnMenu.isEnabled = false
        }
        return recipes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "RecipeCell")
        cell.textLabel?.text = recipe.name
        cell.textLabel?.font = UIFont(name: "Comfortaa-Regular", size: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RecipeListToViewRecipe", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let deleteAction = UITableViewRowAction(style: .default, title: "delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            
            let deleteMenu = UIAlertController(title: nil, message: "delete this recipe?", preferredStyle: .actionSheet)
            
            let recipeDeleteAction = UIAlertAction(title: "delete", style: .default, handler: { action in
                guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let recipe = self.recipes[indexPath.row]
                let id = recipe.id
                self.recipes.remove(at: indexPath.row)
                
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                tableView.endUpdates()
                
                CoreDataController.deleteRecipeData(delegate: delegate, id: id)
            })
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            
            deleteMenu.addAction(recipeDeleteAction)
            deleteMenu.addAction(cancelAction)
            
            self.present(deleteMenu, animated: true, completion: nil)
        })
        
        return [deleteAction]
    }
}
