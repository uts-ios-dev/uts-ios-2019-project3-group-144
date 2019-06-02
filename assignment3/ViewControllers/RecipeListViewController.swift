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
    var searchRecipes: [Recipe] = []
    
    // search variable
    var isSearching: Bool = false
    
    // function called when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show the tab bar if it is hidden
        self.tabBarController?.tabBar.isHidden = false
        
        // remove empty tableview cells
        recipeTblView.tableFooterView = UIView(frame: CGRect.zero)
        
        // get the recipe data
        getRecipes()
        
        // enable/disable sort buttons based on number of recipes
        if (recipes.count < 1) { btnMenu.isEnabled = false }
        
        // set search bar delegate
        recipeSearchBr.delegate = self
        
        // apply theme
        applyTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // show the tab bar if it is hidden
        self.tabBarController?.tabBar.isHidden = false
        
        // reload the tableview data
        recipeTblView.reloadData()
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
        
        // enable/disable sort button based on recipes available
        if (recipes.count < 1) { btnMenu.isEnabled = false }
        
        // apply theme
        applyTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // end editing in search bar before moving to another view
        recipeSearchBr.text = ""
        isSearching = false
        view.endEditing(true)
    }
    
    // function called before segue
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
        
        // create sorted recipe lists
        originalRecipes = recipes
        sortedByTimeMax = recipes.sorted(by: { $0.prepTime > $1.prepTime })
        sortedByTimeMin = recipes.sorted(by: { $0.prepTime < $1.prepTime })
        sortedAlphabetically = recipes.sorted(by: { $0.name < $1.name })
    }
    
    @IBAction func onPressSortBtn(_ sender: Any) {
        showSortActionSheet()
    }
    
    // function to create and show actionsheet for sorting options
    @objc func showSortActionSheet() {
        // create actionsheet and actionsheet options
        let actionSheet = UIAlertController(title: "sort recipes", message: "", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let original = UIAlertAction(title: "by date created", style: .default) { action in
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
        
        // add actions to the actionsheet
        actionSheet.addAction(original)
        actionSheet.addAction(timeSortMax)
        actionSheet.addAction(timeSortMin)
        actionSheet.addAction(alphabetically)
        actionSheet.addAction(cancel)
        
        // show the actionsheet
        present(actionSheet, animated: true, completion: nil)
    }
    
    // function to apply current theme to ui elements
    func applyTheme() {
        
        // set the background colour
        view.backgroundColor = Theme.current.background
        
        // format the search bar
        recipeSearchBr.backgroundImage = UIImage()
        recipeSearchBr.backgroundColor = Theme.current.background
        let searchField: UITextField = recipeSearchBr.value(forKeyPath: "_searchField") as! UITextField;
        searchField.backgroundColor = Theme.current.accent
        searchField.textColor = Theme.current.fontColour
        searchField.font = UIFont(name: Theme.current.mainFontName, size: 16)
        searchField.attributedPlaceholder =
            NSAttributedString(string: "enter keyword", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.placeHolder])
        
        // reload the tableview data
        recipeTblView.reloadData()
    }
}

// tableview functions
extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // tableview to get number of rows needed for the tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // enable/disable the placeholder text and sort button based on if there are recipes available
        if (recipes.count > 0) {
            placeholderLbl.isHidden = true
            btnMenu.isEnabled = true
        }
        else {
            placeholderLbl.isHidden = false
            btnMenu.isEnabled = false
        }
        
        // if the user is searching, return the number of search results
        if (isSearching) { return searchRecipes.count }
        else { return recipes.count }
    }
    
    // function to create and format tableview cells
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create the cell
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "RecipeCell")
        
        // set the cell text
        if (isSearching) {
            let recipeSearch = searchRecipes[indexPath.row]
            cell.textLabel?.text = recipeSearch.name
        }
        else {
            let recipe = recipes[indexPath.row]
            cell.textLabel?.text = recipe.name
        }
        
        // format the cell
        cell.textLabel?.font = UIFont(name: Theme.current.mainFontName, size: 16)
        cell.textLabel?.textColor = Theme.current.fontColour
        cell.backgroundColor = .clear
        cell.separatorInset = .zero
        
        // return the cell
        return cell
    }
    
    // function to handle tableview row selections
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // segue to view recipe page
        performSegue(withIdentifier: "RecipeListToViewRecipe", sender: indexPath)
    }
    
    // function to handle tableview row edit actions
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        // set delection actions
        let deleteAction = UITableViewRowAction(style: .default, title: "delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
            
            // create delete actionsheet
            let deleteMenu = UIAlertController(title: nil, message: "delete this recipe?", preferredStyle: .actionSheet)
            
            // create actionsheet actions
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
            
            // add actions to actionsheet
            deleteMenu.addAction(recipeDeleteAction)
            deleteMenu.addAction(cancelAction)
            
            // show the actionsheet
            self.present(deleteMenu, animated: true, completion: nil)
        })
        
        return [deleteAction]
    }
}

// search functions
extension RecipeListViewController: UISearchBarDelegate {
    
    // functions to enable/disable isSearching boolean
    func searchBarTextDidBeginEditing(_ recipeSearchBr: UISearchBar) { isSearching = true }
    func searchBarTextDidEndEditing(_ recipeSearchBr: UISearchBar) {
        isSearching = false
        recipeTblView.reloadData()
        view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ recipeSearchBr: UISearchBar)
    {
        isSearching = false
        recipeTblView.reloadData()
        view.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ recipeSearchBr: UISearchBar) { isSearching = false }
    
    // function to generate search result
    func searchBar(_ recipeSearchBr: UISearchBar, textDidChange searchtext: String) {
        // clear currently saved search results
        searchRecipes.removeAll(keepingCapacity: false)
        
        // get the search string and filter results
        let predicateString = recipeSearchBr.text!.lowercased()
        searchRecipes = recipes.filter( {$0.name.lowercased().range(of: predicateString) != nil} )
        searchRecipes.sort {$0.name < $1.name}
        isSearching = (predicateString == "") ? false: true
        recipeTblView.reloadData()
    }
}
