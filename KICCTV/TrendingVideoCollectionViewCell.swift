//
//  TrendingVideoCollectionViewCell.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 06/12/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit

class TrendingVideoCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var trendingVideoName: UILabel!
  @IBOutlet weak var pageController: UIPageControl!
  @IBOutlet weak var trendingImageLogo: UIImageView!
    var size = CGFloat()
    var sizeWidth =  CGFloat()
   
    @IBOutlet weak var showNameLabel: UILabel!{
        didSet{
//            showNamelabel.textColor = ThemeManager.currentTheme().HeadTextColor
        }
    }
    @IBOutlet weak var showName: UILabel!{
        didSet{
            showName.textColor = .white
        }
    }
    @IBOutlet weak var pageNumberLabel: UILabel!{
        didSet{
            pageNumberLabel.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var categoryLabel: UILabel!
    {
        didSet{
            categoryLabel.textColor = .lightGray
        }
    }
    @IBOutlet weak var topGradientView: UIView!{
        
            didSet{
                    topGradientView.setGradientBackground(colorTop: UIColor.black.withAlphaComponent(0.8), colorBottom: UIColor.clear)
                }
            }
    
    @IBOutlet weak var bottomGradientView: UIView!{
    didSet{
        bottomGradientView.setGradientBackground(colorTop:UIColor.clear , colorBottom: UIColor.black.withAlphaComponent(0.8))
        }
    }
  
    @IBOutlet weak var screenView: UIView!{
        didSet
        {
//            self.screenView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }
    
    @IBOutlet weak var headerlabel: UILabel!{
        didSet{
            
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                self.headerlabel.font = UIFont.init(name: "Helvetica-Bold", size: 20)
            }
        }
    }
    @IBOutlet weak var showNamelabel: UILabel!
    {
        didSet{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                self.showNamelabel.font = UIFont.init(name: "Helvetica-Bold", size: 24)
            }
            else{
               
                
            }
        }
    }
    @IBOutlet weak var metadataLabel: UILabel!{
        didSet{
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                self.metadataLabel.font = UIFont.init(name: "Helvetica-Bold", size: 16)
            }
        }
    }
    @IBOutlet weak var synopsisLabel: UILabel!
    
    @IBOutlet weak var ScreenviewWidth: NSLayoutConstraint!
    @IBOutlet weak var ScreenViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.batteryLevelChanged),
            name: Notification.Name("NotificationIdentifier"),
            object: nil)

        trendingImageLogo.contentMode = .scaleToFill
       
       
    }
    var flag = true
    @objc private func batteryLevelChanged(notification: NSNotification){
       
        self.bottomGradientView.setGradientBackground(colorTop:UIColor.clear, colorBottom: UIColor.black.withAlphaComponent(0.6))
        //do stuff using the userInfo property of the notification object
        print("view width", frame.width)


        print("image width", trendingImageLogo.frame.width)
        print("topgradientview width", topGradientView.frame.width)
        
        print("topgradientview x anchor", topGradientView.frame.origin.x)
        

    }
}
// MARK: Extensions
extension UIView{
  func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
     let gradientLayer = CAGradientLayer()
     gradientLayer.colors = [colorTop.cgColor,colorBottom.cgColor]
     gradientLayer.locations = [0.0, 1.0]
     gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80)
     layer.insertSublayer(gradientLayer, at: 0)
   }
    func setDianamicGradientBackground(colorTop: UIColor, colorBottom: UIColor,height:CGFloat) {
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = [colorTop.cgColor,colorBottom.cgColor]
       gradientLayer.locations = [0.0, 1.0]
       gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
       layer.insertSublayer(gradientLayer, at: 0)
     }
    func setGradientBackgroundForDetailScreen(colorTop: UIColor, colorBottom: UIColor) {
       let gradientLayer = CAGradientLayer()
       gradientLayer.colors = [colorTop.cgColor,colorBottom.cgColor]
       gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = UIScreen.main.bounds
       layer.insertSublayer(gradientLayer, at: 0)
     }
    
}
