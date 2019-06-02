import UIKit

// view controller to display recipe
class ViewRecipeViewController: UIViewController {
    
    // label outlets
    @IBOutlet weak var prepTimeTitleLbl: UILabel!
    @IBOutlet weak var cookingTimeTitleLbl: UILabel!
    @IBOutlet weak var recipeNameLbl: UILabel!
    @IBOutlet weak var prepTimeLbl: UILabel!
    @IBOutlet weak var cookingTimeLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var methodsLbl: UILabel!
    
    @IBOutlet weak var recipeIv: UIImageView!
    
    // tableview outlets
    @IBOutlet weak var ingredientsTv: UITableView!
    @IBOutlet weak var methodsTv: UITableView!
    @IBOutlet weak var ingredientsTvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var methodsTvHeightConstraint: NSLayoutConstraint!
    
    // recipe object
    var recipe: Recipe = Recipe(id: 0, name: "", imageName: "", prepTime: 0, cookingTime: 0, ingredients: [], methods: [])
    
    // arrays for ingredients and methods
    var ingredients: [String] = []
    var methods: [String] = []
    
    // function called when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // insert recipe data into appropriate fields
        recipeNameLbl.text = recipe.name
        recipeIv.image = ImageController.getImage(imageName: recipe.imageName)
        
        let prepTime = minutesToHours(minutes: recipe.prepTime)
        
        if (prepTime.hours == 0) {
            if (prepTime.minutes != 1) { prepTimeLbl.text = "\(prepTime.minutes) mins" }
            else { prepTimeLbl.text = "\(prepTime.minutes) min" }
        }
        else if (prepTime.minutes == 0) {
            if (prepTime.hours != 1) { prepTimeLbl.text = "\(prepTime.hours) hrs" }
            else { prepTimeLbl.text = "\(prepTime.hours) hr" }
        }
        else {
            if (prepTime.hours != 1 ) { prepTimeLbl.text = "\(prepTime.hours) hrs, "}
            else { prepTimeLbl.text = "\(prepTime.hours) hr, "}
            
            if (prepTime.minutes != 1) { prepTimeLbl.text! += "\(prepTime.minutes) mins" }
            else { prepTimeLbl.text! += "\(prepTime.minutes) min" }
        }
        
        let cookingTime = minutesToHours(minutes: recipe.cookingTime)

        print(cookingTime)
        if (cookingTime.hours == 0) {
            if (cookingTime.minutes != 1) { cookingTimeLbl.text = "\(cookingTime.minutes) mins" }
            else { cookingTimeLbl.text = "\(cookingTime.minutes) min" }
        }
        else if (cookingTime.minutes == 0) {
            if (cookingTime.hours != 1) { cookingTimeLbl.text = "\(cookingTime.hours) hrs" }
            else { cookingTimeLbl.text = "\(String(cookingTime.hours)) hr" }
        }
        else {
            if (cookingTime.hours != 1 ) { cookingTimeLbl.text = "\(cookingTime.hours) hrs, "}
            else { cookingTimeLbl.text = "\(cookingTime.hours) hr, "}
            
            if (cookingTime.minutes != 1) { cookingTimeLbl.text! += "\(cookingTime.minutes) mins" }
            else { cookingTimeLbl.text! += "\(cookingTime.minutes) min" }
        }
    
        ingredients = recipe.ingredients
        methods = recipe.methods
        
        applyTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ingredientsTv.frame = CGRect(x: ingredientsTv.frame.origin.x, y: ingredientsTv.frame.origin.y, width: ingredientsTv.frame.size.width, height: ingredientsTv.contentSize.height)
        ingredientsTvHeightConstraint.constant = ingredientsTv.contentSize.height + 10
        
        methodsTv.frame = CGRect(x: methodsTv.frame.origin.x, y: methodsTv.frame.origin.y, width: methodsTv.frame.size.width, height: methodsTv.contentSize.height)
        methodsTvHeightConstraint.constant = methodsTv.contentSize.height + 10
    }
    
    func minutesToHours(minutes: Int) -> (hours: Int, minutes: Int) {
        return (hours: minutes / 60, minutes: minutes % 60)
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.current.background
        recipeNameLbl.textColor = Theme.current.font
        prepTimeTitleLbl.textColor = Theme.current.font
        cookingTimeTitleLbl.textColor = Theme.current.font
        prepTimeLbl.textColor = Theme.current.font
        prepTimeLbl.backgroundColor = Theme.current.accent
        cookingTimeLbl.textColor = Theme.current.font
        cookingTimeLbl.backgroundColor = Theme.current.accent
        ingredientsLbl.textColor = Theme.current.font
        methodsLbl.textColor = Theme.current.font
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ViewToEditRecipe") {
            print("editing recipe!")
            let dest = segue.destination as! WriteRecipeViewController
            dest.recipe = recipe
        }
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
            cell.textLabel?.font = UIFont(name: Theme.current.mainFontName, size: 14)
            cell.textLabel?.textColor = Theme.current.font
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.separatorInset = .zero
            return cell
        }
        else if (tableView == methodsTv) {
            let method = methods[indexPath.row]
            let cell = methodsTv.dequeueReusableCell(withIdentifier: "MethodCell", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(indexPath.row + 1). \(method)"
            cell.textLabel?.font = UIFont(name: Theme.current.mainFontName, size: 14)
            cell.textLabel?.textColor = Theme.current.font
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.separatorInset = .zero
            return cell
        }
        
        return UITableViewCell()
    }
}
