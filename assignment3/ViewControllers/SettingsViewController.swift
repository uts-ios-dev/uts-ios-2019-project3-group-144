import UIKit

// view controller for app settings
class SettingsViewController: UIViewController {

    // label outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var themeTitleLbl: UILabel!
    
    // clear data button and segment control outlets
    @IBOutlet weak var clearDataBtn: UIButton!
    @IBOutlet weak var themeSegCtrl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // apply the theme
        applyTheme()
    }
    
    // function to handle segment control changes
    @IBAction func onThemeIndexChanged(_ sender: Any) {
        // set theme based on options selected
        switch (themeSegCtrl.selectedSegmentIndex) {
        case 0:
            Theme.current = LightTheme()
            applyTheme()
        case 1:
            Theme.current = DarkTheme()
            applyTheme()
        default:
            break
        }
    }
    
    // function to handle clear data button presses
    @IBAction func onPressClearDataBtn(_ sender: Any) { showClearDataActionSheet() }
    
    // function to show clear data action sheet
    @objc func showClearDataActionSheet() {
        // get the app delegate
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // create the action sheet and actions
        let actionSheet = UIAlertController(title: "clear data?", message: "", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let clear = UIAlertAction(title: "yes", style: .default) { action in CoreDataController.clearRecipeData(delegate: delegate)}
        
        // add actions to actionsheet
        actionSheet.addAction(clear)
        actionSheet.addAction(cancel)
        
        // show the actionsheet
        present(actionSheet, animated: true, completion: nil)
    }
    
    // function to apply current theme to ui elements
    func applyTheme() {
        // set the view background colours
        view.backgroundColor = Theme.current.background
        
        // set label colours
        titleLbl.textColor = Theme.current.fontColour
        versionLbl.textColor = Theme.current.fontColour
        themeTitleLbl.textColor = Theme.current.fontColour
    }
}
