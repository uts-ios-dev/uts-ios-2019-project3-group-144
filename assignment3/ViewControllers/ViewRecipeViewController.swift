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
    
    // imageview outlet
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
        
        // convert prep time to hours: minutes format
        let prepTime = minutesToHours(minutes: recipe.prepTime)
        prepTimeLbl.text = getTimeText(hours: prepTime.hours, minutes: prepTime.minutes)
        
        // convert cooking time to hours: minutes format
        let cookingTime = minutesToHours(minutes: recipe.cookingTime)
        cookingTimeLbl.text = getTimeText(hours: cookingTime.hours, minutes: cookingTime.minutes)
    
        // initialise ingredient and method lists
        ingredients = recipe.ingredients
        methods = recipe.methods
        
        // apply theme
        applyTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // set height of ingredients tableview based on number of rows needed
        ingredientsTv.frame = CGRect(x: ingredientsTv.frame.origin.x, y: ingredientsTv.frame.origin.y, width: ingredientsTv.frame.size.width, height: ingredientsTv.contentSize.height)
        ingredientsTvHeightConstraint.constant = ingredientsTv.contentSize.height + 10
        
        // set height of methods tableview based on number of rows needed
        methodsTv.frame = CGRect(x: methodsTv.frame.origin.x, y: methodsTv.frame.origin.y, width: methodsTv.frame.size.width, height: methodsTv.contentSize.height)
        methodsTvHeightConstraint.constant = methodsTv.contentSize.height + 10
    }
    
    // function to convert times to hours:minutes format
    func minutesToHours(minutes: Int) -> (hours: Int, minutes: Int) {
        return (hours: minutes / 60, minutes: minutes % 60)
    }
    
    // function to get time text
    func getTimeText(hours: Int, minutes: Int) -> String {
        var timeText: String = ""
        
        if (hours == 0) {
            if (minutes != 1) { timeText = "\(minutes) mins" }
            else { timeText = "\(minutes) min" }
        }
        else if (minutes == 0) {
            if (hours != 1) { timeText = "\(hours) hrs" }
            else { timeText = "\(hours) hr" }
        }
        else {
            if (hours != 1 ) { timeText = "\(hours) hrs, "}
            else { timeText = "\(hours) hr, "}
            
            if (minutes != 1) { timeText += "\(minutes) mins" }
            else {timeText += "\(minutes) min" }
        }
        
        return timeText
    }
    
    // function to apply current theme to ui elements
    func applyTheme() {
        // set view background colour
        view.backgroundColor = Theme.current.background
        
        // set label colours
        recipeNameLbl.textColor = Theme.current.fontColour
        prepTimeTitleLbl.textColor = Theme.current.fontColour
        cookingTimeTitleLbl.textColor = Theme.current.fontColour
        prepTimeLbl.textColor = Theme.current.fontColour
        cookingTimeLbl.textColor = Theme.current.fontColour
        ingredientsLbl.textColor = Theme.current.fontColour
        methodsLbl.textColor = Theme.current.fontColour
        
        // set background colours for prep/cooking time labels
        prepTimeLbl.backgroundColor = Theme.current.accent
        cookingTimeLbl.backgroundColor = Theme.current.accent
    }
    
    // function to prepare data before sefue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // transfer recipe data if we are about to edit it
        if (segue.identifier == "ViewToEditRecipe") {
            let dest = segue.destination as! WriteRecipeViewController
            dest.recipe = recipe
        }
    }
}

// tableview related functions
extension ViewRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // function to retrieve number of tableview rows needed
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == ingredientsTv) { return ingredients.count }
        else if (tableView == methodsTv) { return methods.count }
        return 0
    }
    
    // function to create and format cells
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == ingredientsTv) {
            // get ingredient and tablaview cell
            let ingredient = ingredients[indexPath.row]
            let cell = ingredientsTv.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
            
            // set text of the cell
            cell.textLabel?.text = ingredient
            
            // format the cell
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont(name: Theme.current.mainFontName, size: 14)
            cell.textLabel?.textColor = Theme.current.fontColour
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.separatorInset = .zero
            
            // return the cell
            return cell
        }
        else if (tableView == methodsTv) {
            // get the ingredient and tableview cell
            let method = methods[indexPath.row]
            let cell = methodsTv.dequeueReusableCell(withIdentifier: "MethodCell", for: indexPath)
            
            // set text of the cell
            cell.textLabel?.text = "\(indexPath.row + 1). \(method)"

            // format the cell
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont(name: Theme.current.mainFontName, size: 14)
            cell.textLabel?.textColor = Theme.current.fontColour
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.separatorInset = .zero
            
            // return the cell
            return cell
        }
        
        return UITableViewCell()
    }
}
