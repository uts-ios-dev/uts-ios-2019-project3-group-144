//
//  ViewRecipeViewController.swift
//  assignment3
//
//  Created by Jacob Efendi on 5/19/19.
//  Copyright © 2019 group144. All rights reserved.
//

import UIKit

class ViewRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeNameLbl: UILabel!
    
    @IBOutlet weak var prepTimeLbl: UILabel!
    @IBOutlet weak var cookingTimeLbl: UILabel!
    @IBOutlet weak var ingredientsTv: UITableView!
    @IBOutlet weak var methodsTv: UITableView!
    
    var recipe: Recipe = Recipe(name: "", prepTime: 0, cookingTime: 0, ingredients: [], methods: [])
    var ingredients: [Ingredient] = []
    var methods: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recipeNameLbl.text = recipe.name
        prepTimeLbl.text = String(recipe.prepTime) + " minutes"
        cookingTimeLbl.text = String(recipe.cookingTime) + " minutes"
        ingredients = recipe.ingredients
        methods = recipe.methods
    }
}

extension ViewRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == ingredientsTv) {
            print("Getting Count for IngredientTv")
            return ingredients.count
        }
        else if (tableView == methodsTv) {
            print("Getting Count for MethodTv")
            return methods.count
        }
        
        print("No Table Found")
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == ingredientsTv) {
            print("Updating Cells in IngredientTv")
            let ingredient = ingredients[indexPath.row]
            let ingredientInfo = "\(ingredient.quantity) \(ingredient.name)"
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "IngredientCell")
            cell.textLabel?.text = ingredientInfo
            return cell
        }
        else if (tableView == methodsTv) {
            print("Updating Cells in MethodTv")
            let method = methods[indexPath.row]
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "MethodCell")
            cell.textLabel?.text = method
            return cell
        }
        
        print("No Table Found")
        return UITableViewCell()
    }
}
