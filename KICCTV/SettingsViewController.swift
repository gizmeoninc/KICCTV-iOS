//
//  SettingsViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 16/01/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    var menu = [String]()
    
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet var contentsView: UIView!
    let myFirstButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.restrictRotation = .portrait
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
        menu = ["Clear Search History"]
        //menu = ["Clear Search History", "Change preferred Languages","Toggle night mode"]
        self.contentsView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.TableView.backgroundColor = ThemeManager.currentTheme().backgroundColor


//      myFirstButton.setTitleColor(UIColor.blue, for: .normal)
//      myFirstButton.frame = CGRect(x: 15, y: -50, width: 300, height: 500)
//      myFirstButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
//      self.view.addSubview(myFirstButton)

    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.restrictRotation = .portrait
        }
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    @available(iOS 10.0, *)
    func deleteVideoSearchHistory(){
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    @available(iOS 10.0, *)
    func deleteChannelSearchHistory(){
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ChannelSearch")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            DispatchQueue.main.async {
                
            }
        } catch {
            print ("There was an error")
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
  @objc func buttonClicked() {
    let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "Episode") as! VideoDetailsViewController
    self.navigationController?.pushViewController(videoPlayerController, animated: false)
  }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            cell.settingsName.font = cell.settingsName.font.withSize(20)
        }
        cell.settingsName.textColor = ThemeManager.currentTheme().sideMenuTextColor
        cell.settingsName.text = menu[indexPath.row]
        if indexPath.row == 1 {
            cell.modeChangeSwitch.isHidden = false
            cell.modeChangeSwitch.tintColor = ThemeManager.currentTheme().UIImageColor
            if (UserDefaults.standard.string(forKey: "changeMode") == "NormalMode") {
                cell.modeChangeSwitch.setOn(false, animated: true)
            } else {
                cell.modeChangeSwitch.setOn(true, animated: true)
            }
        } else {
            cell.modeChangeSwitch.tintColor = ThemeManager.currentTheme().UIImageColor
            cell.modeChangeSwitch.isHidden = true
        }
        cell.modeChangeSwitch.addTarget(self, action: #selector(modeChanged), for: UIControl.Event.valueChanged)
        cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            DispatchQueue.main.async {
                WarningDisplayViewController().customActionAlert(viewController :self,title: "Clear Search History?", message: "", actionTitles: ["Cancel","Ok"], actions:[{action1 in
                    
                    },{action2 in
                        self.deleteVideoSearchHistory()
                        self.deleteChannelSearchHistory()
                    }, nil])
                
            }
//        } else if indexPath.row ==  {
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let watchListController = storyBoard.instantiateViewController(withIdentifier: "updatelanguage") as! UpdateLanguageListViewController
//            self.navigationController?.pushViewController(watchListController, animated: false)
       }
    }
    
    @objc func modeChanged(mySwitch: UISwitch) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(mySwitch.isOn, forKey:"identifier")
        let str = (UserDefaults.standard.bool(forKey: "identifier"))
        if str {
            ThemeManager.applyTheme(theme: .theme2)
            UserDefaults.standard.set("NightMode", forKey: "changeMode")
            let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "splashScreen") as! SplashViewController
            videoPlayerController.modechangevalue = false
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
        } else {
            ThemeManager.applyTheme(theme: .theme1)
            UserDefaults.standard.set("NormalMode", forKey: "changeMode")
            let videoPlayerController = self.storyboard?.instantiateViewController(withIdentifier: "splashScreen") as! SplashViewController
            videoPlayerController.modechangevalue = false
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
        }
    }
}
