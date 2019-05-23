import UIKit

// view controller to write new recipe or edit existing recipe
class WriteRecipeViewController: UIViewController {
    
    // button outlets
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var addIngredientBtn: UIButton!
    @IBOutlet weak var addMethodBtn: UIButton!
    
    // text field outlets
    @IBOutlet weak var recipeNameTf: UITextField!
    @IBOutlet weak var prepTimeTf: UITextField!
    @IBOutlet weak var cookingTimeTf: UITextField!
    @IBOutlet weak var ingredientQtyTf: UITextField!
    @IBOutlet weak var ingredientNameTf: UITextField!
    @IBOutlet weak var methodTf: UITextField!
    
    // tableview outlets
    @IBOutlet weak var ingredientsTv: UITableView!
    @IBOutlet weak var methodsTv: UITableView!
    
    // arrays for ingredients and methods
    var ingredients: [String] = []
    var methods: [String] = []
    
    // function called when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // empty out tableviews
        ingredientsTv.tableFooterView = UIView(frame: CGRect.zero)
        methodsTv.tableFooterView = UIView(frame: CGRect.zero)
    }

    @IBAction func onAddIngredientBtnPressed(_ sender: Any) {
        addIngredient()
    }
    
    @IBAction func onAddMethodBtnPressed(_ sender: Any) {
        addMethod()
    }
    
    // function to add ingredients
    func addIngredient() {
        // unwrap optionals
        if let name: String = ingredientNameTf.text {
            if let quantity: Int = Int(ingredientQtyTf.text ?? "") {
                
                // create ingredient string and add to list
                let ingredient: String = String(quantity) + " \(name)"
                ingredients.append(ingredient)
                
                // empty ingredient input fields
                ingredientQtyTf.text = ""
                ingredientNameTf.text = ""
                view.endEditing(true)
                
                // insert new ingredient into tableview and update
                let indexPath = IndexPath(row: ingredients.count - 1, section: 0)
                ingredientsTv.beginUpdates()
                ingredientsTv.insertRows(at: [indexPath], with: .automatic)
                ingredientsTv.endUpdates()
            }
        }
    }
    
    func addMethod() {
        // unwrap optionals
        if let method: String = methodTf.text {
            // add method to list
            methods.append(method)
            
            // empty method input fields
            methodTf.text = ""
            view.endEditing(true)
            
            // insert new method into tableview and update
            let indexPath = IndexPath(row: methods.count - 1, section: 0)
            methodsTv.beginUpdates()
            methodsTv.insertRows(at: [indexPath], with: .automatic)
            methodsTv.endUpdates()
        }
    }
    
    // function to save recipe to core data
    func saveRecipe() {
        
        // get the view's delegate
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // get recipe properties
        let id: Int = CoreDataController.generateId()
        let name: String = recipeNameTf.text ?? ""
        let prepTime: Int = Int(prepTimeTf.text ?? "") ?? 0
        let cookingTime: Int = Int(cookingTimeTf.text ?? "") ?? 0
        
        // create and save recipe
        let recipe = Recipe(id: id, name: name, prepTime: prepTime, cookingTime: cookingTime, ingredients: ingredients, methods: methods)
        CoreDataController.saveRecipeData(delegate: delegate, recipe: recipe)
    }
    
    // function that is called before segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // if the segue is the save recipe segue, save the recipe
        if (segue.identifier == "SaveToRecipeList") {
            saveRecipe()
        }
    }
}


// tableview related functions
extension WriteRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // function to get number of rows needed for tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return count of ingredients or methods list depending on the tableview being checked
        if (tableView == ingredientsTv) { return ingredients.count }
        else if (tableView == methodsTv) { return methods.count }
        
        print("No Table Found")
        return 0
    }
    
    // function to populate tableview cells with data
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // add data to ingredients or methods tableview
        if (tableView == ingredientsTv) {
            // get ingredient data
            let ingredient = ingredients[indexPath.row]
            
            // initialise tableview cell and set cell text
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "IngredientCell")
            cell.textLabel?.text = ingredient
            
            // return the cell
            return cell
        }
        else if (tableView == methodsTv) {
            // get method data
            let method = methods[indexPath.row]
            
            // initialise tableview cell and set cell text
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "MethodCell")
            cell.textLabel?.text = method
            
            // return the cell
            return cell
        }
        
        // if no table is found return an empty cell
        print("No Table Found")
        return UITableViewCell()
    }
}
