//
//  RecipeListViewController.swift
//  assignment3
//
//  Created by Jacob Efendi on 5/18/19.
//  Copyright © 2019 group144. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController {

    @IBOutlet weak var recipeSearchBr: UISearchBar!
    @IBOutlet weak var recipeTblView: UITableView!
    
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RecipeListToViewRecipe") {
            if let indexPath = sender as? IndexPath {
                let recipe = recipes[indexPath.row]
                let dest = segue.destination as! ViewRecipeViewController
                dest.recipe = recipe
            }
        }
    }
}

extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "RecipeCell")
        cell.textLabel?.text = recipe.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RecipeListToViewRecipe", sender: indexPath)
    }
}
