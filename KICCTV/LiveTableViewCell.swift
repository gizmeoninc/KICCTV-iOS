//
//  FilmVideoTableViewCell.swift
//  Justwatchme.tv
//
//  Created by GIZMEON on 28/09/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//



import UIKit
protocol liveTableViewCellDelegate:class {
    func didSelectShedule(passModel :LiveGuideModel)
  
}

class LiveTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var flag = true
    
  @IBOutlet weak  var liveGuideCollectionView: UICollectionView!
    @IBOutlet weak var homeButton: UIButton!{
      didSet{
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
          homeButton.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 20)
        } else {
          homeButton.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 16)
        }
      }
    }
    @IBOutlet weak var rightArrowImageView: UIImageView!
  var channelType = ""
    var startTime = Date()
    var endTime = Date()
    var timeStart = String()
    var timeEnd = String()
  var liveGuideArray: [LiveGuideModel]? {
    didSet{
        liveGuideCollectionView.reloadData()
              self.layoutIfNeeded()
    }
  }
    weak var delegate: liveTableViewCellDelegate!

    var width = CGFloat()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        liveGuideCollectionView.register(UINib(nibName: "LiveGuideCollelctionViewCell", bundle: nil), forCellWithReuseIdentifier: "LiveGuideCollectionCell")
        liveGuideCollectionView.dataSource = self
        liveGuideCollectionView.delegate = self
        liveGuideCollectionView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        rightArrowImageView.setImageColor(color: ThemeManager.currentTheme().HeadTextColor)

      
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func GetFormatedDate(date_string:String,dateFormat:String)-> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        
        let dateFromInputString = dateFormatter.date(from: date_string)
        dateFormatter.dateFormat = "MM-dd-yyyy" // Here you can use any dateformate for output date
        if(dateFromInputString != nil){
            return dateFormatter.string(from: dateFromInputString!)
        }
        else{
            debugPrint("could not convert date")
            return "N/A"
        }
    }
    func convertStringTimeToDate(item: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let date = dateFormatter.date(from:item)!
        return date
    }
    
  
  // MARK: Collectionview
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if liveGuideArray!.count > 0{
            return liveGuideArray!.count
        }
        return 0
       
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveGuideCollectionCell", for: indexPath as IndexPath) as! LiveGuideCollectionViewCell
      if liveGuideArray?.count == 0{
          self.homeButton.isHidden = true
          self.rightArrowImageView.isHidden = true
      }
      cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
      let formatter = DateFormatter()
      formatter.timeZone = TimeZone.current
      formatter.dateFormat = "h:mm a"
      formatter.amSymbol = "AM"
      formatter.pmSymbol = "PM"
       let calendar = Calendar.current
      if liveGuideArray![indexPath.row].starttime == nil && liveGuideArray![indexPath.row].endtime == nil{
          cell.timeLabel.text  = ""
          cell.weekdayLabel.text = ""
      }
      else{
          self.startTime = convertStringTimeToDate(item: liveGuideArray![indexPath.row].starttime!)
          
          self.timeStart = formatter.string(from: startTime)
          self.endTime = convertStringTimeToDate(item: liveGuideArray![indexPath.row].endtime!)
          self.timeEnd = formatter.string(from: endTime)
          cell.weekdayLabel.text =  String(format:"%@-%@", timeStart,timeEnd)
          if  calendar.isDateInToday(startTime) {
                 cell.timeLabel.text = " "
             }
          else if  calendar.isDateInYesterday(startTime){
                  cell.timeLabel.text = " "
              }
          else {
              cell.timeLabel.text = self.GetFormatedDate(date_string: liveGuideArray![indexPath.row].starttime!, dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")

          }
      }
      if liveGuideArray![indexPath.row].video_title != nil {
          cell.videoTitle.text = liveGuideArray![indexPath.row].video_title
        }
        else{
            cell.videoTitle.text = ""
        }
        
      if liveGuideArray![indexPath.row].thumbnail != nil {
  //        let now = Date()

         
          cell.trendingImageLogo.sd_setImage(with: URL(string: ((imageUrl + liveGuideArray![indexPath.row].thumbnail!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
          
         
  //        cell.sheduleLabel.isHidden = true
      
      } else {
         cell.trendingImageLogo.image = UIImage(named: "landscape_placeholder")
          
      }
     
     cell.layer.masksToBounds = true
       return cell
}
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10.0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = (frame.width ) / 2.3
      let height = width * 9 / 16
      return CGSize(width: width, height: height + 90)

  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}




