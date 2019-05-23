import UIKit

// view controller to display recipe
class ViewRecipeViewController: UIViewController {
    
    // label outlets
    @IBOutlet weak var recipeNameLbl: UILabel!
    @IBOutlet weak var prepTimeLbl: UILabel!
    @IBOutlet weak var cookingTimeLbl: UILabel!
    
    // tableview outlets
    @IBOutlet weak var ingredientsTv: UITableView!
    @IBOutlet weak var methodsTv: UITableView!
    
    // recipe object
    var recipe: Recipe = Recipe(id: 0, name: "", prepTime: 0, cookingTime: 0, ingredients: [], methods: [])
    
    // arrays for ingredients and methods
    var ingredients: [String] = []
    var methods: [String] = []
    
    // function called when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // insert recipe data into appropriate fields
        recipeNameLbl.text = recipe.name
        prepTimeLbl.text = String(recipe.prepTime) + " minutes"
        cookingTimeLbl.text = String(recipe.cookingTime) + " minutes"
        ingredients = recipe.ingredients
        methods = recipe.methods
    }
}

// tableview related functions
extension ViewRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == ingredientsTv) { return ingredients.count }
        else if (tableView == methodsTv) { return methods.count }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == ingredientsTv) {
            let ingredient = ingredients[indexPath.row]
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "IngredientCell")
            cell.textLabel?.text = ingredient
            cell.selectionStyle = .none
            return cell
        }
        else if (tableView == methodsTv) {
            let method = methods[indexPath.row]
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "MethodCell")
            cell.textLabel?.text = method
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
}
