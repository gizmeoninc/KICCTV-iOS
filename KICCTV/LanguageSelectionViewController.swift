//
//  LanguageSelectionViewController.swift
//  AUSFLIX
//
//  Created by Firoze Moosakutty on 12/11/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UIViewController {

  @IBOutlet weak var mainView: UIView!{
    didSet{
      self.mainView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
  }
  @IBOutlet weak var selectlanguageCollectionView: UICollectionView!{
    didSet{
    self.selectlanguageCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
    }
  }
  var languageListArray = [languageList]()
  override func viewDidLoad() {
        super.viewDidLoad()
    self.initialView()
    getLanguageList()
    }
   func initialView() {
      selectlanguageCollectionView.register(UINib(nibName: "LanguageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "languageCell")
    }
  func getLanguageList() {
    //CustomProgressView.showActivityIndicator(userInteractionEnabled: false)
    self.languageListArray.removeAll()
    ApiCommonClass.getLanguages { (responseDictionary: Dictionary) in
      if let val = responseDictionary["error"] {
        DispatchQueue.main.async {
          WarningDisplayViewController .showFromViewController(viewController: self, message: val as! String, messageType: "1", delegate: self)
          CustomProgressView.hideActivityIndicator()
        }
      } else {
        self.languageListArray = responseDictionary["data"] as! [languageList]
        print(self.languageListArray)
        if self.languageListArray.count == 0 {
          DispatchQueue.main.async {
            WarningDisplayViewController .showFromViewController(viewController: self, message: "No videos found", messageType: "1", delegate: self)
            CustomProgressView.hideActivityIndicator()
          }
        } else {
          DispatchQueue.main.async {
            self.selectlanguageCollectionView.reloadData()
            CustomProgressView.hideActivityIndicator()
          }
        }
      }
    }
  }
}
extension LanguageSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   return languageListArray.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    let cell: LanguageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "languageCell", for: indexPath) as! LanguageCollectionViewCell
    cell.languageIcon.sd_setImage(with: URL(string: languageUrl + languageListArray[indexPath.row].language_icon!),
                                  placeholderImage:UIImage(named: "placeHolder400*600"))
    cell.languageNAme?.text = languageListArray[indexPath.row].language_name
    cell.languageIcon?.layer.cornerRadius = 8.0
    languageListArray[indexPath.row].status = "false"
    cell.languageIcon?.layer.masksToBounds = true
    cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let cell = collectionView.cellForItem(at: indexPath) as! LanguageCollectionViewCell
      if languageListArray[indexPath.row].status == "true" {
         languageListArray[indexPath.row].status = "false"
         cell.defaultSelected(value: false)
      } else {
         cell.defaultSelected(value: true)
         languageListArray[indexPath.row].status = "true"
      }
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (self.view.frame.size.width - 30) / 3//some width
    var height = CGFloat()
    if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
      height = CGFloat(200.0)
    }else{
      height = CGFloat(150.0)
    }
    return CGSize(width: width, height: height);
  }
}
