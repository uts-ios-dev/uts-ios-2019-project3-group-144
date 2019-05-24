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
    @IBOutlet weak var ingredientsTvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var methodsTvHeightConstraint: NSLayoutConstraint!
    
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
        
        ingredientsTv.separatorStyle = .none
        methodsTv.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ingredientsTv.frame = CGRect(x: ingredientsTv.frame.origin.x, y: ingredientsTv.frame.origin.y, width: ingredientsTv.frame.size.width, height: ingredientsTv.contentSize.height)
        ingredientsTvHeightConstraint.constant = ingredientsTv.contentSize.height + 10
        
        methodsTv.frame = CGRect(x: methodsTv.frame.origin.x, y: methodsTv.frame.origin.y, width: methodsTv.frame.size.width, height: methodsTv.contentSize.height)
        methodsTvHeightConstraint.constant = methodsTv.contentSize.height + 10
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
            let cell = ingredientsTv.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = ingredient
            cell.selectionStyle = .none
            return cell
        }
        else if (tableView == methodsTv) {
            let method = methods[indexPath.row]
            let cell = methodsTv.dequeueReusableCell(withIdentifier: "MethodCell", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = method
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
}
