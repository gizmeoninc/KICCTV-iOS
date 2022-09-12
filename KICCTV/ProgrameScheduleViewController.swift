//
//  ProgrameScheduleViewController.swift
//  PoppoTv
//
//  Created by Firoze Moosakutty on 28/05/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import UIKit

class ProgrameScheduleViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var DatePickerButton: UIButton!
    @IBOutlet weak var scheduledProgramTableView: UITableView!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var noResultView: UIView!

  var channelId = Int()
     var logo = String()
     var todayDate = ""
     var selectedDate = ""
     var pickedDate = ""
     var pickedDateFormat = ""
     var liveShowRow = Int()
     var todayPrograme = true
     var buttonPresssed = true
     var programScheduleArray = [ProgramModel]()
     var toolBar = UIToolbar()
     var picker  = UIDatePicker()
     var longTitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scheduledProgramTableView.delegate = self
        self.scheduledProgramTableView.dataSource = self
        self.todayDate = self.currentDateFormat()
        let StartTimedate = dateAtStartTime(String_date: currentLocalDate())
        let EndTimedate = dateAtEndTime(End_date: currentLocalDate())
        let StartTimedateUTC = LocalToTimeUTC(date: StartTimedate)
        let EndTimedateUTC = LocalToTimeUTC(date: EndTimedate)
        
        if (StartTimedateUTC != "" && EndTimedateUTC != "") {
           self.getScheduledPrograms(start_utc: StartTimedateUTC, end_utc: EndTimedateUTC)
        } else {
          self.noResultView.isHidden = false
          WarningDisplayViewController().noResultview(view : self.noResultView,title: "No Data Found")
          CustomProgressView.hideActivityIndicator()
        }
        self.initialView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if todayDate != "" {
            DatePickerButton.setTitle(todayDate, for: .normal)
        }
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    // MARK: - Main Functions
    func initialView(){
        self.scheduledProgramTableView.register(UINib(nibName: "ProgrameScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "ProgrameScheduleTableViewCell")
        self.scheduledProgramTableView.separatorStyle = .none
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Programs"
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ThemeManager.currentTheme().UIImageColor]
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.scheduledProgramTableView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.contentView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.noResultView.backgroundColor = ThemeManager.currentTheme().backgroundColor
        DatePickerButton.clipsToBounds = true
        DatePickerButton.backgroundColor = ThemeManager.currentTheme().UIImageColor
        DatePickerButton.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        DatePickerButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func scheduleButtonAction(_ sender: Any) {
      if buttonPresssed {
        self.buttonPresssed = false
        picker = UIDatePicker.init()
        picker.backgroundColor = UIColor.white
        picker.autoresizingMask = .flexibleWidth
        picker.datePickerMode = .date
        picker.minimumDate = Date()
        picker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        picker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 250 , width: UIScreen.main.bounds.size.width, height: 250)
        self.view.addSubview(picker)
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 45))
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
      } else {
          self.buttonPresssed = true
          toolBar.removeFromSuperview()
          picker.removeFromSuperview()
      }
    }
    @objc func dateChanged(_ sender: UIDatePicker?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = sender?.date {
            pickedDate = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "MMM dd,yyyy"
            pickedDateFormat = dateFormatter.string(from: date)
            
        }
    }
    
    @objc func onDoneButtonClick() {
        self.buttonPresssed = true
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        self.selectedDate = self.currentDate()
        let DateFromSelectedDate = String(selectedDate.prefix(10))
        let DateFromPickerDate = String(pickedDate.prefix(10))
        if  (pickedDate == "" ) {
        } else {
            if DateFromSelectedDate == DateFromPickerDate {
             self.todayPrograme = true
            } else {
                self.todayPrograme = false
            }
            DatePickerButton.setTitle(pickedDateFormat, for: .normal)
            let PickedDateString = self.PickedUTCDate(date: pickedDate)
            
            let StartTimedate = dateAtStartTime(String_date: PickedDateString)
            let EndTimedate = dateAtEndTime(End_date: PickedDateString)
            
            let StartTimedateUTC = LocalToTimeUTC(date: StartTimedate)
            let EndTimedateUTC = LocalToTimeUTC(date: EndTimedate)
            self.getScheduledPrograms(start_utc: StartTimedateUTC, end_utc: EndTimedateUTC)
        }
    }
    func currentDate()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.string(from: currentDate)
        return date
    }
    func currentDateFormat()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let currentDate = Date()
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.string(from: currentDate)
        return date
    }
    func PickedUTCDate(date :String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let UTCDateString = dateFormatter.date(from: date)
        let UTCStringDate = dateFormatter.string(from: UTCDateString!)
        print("Currentdate",UTCStringDate)
        return UTCStringDate
    }

    func currentLocalDate()-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.string(from: currentDate)
        return date
    }
    
    func UTCTimeToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let sheduledDateString = dateFormatter.string(from: dt!)
        let SheduleDate = dateFormatter.date(from: sheduledDateString)
        dateFormatter.dateFormat = "h:mm:ss a"
        let sheeduleDateInCurrentFormat = dateFormatter.string(from: SheduleDate!)
        return sheeduleDateInCurrentFormat
    }
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm:ss"
        return dateFormatter.string(from: dt!)
    }
    
    func StringToDate(String_date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss a"
        let dt = dateFormatter.date(from: String_date)
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from: dt!)
        let dateStringDate = dateFormatter.date(from: dateString)
        return dateStringDate!
    }
    
    func dateAtStartTime(String_date:String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let StringDate = dateFormatter.date(from: String_date)

        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let dateAtStartTime = calendar.startOfDay(for: StringDate!)

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let dateAtStartTimeString = dateFormatter.string(from: dateAtStartTime)
        return dateAtStartTimeString
    }
    func dateAtEndTime(End_date:String) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let StringDate = dateFormatter.date(from: End_date)

        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let dateAtStartTime = calendar.startOfDay(for: StringDate!)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let dateAtLastTime =  Calendar.current.date(byAdding: components, to: dateAtStartTime)

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let dateAtLastTimeString = dateFormatter.string(from: dateAtLastTime!)
        return dateAtLastTimeString
    }
    
    func LocalToTimeUTC(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: dt!)
    }
    
    // MARK: ?- Main API
    func getScheduledPrograms(start_utc: String,end_utc: String) {
        self.scheduledProgramTableView.isHidden = true
        self.noResultView.isHidden = true
        CustomProgressView.showActivityIndicator(userInteractionEnabled: true)
        var parameterDict: [String: String?] = [ : ]
        parameterDict["country_code"] = UserDefaults.standard.string(forKey:"countryCode")
        parameterDict["device_type"] = "ios-phone"
        parameterDict["channel_id"] = String(self.channelId)
        parameterDict["start_utc"] = start_utc
        parameterDict["end_utc"] = end_utc
       //parameterDict["date"] = scheduleDate
        ApiCommonClass.getScheduleByDate(parameterDictionary: parameterDict as? Dictionary<String, String>) { (responseDictionary: Dictionary) in
            if responseDictionary["error"] != nil {
                DispatchQueue.main.async {
                  self.noResultView.isHidden = false
                  WarningDisplayViewController().noResultview(view : self.noResultView,title: "No Data Found")
                    CustomProgressView.hideActivityIndicator()
                }
            } else {
               self.programScheduleArray = responseDictionary["Channels"] as! [ProgramModel]
                if self.programScheduleArray.count == 0 {
                    DispatchQueue.main.async {
                        self.noResultView.isHidden = false
                        WarningDisplayViewController().noResultview(view : self.noResultView,title: "No Data Found")
                        CustomProgressView.hideActivityIndicator()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.scheduledProgramTableView.reloadData()
                        self.noResultView.isHidden = true
                        self.scheduledProgramTableView.isHidden = false
                        CustomProgressView.hideActivityIndicator()
                    }
                }
                
            }
        }
        CustomProgressView.hideActivityIndicator()
    }
}
extension ProgrameScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programScheduleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProgrameScheduleTableViewCell", for: indexPath) as! ProgrameScheduleTableViewCell
        cell.selectionStyle = .none
        cell.programLogo.sd_setImage(with: URL(string: ((channelUrl + logo).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)),placeholderImage:UIImage(named: "placeHolder400*600"))
        cell.programLogo.contentMode = .scaleToFill
        if todayPrograme {
        let TestUTcTimeStart = self.UTCTimeToLocal(date: programScheduleArray[indexPath.row].start_time!)
        let TestUTCTimeEnd =   self.UTCTimeToLocal(date: programScheduleArray[indexPath.row].end_time!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        let StartTimeDate = dateFormatter.date(from: TestUTcTimeStart)!
        let endTimeDate = dateFormatter.date(from: TestUTCTimeEnd)
        let myCalendar = Calendar(identifier: .gregorian)
        let startTimeComponents = myCalendar.dateComponents([.hour, .minute,], from: StartTimeDate)
        let startHour = startTimeComponents.hour
        let startMinute = startTimeComponents.minute
            let endTimeComponents = myCalendar.dateComponents([.hour, .minute], from: endTimeDate!)
        let endHour = endTimeComponents.hour
        let endMinute = endTimeComponents.minute
        let now = Date()
        let start_time = now.dateAt(hours: startHour!, minutes: startMinute!)
        let end_time = now.dateAt(hours: endHour!, minutes: endMinute!)
        if (now >= start_time && now <= end_time) {
             cell.LiveNowLabel.isHidden = false
             liveShowRow = indexPath.row
          }else {
           cell.LiveNowLabel.isHidden = true
          }
        }else {
            cell.LiveNowLabel.isHidden = true
        }
        let TestUTcTimeStart = self.UTCTimeToLocal(date: programScheduleArray[indexPath.row].start_time!)
        let TestUTCTimeEnd =   self.UTCTimeToLocal(date: programScheduleArray[indexPath.row].end_time!)
        cell.programName.text = programScheduleArray[indexPath.row].program_name
        let message = "\(TestUTcTimeStart) - \(TestUTCTimeEnd)"
        cell.ProgramSchedue.text = message
        cell.backgroundColor = ThemeManager.currentTheme().backgroundColor
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
        if (indexPath.row == liveShowRow) {
            let videoPlayerController = storyboard?.instantiateViewController(withIdentifier: "channelvideo") as! ChannelVideoViewController
            videoPlayerController.fromNotification = false
            videoPlayerController.channelNotificationId = channelId
            self.navigationController?.pushViewController(videoPlayerController, animated: false)
        }
    }
}

extension Date {
    func dateAt(hours: Int, minutes: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}
