//
//  LangageDropDownViewController.swift
//  AUSFLIX
//
//  Created by Firoze Moosakutty on 12/12/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class LangageDropDownViewController: UIViewController {
  @IBOutlet weak var languageTableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    tap.cancelsTouchesInView = false
    self.view.addGestureRecognizer(tap)
    let nib =  UINib(nibName: "LangaugeTableViewCell", bundle: nil)
    languageTableView.register(nib, forCellReuseIdentifier: "LangaugeTableViewCell")
    languageTableView.separatorColor = .clear
    languageTableView.isScrollEnabled = true
    self.view.isUserInteractionEnabled = true
    self.languageTableView.delegate = self
    self.languageTableView.dataSource = self
    self.languageTableView.allowsSelection = true
    self.languageTableView.reloadData()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.dismiss()
  }
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    dismiss()
  }
  
  func dismiss() {
      self.dismiss(animated: false, completion: nil)
  }

  func setLanguage(langugeId : Int) {
    var parameterDict: [String: String?] = [ : ]
    parameterDict["lang_list"] = String(langugeId)
    parameterDict["uid"] = String(UserDefaults.standard.integer(forKey: "user_id"))
    print(parameterDict)
    ApiCommonClass.setLanguagePriority (parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {

      } else {
        if responseDictionary["Channels"] != nil {
          Application.shared.langugeIdList = String(langugeId)
          DispatchQueue.main.async {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate!.loadTabbar()
          }
        }
      }
    }
  }
}
extension LangageDropDownViewController: UITableViewDataSource,UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LangaugeTableViewCell", for: indexPath) as! LangaugeTableViewCell
    cell.backgroundColor = UIColor.darkGray
    cell.langaugeNameLabel.text = Application.shared.userLanguages[indexPath.row].audio_language_name
    if let audio_language_id = Application.shared.userLanguages[indexPath.row].audio_language_id {
      if Application.shared.langugeIdList == String(format :"%d",audio_language_id) {
        cell.langaugeNameLabel.textColor = ThemeManager.currentTheme().UIImageColor
      } else{
        cell.langaugeNameLabel.textColor = .white
      }
    }
    cell.backgroundColor = UIColor.darkGray
    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Application.shared.userLanguages.count
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(Application.shared.userLanguages[indexPath.row].audio_language_id)
    if let language_id = Application.shared.userLanguages[indexPath.row].audio_language_id {
      self.setLanguage(langugeId: language_id)
    }
  }
}


