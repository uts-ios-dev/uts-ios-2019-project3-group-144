//
//  WriteRecipeViewController.swift
//  assignment3
//
//  Created by Jacob Efendi on 5/18/19.
//  Copyright © 2019 group144. All rights reserved.
//

import UIKit

class WriteRecipeViewController: UIViewController {
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var recipeNameTf: UITextField!
    @IBOutlet weak var prepTimeTf: UITextField!
    @IBOutlet weak var cookingTimeTf: UITextField!
    
    @IBOutlet weak var ingredientQtyTf: UITextField!
    @IBOutlet weak var ingredientNameTf: UITextField!
    @IBOutlet weak var methodTf: UITextField!
    
    @IBOutlet weak var addIngredientBtn: UIButton!
    @IBOutlet weak var addMethodBtn: UIButton!
    
    @IBOutlet weak var ingredientsTv: UITableView!
    @IBOutlet weak var methodsTv: UITableView!
    
    var ingredients: [Ingredient] = []
    var methods: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ingredientsTv.tableFooterView = UIView(frame: CGRect.zero)
        methodsTv.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }

    @IBAction func onAddIngredientBtnPressed(_ sender: Any) {
        addIngredient()
    }
    
    @IBAction func onAddMethodBtnPressed(_ sender: Any) {
        addMethod()
    }
    
    func addIngredient() {
        if let name: String = ingredientNameTf.text {
            if let quantity: Int = Int(ingredientQtyTf.text ?? "") {
                let ingredient = Ingredient(name: name, quantity: quantity)
                ingredients.append(ingredient)
                ingredientQtyTf.text = ""
                ingredientNameTf.text = ""
                let indexPath = IndexPath(row: ingredients.count - 1, section: 0)
                ingredientsTv.beginUpdates()
                ingredientsTv.insertRows(at: [indexPath], with: .automatic)
                ingredientsTv.endUpdates()
                view.endEditing(true)
            }
        }
    }
    
    func addMethod() {
        if let method: String = methodTf.text {
            methods.append(method)
            let indexPath = IndexPath(row: methods.count - 1, section: 0)
            methodTf.text = ""
            methodsTv.beginUpdates()
            methodsTv.insertRows(at: [indexPath], with: .automatic)
            methodsTv.endUpdates()
            view.endEditing(true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SaveToRecipeList") {
            
            let name: String = recipeNameTf.text ?? ""
            let prepTime: Int = Int(prepTimeTf.text ?? "") ?? 0
            let cookingTime: Int = Int(cookingTimeTf.text ?? "") ?? 0
            let recipe = Recipe(name: name, prepTime: prepTime, cookingTime: cookingTime, ingredients: ingredients, methods: methods)
            
            let destination = segue.destination as! RecipeListViewController
            destination.recipes.append(recipe)
        }
    }
}

extension WriteRecipeViewController: UITableViewDelegate, UITableViewDataSource {
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
