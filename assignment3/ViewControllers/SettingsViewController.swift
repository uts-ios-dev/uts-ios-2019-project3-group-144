//
//  SettingsViewController.swift
//  assignment3
//
//  Created by Jacob Efendi on 6/1/19.
//  Copyright © 2019 group144. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var themeTitleLbl: UILabel!
    
    @IBOutlet weak var clearDataBtn: UIButton!
    @IBOutlet weak var themeSegCtrl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onThemeIndexChanged(_ sender: Any) {
        switch themeSegCtrl.selectedSegmentIndex
        {
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
    
    @IBAction func onPressClearDataBtn(_ sender: Any) {
        showActionSheet()
    }
    
    @objc func showActionSheet() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let actionSheet = UIAlertController(title: "clear data?", message: "", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let clear = UIAlertAction(title: "yes", style: .default) { action in
            CoreDataController.clearRecipeData(delegate: delegate)
        }
        
        actionSheet.addAction(clear)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.current.background
        titleLbl.textColor = Theme.current.font
        versionLbl.textColor = Theme.current.font
        themeTitleLbl.textColor = Theme.current.font
    }
}
