//
//  KeyArtWorkViewController.swift
//  Outdoor
//
//  Created by GIZMEON on 23/11/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation
import UIKit
class KeyArtWorkViewController : UIViewController{
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
  
    
    @IBOutlet weak var mainViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var previousButton: UIButton!{
        didSet{
            previousButton.titleLabel?.textColor = ThemeManager.currentTheme().ThemeColor
        }
    }
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            nextButton.titleLabel?.textColor = ThemeManager.currentTheme().ThemeColor
        }
    }
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageCollectionViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var countLabel: UILabel!
    
    var artWorkArray = [keyArtWorkModel]()
    var selectedIndex = IndexPath()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.mainView.backgroundColor = ThemeManager.currentTheme().grayImageColor
        self.mainView.layer.cornerRadius = 8
        self.mainView.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        self.imageCollectionView.register(UINib(nibName: "EpisodeListCell", bundle: nil), forCellWithReuseIdentifier: "EpisodeCell")
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
        self.imageCollectionViewWidth.constant = UIScreen.main.bounds.width - 50
        let width = (UIScreen.main.bounds.width) //some width
        let height = (9 * width) / 16
        self.mainViewHeight.constant = height + 100
        self.mainViewWidth.constant = UIScreen.main.bounds.width

        if artWorkArray.count > 0{
            self.imageCollectionView.reloadData()
           
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    if self.selectedIndex.item == self.artWorkArray.count - 1{
                        self.nextButton.isHidden = true
                    }
                    else if self.artWorkArray.count == 1{
                        self.nextButton.isHidden = true
                        self.previousButton.isHidden = true
                    }
                    else if self.selectedIndex.item == 0{
                       self.nextButton.isHidden = false
                       self.previousButton.isHidden = true
                   }
                    else{
                        self.nextButton.isHidden = false
                        self.previousButton.isHidden = false
                    }
                    self.imageCollectionView.reloadData()
                    self.imageCollectionView.scrollToItem(at:self.selectedIndex, at: .left, animated: false)
                    self.countLabel.text = "\(self.selectedIndex.item + 1) of \(self.artWorkArray.count)"
                }
            }
           
            if self.artWorkArray.count == 1{
                self.nextButton.isHidden = true
                self.previousButton.isHidden = true
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    func dismiss()
    {
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor=UIColor.clear
        }, completion:{ _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    @IBAction func NextAction(_ sender: Any) {
        self.selectedIndex.item = self.selectedIndex.item + 1
        self.srollPosition()
    }
    
    @IBAction func previousAction(_ sender: Any) {
        self.selectedIndex.item = self.selectedIndex.item - 1
        self.srollPosition()
    }
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss()
    }
    func srollPosition(){
        DispatchQueue.main.async {
            if self.selectedIndex.item == self.artWorkArray.count - 1{
                self.nextButton.isHidden = true
            }
            else if self.artWorkArray.count == 1{
                self.nextButton.isHidden = true
                self.previousButton.isHidden = true
            }
            else if self.selectedIndex.item == 0{
               self.nextButton.isHidden = false
               self.previousButton.isHidden = true
           }
            else{
                self.nextButton.isHidden = false
                self.previousButton.isHidden = false
            }
            self.imageCollectionView.reloadData()
            self.imageCollectionView.scrollToItem(at:self.selectedIndex, at: .left, animated: true)
            self.countLabel.text = "\(self.selectedIndex.item + 1) of \(self.artWorkArray.count)"
        }
    }
 
    public class func showKeyArtWork(viewController : UITabBarController,array : [keyArtWorkModel],index :IndexPath) {
        let vc = KeyArtWorkViewController()
        vc.artWorkArray = array
        vc.selectedIndex = index
        
        vc.modalPresentationStyle = .overCurrentContext
        DispatchQueue.main.async {
        }
        viewController.present(vc, animated: true, completion: nil)
    }
}

extension KeyArtWorkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: Collectionview
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artWorkArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EpisodeCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCollectionCell
        cell.layer.cornerRadius = 8
        if artWorkArray.count > 0{
            cell.imageView.layer.masksToBounds = true
            cell.imageView.contentMode = .scaleToFill
            cell.artWorkImageView.isHidden = true
            cell.artWorkImageView.isHidden = false
            
            if artWorkArray[indexPath.row].image
                != nil {
                cell.artWorkImageView.sd_setImage(with:URL(string: ((imageUrl + artWorkArray[indexPath.row].image!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"), completed: { image, error, cacheType, imageURL in
                  
                    // your rest code
               })
            }
            else {
                cell.imageView.image = UIImage(named: "landscape_placeholder")
            }
            if let title = artWorkArray[indexPath.row].title{
                cell.EpisodeDescription.text = title
            }

         
        }
       
       return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.size.width - 50) //some width
        let height = (9 * width) / 16
        return CGSize(width: width, height: height + 50)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        }
    }


