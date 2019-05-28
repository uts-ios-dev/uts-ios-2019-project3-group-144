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
    @IBOutlet weak var ingredientsTvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var methodsTvHeightConstraint: NSLayoutConstraint!
    
    // imageview outlets
    @IBOutlet weak var addFromCameraRollBtn: UIButton!
    @IBOutlet weak var addFromCameraBtn: UIButton!
    @IBOutlet weak var recipeIv: UIImageView!
    var imageController = UIImagePickerController()
    
    
    // arrays for ingredients and methods
    var ingredients: [String] = []
    var methods: [String] = []
    
    
    // function called when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageController.delegate = self

        // empty out tableviews
        ingredientsTv.tableFooterView = UIView(frame: CGRect.zero)
        methodsTv.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewDidLayoutSubviews() {
        ingredientsTv.frame = CGRect(x: ingredientsTv.frame.origin.x, y: ingredientsTv.frame.origin.y, width: ingredientsTv.frame.size.width, height: ingredientsTv.contentSize.height)
        ingredientsTvHeightConstraint.constant = ingredientsTv.contentSize.height + 10
        ingredientsTv.reloadData()
        
        methodsTv.frame = CGRect(x: methodsTv.frame.origin.x, y: methodsTv.frame.origin.y, width: methodsTv.frame.size.width, height: methodsTv.contentSize.height)
        methodsTvHeightConstraint.constant = methodsTv.contentSize.height + 10
        methodsTv.reloadData()
    }

    @IBAction func onAddIngredientBtnPressed(_ sender: Any) {
        addIngredient()
    }
    
    @IBAction func onAddMethodBtnPressed(_ sender: Any) {
        addMethod()
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        if (sender == addFromCameraBtn) {
            imageController.sourceType = .camera
            imageController.allowsEditing = false
            present(imageController, animated: true, completion: nil)
        } else if (sender == addFromCameraRollBtn) {
            imageController.sourceType = .photoLibrary
            imageController.allowsEditing = true
            present(imageController, animated: true, completion: nil)
        }
        
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
                ingredientsTv.insertRows(at: [indexPath], with: .fade)
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
            methodsTv.insertRows(at: [indexPath], with: .bottom)
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

// textfield related functions
extension WriteRecipeViewController: UITextFieldDelegate {
    
    // function to check textfield content and use limitations (number of type of characters)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // initialise character limit and allowed characters
        var charLimit: Int = 0
        var allowedCharacters = CharacterSet.alphanumerics
        allowedCharacters = allowedCharacters.union(CharacterSet.punctuationCharacters)
        allowedCharacters = allowedCharacters.union(CharacterSet.symbols)
        allowedCharacters = allowedCharacters.union(CharacterSet(charactersIn: " "))
        
        // set character limit based off the textfield selected
        if (textField == ingredientQtyTf || textField == prepTimeTf || textField == cookingTimeTf) {
            charLimit = 4
            // also character allowed characters to numbers only
            allowedCharacters = CharacterSet.decimalDigits
        }
        if (textField == ingredientNameTf) { charLimit = 50 }
        else if (textField == methodTf) { charLimit = 200}
        
        // check length of current string
        if (range.length + range.location > textField.text!.count) { return false }
        let length = textField.text!.count + string.count - range.length
        
        // get characters currently in textfield
        let typedCharacters = CharacterSet(charactersIn: string)
        
        // return bool for if text is within limit and is using valid characters
        return length <= charLimit && allowedCharacters.isSuperset(of: typedCharacters)
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
            let cell = ingredientsTv.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
            // set number of lines to 0 so that rows have dynamic height based off contnet
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = ingredient
            
            // return the cell
            return cell
        }
        else if (tableView == methodsTv) {
            // get method data
            let method = methods[indexPath.row]
            
            // initialise tableview cell and set cell text
            let cell = methodsTv.dequeueReusableCell(withIdentifier: "MethodCell", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = method
            
            // return the cell
            return cell
        }
        
        // if no table is found return an empty cell
        print("No Table Found")
        return UITableViewCell()
    }
}

extension WriteRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            recipeIv.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
