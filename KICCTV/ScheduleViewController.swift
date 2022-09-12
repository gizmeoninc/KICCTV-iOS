//
//  ScheduleViewController.swift
//  PoppoTv
//
//  Created by GIZMEON on 27/05/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit
import Reachability

class ScheduleViewController: UIViewController {
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sheduleTableView: UITableView!
    
    var channelVideos = [VideoModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sheduleTableView.delegate = self
        self.sheduleTableView.dataSource = self
        self.initialView()
        getAllChannels()
        // Do any additional setup after loading the view.
    }
    // MARK: - Main Functions
    func initialView(){
        self.sheduleTableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleTableViewCell")
        self.sheduleTableView.separatorStyle = .none
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Program Schedule"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.sheduleTableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.contentView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func viewWillAppear(_ animated: Bool) {
       self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
   // MARK: - Main APIS
    func getAllChannels() {
      CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
        ApiCommonClass.getAllChannels { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                    WarningDisplayViewController().noResultview(view : self.view,title: "No Data Found")
                    CustomProgressView.hideActivityIndicator()
                }
            } else {
                self.channelVideos = responseDictionary["Channels"] as! [VideoModel]
                if self.channelVideos.count == 0 {
                    DispatchQueue.main.async {
                        WarningDisplayViewController().noResultview(view : self.view,title: "No Data Found")
                        CustomProgressView.hideActivityIndicator()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.sheduleTableView.reloadData()
                         CustomProgressView.hideActivityIndicator()
                    }
                }
                
            }
        }
    }

}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelVideos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell", for: indexPath) as! ScheduleTableViewCell
        cell.selectionStyle = .none
        cell.channelLogoImage.sd_setImage(with: URL(string: ((channelUrl + channelVideos[indexPath.row].logo!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "landscape_placeholder"))
        cell.channelNameLabel.text = channelVideos[indexPath.row].channel_name
        cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
        cell.channelNameLabel.textColor = ThemeManager.currentTheme().sideMenuTextColor
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return 200
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let watchListController = storyBoard.instantiateViewController(withIdentifier: "programeSchedule") as! ProgrameScheduleViewController
        watchListController.channelId = channelVideos[indexPath.row].channel_id!
        watchListController.logo = channelVideos[indexPath.row].logo!
        self.navigationController?.pushViewController(watchListController, animated: false)
        
    }
}



