//
//  SubtitleViewController.swift
//  Justwatchme.tv
//
//  Created by GIZMEON on 17/09/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
protocol SubtitleDelegate:class {
    func showSubtitle(urlString:String?,index:Int?)
    func hideSubtitle(index:Int?)
}
class SubtitleViewController: UIViewController {
    weak var subtileOn : SubtitleDelegate?
    var selectedRow = Int()
    var subtitleListArray = [subtitleModel]()
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var subtiltleListCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subtiltleListCollectionView.register(UINib(nibName: "SubtitleCollectionviewCell", bundle: nil), forCellWithReuseIdentifier: "subtitleCell")
        self.subtiltleListCollectionView.delegate = self
        self.subtiltleListCollectionView.dataSource = self
        subtiltleListCollectionView.backgroundColor = ThemeManager.currentTheme().grayImageColor
        view.backgroundColor = ThemeManager.currentTheme().grayImageColor
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}
extension SubtitleViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subtitleListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subtitleCell", for: indexPath as IndexPath) as! subtitleCollectionviewCell
        cell.layer.borderColor = .none
        cell.languageName.text = subtitleListArray[indexPath.item].language_name
        if selectedRow == -1{
//            cell.backgroundColor = .yellow
            cell.checkButton.isHidden = true
        }
        
        if selectedRow == indexPath.row{
//            cell.backgroundColor = .red
            cell.checkButton.isHidden = false
            cell.languageName.textColor = .gray
        }
        else{
            cell.languageName.textColor = .white
        }
                return cell
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
//      let width = self.textWidth(text: categoryListArray[indexPath.row].category_name!, font: UIFont.systemFont(ofSize: 12)) + 20
        return CGSize(width: subtiltleListCollectionView.frame.width , height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            self.subtileOn?.hideSubtitle(index: indexPath.item)
        }
        else{
            
        
        self.subtileOn?.showSubtitle(urlString: subtitleListArray[indexPath.item].subtitle_url, index: indexPath.item)
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    
}
