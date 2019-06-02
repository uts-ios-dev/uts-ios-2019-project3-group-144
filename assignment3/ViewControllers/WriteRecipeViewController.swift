import UIKit

// view controller to write new recipe or edit existing recipe
class WriteRecipeViewController: UIViewController {
    
    // label outlets
    @IBOutlet weak var prepTimeLbl: UILabel!
    @IBOutlet weak var cookingTimeLbl: UILabel!
    @IBOutlet weak var ingredientsLbl: UILabel!
    @IBOutlet weak var methodsLbl: UILabel!
    
    // button outlets
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var addIngredientBtn: UIButton!
    @IBOutlet weak var addMethodBtn: UIButton!
    
    // text field outlets
    @IBOutlet weak var recipeNameTf: UITextField!
    @IBOutlet weak var prepTimeTf: UITextField!
    @IBOutlet weak var cookingTimeTf: UITextField!
    @IBOutlet weak var ingredientQtyTf: UITextField!
    @IBOutlet weak var measurementType: UITextField!
    
    @IBOutlet weak var ingredientNameTf: UITextField!
    @IBOutlet weak var methodTf: UITextField!
    
    // tableview outlets
    @IBOutlet weak var ingredientsTv: UITableView!
    @IBOutlet weak var methodsTv: UITableView!
    @IBOutlet weak var ingredientsTvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var methodsTvHeightConstraint: NSLayoutConstraint!

    // scrollview outlets
    @IBOutlet weak var contentsSv: UIScrollView!
    
    // imageview outlets
    @IBOutlet weak var addFromCameraRollBtn: UIButton!
    @IBOutlet weak var addFromCameraBtn: UIButton!
    @IBOutlet weak var recipeIv: UIImageView!
    var imagePickerController = UIImagePickerController()

    // pickerView measurements
    let measurement = ["", "g","mg", "kg", "ml", "l", "cup", "tbsp", "tsp"]
    var selectedMeasurement : String?

    
    // recipe object to be saved
    var recipe: Recipe = Recipe(id: 0, name: "", imageName: "", prepTime: 0, cookingTime: 0, ingredients: [], methods: [])
    
    // arrays for ingredients and methods
    var ingredients: [String] = []
    var methods: [String] = []
    
    
    // function called when view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        methodsTv.isEditing = true
        ingredientsTv.isEditing = true
        imagePickerController.delegate = self
        
        // set up initial values for entry fields
        recipeNameTf.text = recipe.name
        recipeIv.image = ImageController.getImage(imageName: recipe.imageName) 
        prepTimeTf.text = String(recipe.prepTime)
        cookingTimeTf.text = String(recipe.cookingTime)
        ingredients = recipe.ingredients
        methods = recipe.methods
        
        // empty out tableviews
        ingredientsTv.tableFooterView = UIView(frame: CGRect.zero)
        methodsTv.tableFooterView = UIView(frame: CGRect.zero)
   
        // create picker object
        createMeasurementPicker()
        
        // apply the theme
        applyTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // show the navigation bar and hide the tab bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        // adjust ingredients tableview height based on number of rows needed
        ingredientsTv.frame = CGRect(x: ingredientsTv.frame.origin.x, y: ingredientsTv.frame.origin.y, width: ingredientsTv.frame.size.width, height: ingredientsTv.contentSize.height)
        ingredientsTvHeightConstraint.constant = ingredientsTv.contentSize.height + 10
        ingredientsTv.reloadData()
        
        // adjust methods tableview height based on the number of rows needed
        methodsTv.frame = CGRect(x: methodsTv.frame.origin.x, y: methodsTv.frame.origin.y, width: methodsTv.frame.size.width, height: methodsTv.contentSize.height)
        methodsTvHeightConstraint.constant = methodsTv.contentSize.height + 10
        methodsTv.reloadData()
    }
    
    // function to create the measurement picker
    func createMeasurementPicker(){
        // create the picker
        let measurementPicker = UIPickerView()
        measurementPicker.delegate = self
        measurementType.inputView = measurementPicker
    }
    
    // functions to handle add ingredient/method button presses
    @IBAction func onAddIngredientBtnPressed(_ sender: Any) { addIngredient() }
    @IBAction func onAddMethodBtnPressed(_ sender: Any) { addMethod() }
    
    @IBAction func addImage(_ sender: UIButton) {
        if (sender == addFromCameraBtn) {
            imagePickerController.sourceType = .camera
            //imagePickerController.allowsEditing = false
            present(imagePickerController, animated: true, completion: nil)
        } else if (sender == addFromCameraRollBtn) {
            imagePickerController.sourceType = .photoLibrary
            //imagePickerController.allowsEditing = true
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // function to add ingredients
    func addIngredient() {
        // unwrap optionals
        if let name: String = ingredientNameTf.text {
            if let quantity: Int = Int(ingredientQtyTf.text ?? "") {
                
                var ingredient: String = ""
                let measurement: String = String(selectedMeasurement ?? "")
                
                // create ingredient string and add to list
                if (measurement != "") {
                    if (quantity != 1) { ingredient = "\(quantity)\(measurement)s \(name)"}
                    else { ingredient = "\(quantity)\(measurement) \(name)"}
                }
                else { ingredient = "\(quantity) \(name)" }
                ingredients.append(ingredient)
                
                // empty ingredient input fields
                ingredientQtyTf.text = ""
                ingredientNameTf.text = ""
                measurementType.text = ""
                
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
        if (recipe.id == 0) { recipe.id = CoreDataController.generateId()}
        recipe.name = recipeNameTf.text ?? ""
        recipe.prepTime = Int(prepTimeTf.text ?? "") ?? 0
        recipe.cookingTime = Int(cookingTimeTf.text ?? "") ?? 0
        recipe.ingredients = ingredients
        recipe.methods = methods
        
        // create or update existing recipe based on if an entry with the given id already exists
        if (!CoreDataController.hasRecipe(delegate: delegate, recipe: recipe)) {
            recipe.imageName = ImageController.saveImage(image: recipeIv.image ?? #imageLiteral(resourceName: "default"), recipe: recipe) ?? ""
            CoreDataController.saveRecipeData(delegate: delegate, recipe: recipe)
        } else {
            let initialImage: UIImage = ImageController.getImage(imageName: recipe.imageName) ?? #imageLiteral(resourceName: "default")
            ImageController.updateImage(imageName: recipe.imageName, newImage: recipeIv.image ?? initialImage)
            CoreDataController.updateRecipeData(delegate: delegate, recipe: recipe)
        }
    }
    
    // function that is called before segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if the segue is the save recipe segue, save the recipe
        if (segue.identifier == "SaveToRecipeList" && recipeNameTf.text! != "") {
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
            charLimit = 3
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
    
    // function to apply current theme to ui elements
    func applyTheme() {
        // set view background
        view.backgroundColor = Theme.current.background
        
        // set static label colours
        prepTimeLbl.textColor = Theme.current.fontColour
        cookingTimeLbl.textColor = Theme.current.fontColour
        ingredientsLbl.textColor = Theme.current.fontColour
        methodsLbl.textColor = Theme.current.fontColour
        
        // set textfield colours
        recipeNameTf.backgroundColor = Theme.current.accent
        recipeNameTf.textColor = Theme.current.fontColour
        recipeNameTf.attributedPlaceholder =
            NSAttributedString(string: "recipe name", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.placeHolder])
        
        prepTimeTf.backgroundColor = Theme.current.accent
        prepTimeTf.textColor = Theme.current.fontColour
        prepTimeTf.attributedPlaceholder =
            NSAttributedString(string: "minutes", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.placeHolder])
        
        cookingTimeTf.backgroundColor = Theme.current.accent
        cookingTimeTf.textColor = Theme.current.fontColour
        cookingTimeTf.attributedPlaceholder =
            NSAttributedString(string: "minutes", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.placeHolder])
        
        ingredientQtyTf.backgroundColor = Theme.current.accent
        ingredientQtyTf.textColor = Theme.current.fontColour
        ingredientQtyTf.attributedPlaceholder =
            NSAttributedString(string: "qty.", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.placeHolder])

        ingredientNameTf.backgroundColor = Theme.current.accent
        ingredientNameTf.textColor = Theme.current.fontColour
        ingredientNameTf.attributedPlaceholder =
            NSAttributedString(string: "ingredient", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.placeHolder])
        
        measurementType.backgroundColor = Theme.current.accent
        measurementType.textColor = Theme.current.fontColour
        measurementType.attributedPlaceholder =
            NSAttributedString(string: "unit", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.placeHolder])
        
        methodTf.backgroundColor = Theme.current.accent
        methodTf.textColor = Theme.current.fontColour
        methodTf.attributedPlaceholder =
            NSAttributedString(string: "minutes", attributes: [NSAttributedString.Key.foregroundColor: Theme.current.placeHolder])
        
        // set camera button and imageview colours
        addFromCameraBtn.backgroundColor = Theme.current.accent
        recipeIv.backgroundColor = Theme.current.accent
        
        // reload tableview data
        methodsTv.reloadData()
        ingredientsTv.reloadData()
    }
}

// tableview related functions
extension WriteRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // function to get number of rows needed for tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return count of ingredients or methods list depending on the tableview being checked
        if (tableView == ingredientsTv) { return ingredients.count }
        else if (tableView == methodsTv) { return methods.count }
        
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
            cell.textLabel?.font = UIFont(name: Theme.current.mainFontName, size: 14)
            cell.textLabel?.textColor = Theme.current.fontColour
            cell.backgroundColor = .clear
            cell.separatorInset = .zero
            // return the cell
            return cell
        }
        else if (tableView == methodsTv) {
            // get method data
            let method = methods[indexPath.row]
            
            // initialise tableview cell and set cell text
            let cell = methodsTv.dequeueReusableCell(withIdentifier: "MethodCell", for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(indexPath.row + 1). \(method)"
            cell.textLabel?.font = UIFont(name: Theme.current.mainFontName, size: 14)
            cell.textLabel?.textColor = Theme.current.fontColour
            cell.backgroundColor = .clear
            cell.separatorInset = .zero
            // return the cell
            return cell
        }
        
        // if no table is found return an empty cell
        return UITableViewCell()
    }
    
    // function that will allow the methods to be reordered by hold and drag
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if (tableView == ingredientsTv) {
            // get the moved object
            let movedObject = self.ingredients[sourceIndexPath.row]
            // remove and reinsert moved object into ingredients array
            ingredients.remove(at: sourceIndexPath.row)
            ingredients.insert(movedObject, at: destinationIndexPath.row)
            // refresh tableview data
            ingredientsTv.reloadData()
        }
        else if (tableView == methodsTv) {
            // get the moved object
            let movedObject = self.methods[sourceIndexPath.row]
            methods.remove(at: sourceIndexPath.row)
            methods.insert(movedObject, at: destinationIndexPath.row)
            // refresh tableview data
            methodsTv.reloadData()
        }
    }
    
    // function to delete tableview rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if (tableView == ingredientsTv) {
                // remove the ingredient from the list
                ingredients.remove(at: indexPath.row)

                // remove ingredient entry from the tableview
                ingredientsTv.beginUpdates()
                ingredientsTv.deleteRows(at: [indexPath], with: .automatic)
                ingredientsTv.endUpdates()
                ingredientsTv.reloadData()
            }
            else if (tableView == methodsTv) {
                // remove the ingredient from the list
                methods.remove(at: indexPath.row)
                
                // remove method entry from the tableview
                methodsTv.beginUpdates()
                methodsTv.deleteRows(at: [indexPath], with: .automatic)
                methodsTv.endUpdates()
                methodsTv.reloadData()
            }
        }
    }
}

// imagepicker functions
extension WriteRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // function to retrieve and set image from the picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // if there is an image, set it to the imageview
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            recipeIv.image = image
            recipeIv.backgroundColor = .clear
        }
        dismiss(animated: true, completion: nil)
    }
}

// picker functions
extension WriteRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate{

    // function to return number of components in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    // function to return the number of pickeroptions
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return measurement.count }

    // function to return the selected options
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return measurement[row] }

    // function to handle picker option selections
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMeasurement = measurement[row]
        measurementType.text = selectedMeasurement
    }
}
