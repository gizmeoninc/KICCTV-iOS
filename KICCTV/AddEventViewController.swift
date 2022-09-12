//
//  AddViewController.swift
//  SoShall
//
//  Created by GIZMEON on 30/04/19.
//  Copyright © 2019 SoShall. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps
import GooglePlaces
import Firebase
import BrightFutures
class AddEventViewController: UIViewController,goToBackDelegate,UITextViewDelegate,UIGestureRecognizerDelegate {
	// MARK:Outlets
	@IBOutlet weak var horizontalDateAndTimePickerViewHeight: NSLayoutConstraint!
	@IBOutlet weak var timePickerBackgroundView: UIView!
	@IBOutlet var timePicker: UIPickerView!
	@IBOutlet var datePicker: UIPickerView!
	@IBOutlet weak var selectedTimeLabelView: UIView!
	@IBOutlet weak var selectedDateLabelView: UIView!
	@IBOutlet weak var datePickerBackgroundView: UIView!
	
	@IBOutlet weak var categoryView: UIView! {
		didSet {
			categoryView.backgroundColor = UIColor.white
		}
	}
	
	@IBOutlet weak var subCategoryView: UIView! {
		didSet {
			subCategoryView.backgroundColor = UIColor.white
		}
	}
	
	@IBOutlet weak var categoriesCollectionView: UICollectionView!
	
	@IBOutlet weak var subCategoryCollectionView: UICollectionView! {
		didSet {
			subCategoryCollectionView.isHidden = true
		}
	}
	
	@IBOutlet weak var autoFindNextAvailableDateButton: UIButton!{
		didSet {
			
//			autoFindNextAvailableDateButton.setImage(UIImage(named: "freetimegrey"), for: UIControl.State())
//			autoFindNextAvailableDateButton.alpha = 0.5
//			autoFindNextAvailableDateButton.isUserInteractionEnabled = false
		}
	}
	
	@IBOutlet weak var horizontalDateAndTimePickerView: UIView! {
		didSet {
			horizontalDateAndTimePickerView.backgroundColor = UIColor.white
		}
	}
	
	@IBOutlet var categoryAndSubCategoryWidth: NSLayoutConstraint!
	
	@IBOutlet weak var monthLabel: UILabel!
	
	@IBOutlet weak var categoryAndSubCategoryNameLabel: UILabel! {
		didSet {
			categoryAndSubCategoryNameLabel.layer.cornerRadius =  categoryAndSubCategoryNameLabel.frame.height/2
			categoryAndSubCategoryNameLabel.layer.borderWidth = 2.0
			categoryAndSubCategoryNameLabel.layer.borderColor = UIColor.SOS_AttendeesRedBorder.cgColor
			categoryAndSubCategoryNameLabel.sizeToFit()
		}
	}
	
	@IBOutlet weak var eventNameLabel: UILabel! {
		didSet {
			eventNameLabel.clipsToBounds = true
			eventNameLabel.layer.cornerRadius = 10
			eventNameLabel.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
		}
	}
	
	@IBOutlet weak var mainView: UIView! {
		didSet {
			mainView.layer.shadowColor = UIColor.black.cgColor;
			mainView.layer.shadowOpacity = 0.5;
			mainView.layer.shadowRadius  = 5;
			mainView.layer.shadowOffset  = CGSize(width :0, height :0)
			mainView.layer.masksToBounds = false;
			mainView.layer.cornerRadius  =  2.0;
			mainView.backgroundColor     = UIColor.white;
			mainView.layer.cornerRadius = 10.0
			mainView.isHidden = true
		}
	}
	//Attendees Search
	
	@IBOutlet weak var attendeesSearchTextField: UITextField! {
		didSet {
			setBorder(textField: attendeesSearchTextField)
			setUpAttendeesTextFieldUI(textField : attendeesSearchTextField)
			setPaddingToTextfield(textField : attendeesSearchTextField)
		}
	}
	
	@IBOutlet weak var attendeesSearchView: UIView!{
		didSet {
			attendeesSearchView.alpha = 0
		}
	}
	
	@IBOutlet weak var attendeesSearchBackgroundView: UIView!
	
	@IBOutlet weak var attendeesSearchTableView: UITableView! {
		didSet {
			attendeesSearchTableView.isHidden = true
		}
	}
	
	@IBOutlet weak var selectedAttendeesCollectionview: UICollectionView!{
		didSet {
			selectedAttendeesCollectionview.isHidden = true
		}
	}
	
	@IBOutlet weak var nextButton: UIButton!{
		didSet {
			nextButton.isHidden = true
		}
	}
	@IBOutlet weak var previousButton: UIButton!{
		didSet {
			previousButton.isHidden = true
		}
	}
	
	@IBOutlet weak var closeAttendeesSearch: UIButton!{
		didSet {
			closeAttendeesSearch.isHidden = true
		}
	}
	
	@IBOutlet weak var attendeesSearchBackgroundViewHeight: NSLayoutConstraint!
	@IBOutlet weak var subCategoryLabel: UILabel!
	//stackView
	@IBOutlet weak var selectedLocationHeight: NSLayoutConstraint!
	@IBOutlet weak var selectedCategoryWidth: NSLayoutConstraint!
	@IBOutlet weak var selectedDateAndTimeOuterView: UIView!
	
	@IBOutlet weak var selectedDateAndTimeInnerView: UIView!{
		didSet {
			selectedDateAndTimeInnerView.layer.cornerRadius =  selectedDateAndTimeInnerView.frame.height/2
			selectedDateAndTimeInnerView.layer.borderWidth = 2.0
			selectedDateAndTimeInnerView.layer.borderColor = UIColor.SOS_AttendeesRedBorder.cgColor
			selectedDateAndTimeInnerView.sizeToFit()
		}
	}
	@IBOutlet weak var selectedCategoryAndSubcategoryOuterView: UIView!
	
	@IBOutlet weak var selectedCategoryLabel: UILabel! {
		didSet {
			selectedCategoryLabel.layer.cornerRadius =  selectedCategoryLabel.frame.height/2
			selectedCategoryLabel.layer.borderWidth = 2.0
			selectedCategoryLabel.layer.borderColor = UIColor.SOS_AttendeesRedBorder.cgColor
			selectedCategoryLabel.sizeToFit()
		}
	}
	@IBOutlet weak var selecteAttendeesListingCollectionView: UICollectionView!
	
	@IBOutlet weak var seletedDateLabel: UILabel!
	@IBOutlet weak var seletedTimeLabel: UILabel!
	
	@IBOutlet weak var selectedLocationLabel: EdgeInsetLabel! {
		didSet {
			selectedLocationLabel.layer.cornerRadius =  selectedLocationLabel.frame.height/2
			selectedLocationLabel.layer.borderWidth = 2.0
			selectedLocationLabel.layer.borderColor = UIColor.SOS_AttendeesRedBorder.cgColor
			selectedLocationLabel.sizeToFit()
		}
	}
	
	@IBOutlet weak var selectedAttendeesCountLabel: UILabel!
	
	@IBOutlet weak var selectedDescriptionTextView: UITextView!{
		didSet {
			selectedDescriptionTextView.isHidden = true
			selectedDescriptionTextView.layer.cornerRadius = 10
			selectedDescriptionTextView.layer.borderWidth = 1.0
			selectedDescriptionTextView.layer.borderColor = UIColor.SOS_AttendeesRedBorder.cgColor
			selectedDescriptionTextView.textColor = UIColor.SOS_AttendeesRedBorder
		}
	}
	
	@IBOutlet weak var selectedAttendeesView: UIView!
	
	@IBOutlet weak var selectedDataStackView: UIStackView!{
		didSet {
			selectedDataStackView.isHidden = true
		}
	}
	@IBOutlet weak var descriptionTextViewHeight: NSLayoutConstraint!
	// location
	@IBOutlet weak var locationView: UIView!{
		didSet {
			locationView.backgroundColor = UIColor.white
			locationView.alpha = 0
		}
	}
	
	@IBOutlet weak var locationSearchTextField: UITextField! {
		didSet {
			setBorder(textField: locationSearchTextField)
			setUpAttendeesTextFieldUI(textField : locationSearchTextField)
			setPaddingToTextfield(textField : locationSearchTextField)
		}
	}
	
	@IBOutlet weak var locationSearchTableView: UITableView! {
		didSet {
			locationSearchTableView.isHidden = true
		}
	}
	
	@IBOutlet weak var locationSearchBackgroundView: UIView!
	
	@IBOutlet weak var closeLocationSearch: UIButton!{
		didSet {
			closeLocationSearch.isHidden = true
		}
	}
	
	//descriptionview
	
	@IBOutlet weak var eventDescriptionTextViewHeight: NSLayoutConstraint!
	@IBOutlet weak var eventDescriptionview: UIView! {
		didSet {
			eventDescriptionview.isHidden = true
		}
	}
	
	@IBOutlet weak var eventDescriptionTextView: UITextView!{
		didSet {
			eventDescriptionTextView.layer.cornerRadius = 10
			eventDescriptionTextView.layer.borderWidth = 1.0
			eventDescriptionTextView.layer.borderColor = UIColor.SOS_CommonGrayColor.cgColor
			eventDescriptionTextView.delegate = self
		}
	}
	
	@IBOutlet weak var eventTypeView: UIView!{
		didSet {
			eventTypeView.isHidden = true
		}
	}
	
	@IBOutlet weak var confirmEventView: UIView! {
		didSet {
			confirmEventView.isHidden = true
		}
	}
	
	@IBOutlet weak var confirmEventButton: UIButton!  {
		didSet {
			confirmEventButton.layer.cornerRadius =  confirmEventButton.frame.height/2
			confirmEventButton.layer.borderWidth = 2.0
			confirmEventButton.layer.borderColor = UIColor.SOS_AttendeesRedBorder.cgColor
			confirmEventButton.sizeToFit()
		}
	}
	// MARK:Constants
	var rotationAngle : CGFloat!
	var eventName = ""
	var categoriesArray = ["Personal","Work","Meeting","Recreation","Other"]
	var dateArray: [Date]  {
		return Date().generateDatesArrayBetweenTwoDates(startDate: Date().startOfDay, endDate: Date().startOfDay.addingTimeInterval(TimeInterval(365 * 24 * 60 * 60)))
	}
	var attendeesSearchViewAnimated = Bool()
	var locationSearchViewAnimated = Bool()
	var placeDict: [[String: AnyObject]] = [[:]]
	var cellString: String = ""
	var locationManager:CLLocationManager? = CLLocationManager()
	var placesClient = GMSPlacesClient()
	var eventDescriptionContentHeight = CGFloat()
	var eventEndDate: Date = Date()
	var selectedLatitude:Double = 0.0
	var selectedLongitude:Double = 0.0
	var usersArray = [SoSContactStatus]()
	
	var timeArray = [Date]()
	var selectedDate = Date()
	var selectedTime =  Date()
	var selectedAttendees = [SoSContactStatus]()
	var selectedCategory = ""
	var weather = [String: Any]()
	let progressIndicator = UIActivityIndicatorView()
	var searchTimer: Timer?
	var duration = 120
	var endDate: Date? = Date()
	var freeTimeUsers = [SoSEventUser]()
	override func viewDidLoad() {
		super.viewDidLoad()
		registerTableviewAndCollectionView()
		hideKeyBoard()
		touchToView()
		touchtoTextView()
		initSubViews()
		selectedDescriptionTextView.delegate = self
		
	}
	override func viewDidLayoutSubviews() {
		//to hide the selection indicator
		datePicker.subviews[1].isHidden = true
		datePicker.subviews[2].isHidden = true
		timePicker.subviews[1].isHidden = true
		timePicker.subviews[2].isHidden = true
		eventDescriptionTextView.setContentOffset(CGPoint.zero, animated: false)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		Application.shared.nextFreeDate = nil
		self.mainView.isHidden = true
		self.removeContactSelection()
		self.attendeesSearchTableView.reloadData()
		self.selectedAttendees.removeAll()
		self.freeTimeUsers.removeAll()
		let attendee = SoSEventUser(Application.shared.appUser!.key, ((Application.shared.appUser?.user!.name)!))
		self.freeTimeUsers.append(attendee)
		//self.updateUserFreeUI()
		loadUsers()
		self.selectedAttendeesCollectionview.reloadData()
		self.datePicker.delegate = self
		self.datePicker.dataSource = self
		self.timePicker.delegate = self
		self.timePicker.dataSource = self
		setupDateAndTimepicker()
		
		let vc = self.storyboard?.instantiateViewController(withIdentifier: "addEvent") as! AddEventPopupViewController
		vc.delegate = self
		vc.modalPresentationStyle = .overCurrentContext
		self.tabBarController?.present(vc, animated: true, completion: nil)
		
		let contactsCount = self.getContacts().count
		if contactsCount == 0 {
			ContactApi.shared.LoadContacts().onComplete { result in
				Log.note(.contacts, "Loaded Contacts")
				self.syncIfRequired()
			}
		} else {
			Log.note(.contacts, "Contacts allready loaded")
			syncIfRequired()
		}
		self.checkServiceEnabledOrNot()
		
	}
	func gotoBack() {
		self.tabBarController?.selectedIndex = Application.shared.currentTabIndex!
	
	}
	func hideKeyBoard() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		horizontalDateAndTimePickerView.addGestureRecognizer(tap)
	}
	@objc func dismissKeyboard() {
		horizontalDateAndTimePickerView.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.attendeesSearchTextField.resignFirstResponder()
		return true
	}
	
	func setBorder(textField: UITextField) {
		textField.layer.cornerRadius =  textField.frame.height/2
		textField.layer.borderWidth = 1.0
		textField.layer.borderColor = UIColor.SOS_CommonGrayColor.cgColor
	}
	func initSubViews() {
		let screenBound = UIScreen.main.bounds
		progressIndicator.frame = CGRect(x: screenBound.width / 2,
										 y: screenBound.height / 2,
										 width: 50, height: 50)
		progressIndicator.hidesWhenStopped = true
		progressIndicator.color = UIColor.SOS_PrimaryColour
		progressIndicator.style = UIActivityIndicatorView.Style.gray
		// self.view is scroll view
		progressIndicator.center  =  self.view.center
		self.view.bringSubviewToFront(progressIndicator)
	}
	func setPaddingToTextfield(textField : UITextField) {
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
		textField.leftViewMode = .always
		
	}
	func setUpTimeArray() {
		var scrollIndex: Int
		if self.selectedDate.startOfDay  == Date().startOfDay {
			timeArray =  Date().generateTimeArrayAddingFifteenMinutes(startDate: Date().nearestFifteenthMinute(), endDate: Date().endOfDay!)
			let date = Date().startOfDay.addingTimeInterval(12*60*60)
			if timeArray.contains(date), let index = timeArray.firstIndex(of: date) {
				scrollIndex = index
			} else {
				scrollIndex = 0
			}
		} else {
			timeArray = Date().generateTimeArrayAddingFifteenMinutes(startDate: Date().startOfDay, endDate: Date().endOfDay!)
			scrollIndex = 48
		}
		timePicker.reloadAllComponents()
		self.timePicker.selectRow(scrollIndex, inComponent: 0, animated: true)
	}
	func getContacts() -> [SoSContactStatus] {
		var contacts = Application.shared.contacts.SoShallUsers.filter{ $0.userID != Application.shared.appUser?.key
		}
		if !attendeesSearchTextField.text!.isEmpty {
			contacts = contacts.filter { ($0.name.lowercased().contains(attendeesSearchTextField.text!.lowercased())) }
			return contacts
		} else {
			return contacts
		}
	}
	
	func syncIfRequired() {
		let toSync = Application.shared.contacts.getRequiringRefresh()
		if toSync.count > 0 {
			Log.note(.contacts, "Found some contacts that need syncing so start syncing now")
			ContactApi.shared.syncContacts().onSuccess {
				self.attendeesSearchTableView.reloadData()
			}
		} else {
			Log.note(.contacts, "No contacts that need syncing")
		}
	}
	
	func setUpAttendeesTextFieldUI(textField : UITextField) {
		let image = UIImageView(image: UIImage(named: "icons8-search-30"))
		if let size = image.image?.size {
			image.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 20.0, height: size.height)
		}
		image.contentMode = UIView.ContentMode.center
		textField.rightView = image
		textField.rightViewMode = UITextField.ViewMode.always
		textField.delegate = self
		textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
	}
	func removeAtendeesTextFieldImage(textField: UITextField) {
		let image = UIImageView(image: UIImage(named: ""))
		textField.rightView = image
	}
	@objc private func textFieldDidChange(_ textField: UITextField) {
		if textField == self.attendeesSearchTextField {
			if self.attendeesSearchTextField.text?.count == 1 && self.attendeesSearchViewAnimated == false {
				if UIDevice.current.userInterfaceIdiom == .phone {
					self.animateTextField(textField: textField, up: true)
					self.attendeesSearchBackgroundViewHeight.constant = 170
					self.removeAtendeesTextFieldImage(textField: self.attendeesSearchTextField)
					self.closeAttendeesSearch.isHidden = false
					
					
				}
				self.setupAttendeesSearchFunctionalityWhenCountOne()
			}
			self.attendeesSearchTableView.reloadData()
			
		} else {
			self.checkServiceEnabledOrNot()
			if self.locationSearchTextField.text?.count == 1 && self.locationSearchViewAnimated == false {
				if UIDevice.current.userInterfaceIdiom == .phone {
					self.setupLocationSearchFunctionalityWhenCountOne()
				}
			}
			if searchTimer != nil {
				searchTimer?.invalidate()
				searchTimer = nil
			}
			
			// reschedule the search: in 1.0 second, call the searchForKeyword method on the new textfield content
		if !locationSearchTextField.text!.isEmpty {
				searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(autoCompleteApi(_:)), userInfo: textField.text!, repeats: false)
		} else {
			self.placeDict.removeAll()
			self.locationSearchTableView.reloadData()
			}
			//self.autoCompleteApi(text: locationSearchTextField.text!)
		}
	}
	
	func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
		self.eventDescriptionContentHeight = self.eventDescriptionTextView.contentSize.height
		if eventDescriptionContentHeight + 10 > 120 {
			self.eventDescriptionTextViewHeight.constant = 120
		} else {
			self.eventDescriptionTextViewHeight.constant = eventDescriptionContentHeight + 10
		}
	}
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			self.eventDescriptionTextView.resignFirstResponder()
			self.eventDescriptionview.isHidden = true
			self.eventDescriptionContentHeight = self.eventDescriptionTextView.contentSize.height
			if eventDescriptionContentHeight + 10 > 136 {
				self.descriptionTextViewHeight.constant = 136
			} else {
				self.descriptionTextViewHeight.constant = eventDescriptionContentHeight + 10
			}
			self.selectedDataStackView.arrangedSubviews[0].isHidden = false
			self.selectedDataStackView.arrangedSubviews[1].isHidden = false
			self.selectedDataStackView.arrangedSubviews[2].isHidden = false
			self.selectedDataStackView.arrangedSubviews[3].isHidden = false
			self.selectedDataStackView.arrangedSubviews[4].isHidden = false
			self.selectedDescriptionTextView.isHidden = false
			self.selectedDescriptionTextView.text = eventDescriptionTextView.text
			self.confirmEventView.isHidden = false
			self.selectedDataStackView.isHidden = false
		}
		return true
	}
	
	func setupAttendeesSearchFunctionalityWhenCountOne() {
		self.horizontalDateAndTimePickerViewHeight.constant = 0
		self.attendeesSearchTableView.isHidden = false
		self.selectedAttendeesCollectionview.isHidden = false
		self.attendeesSearchBackgroundView.layer.cornerRadius = 20.0
		self.attendeesSearchBackgroundView.layer.borderWidth = 1.0
		self.attendeesSearchBackgroundView.layer.borderColor = UIColor.SOS_EventAttendeesGreyBorder.cgColor
		self.attendeesSearchTextField.layer.borderColor = UIColor.clear.cgColor
		self.attendeesSearchTextField.layer.masksToBounds = false
		self.attendeesSearchTextField.addBorder(toSide: .bottom, withColor: UIColor.SOS_EventAttendeesGreyBorder.cgColor, andThickness: 1.0)
		self.horizontalDateAndTimePickerView.alpha = 0
	}
	func setupLocationSearchFunctionalityWhenCountOne() {
		UIView.animate(withDuration: 0.5) {
			self.selectedDataStackView.arrangedSubviews[0].isHidden = true
			self.selectedDataStackView.arrangedSubviews[1].isHidden = true
			self.selectedDataStackView.arrangedSubviews[2].isHidden = true
			self.selectedDataStackView.arrangedSubviews[3].isHidden = true
			self.selectedDataStackView.arrangedSubviews[4].isHidden = true
			self.closeLocationSearch.isHidden = false
			self.locationSearchTableView.isHidden = false
			self.removeAtendeesTextFieldImage(textField: self.locationSearchTextField)
			self.locationSearchBackgroundView.layer.cornerRadius = 20.0
			self.locationSearchBackgroundView.layer.borderWidth = 1.0
			self.locationSearchBackgroundView.layer.borderColor = UIColor.SOS_EventAttendeesGreyBorder.cgColor
			self.locationSearchTextField.layer.borderColor = UIColor.clear.cgColor
			self.locationSearchTextField.layer.masksToBounds = false
			self.locationSearchTextField.addBorder(toSide: .bottom, withColor: UIColor.SOS_EventAttendeesGreyBorder.cgColor, andThickness: 1.0)
			self.locationSearchViewAnimated = true
		}
	}
	func removeAnimation() {
		self.horizontalDateAndTimePickerViewHeight.constant = 180
		self.attendeesSearchViewAnimated = false
		self.attendeesSearchTextField.resignFirstResponder()
		self.attendeesSearchTextField.text = ""
		self.attendeesSearchBackgroundView.layer.borderWidth = 0
		self.attendeesSearchTextField.layer.masksToBounds = true
		self.setBorder(textField: attendeesSearchTextField)
		self.attendeesSearchTableView.isHidden = true
		self.horizontalDateAndTimePickerView.alpha = 1
	}
	func removeAnimatedSearchView() {
		self.setUpAttendeesTextFieldUI(textField: attendeesSearchTextField)
		self.closeAttendeesSearch.isHidden = true
		self.attendeesSearchBackgroundViewHeight.constant = 37
		self.selectedAttendeesCollectionview.isHidden = false
		if self.selectedAttendees.count > 0 {
			self.nextButton.isHidden = false
			self.previousButton.isHidden = true
		} else  {
			self.nextButton.isHidden = true
				self.previousButton.isHidden = true
		}
		
		self.attendeesSearchTextField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
		self.attendeesSearchTextField.layer.borderColor = UIColor.clear.cgColor
	}
	func createEventClicked(eventName: String) {
		self.subCategoryView.isHidden = true
		self.horizontalDateAndTimePickerView.isHidden = true
		self.attendeesSearchView.isHidden = true
		self.selectedCategoryAndSubcategoryOuterView.isHidden = true
		self.selectedDateAndTimeOuterView.isHidden = true
		self.selectedLocationLabel.isHidden = true
		self.selectedAttendeesView.isHidden = true
		self.selectedDescriptionTextView.isHidden = true
		self.selectedDataStackView.isHidden = true
		self.locationView.isHidden = true
		self.eventDescriptionview.isHidden = true
		self.confirmEventView.isHidden = true
		self.mainView.isHidden = false
		self.categoryView.isHidden = false
		self.eventNameLabel.text = eventName
	}
	
	func setupDateAndTimepicker() {
		self.horizontalDateAndTimePickerView.alpha = 0
		self.rotationAngle = -90 * (.pi / 180 )
		self.setUpTimeArray()
		self.datePicker.selectRow(0, inComponent: 0, animated: true)
		self.pickerView(self.datePicker, didSelectRow: 0, inComponent: 0)
		self.timePicker.selectRow(0, inComponent: 0, animated: true)
	}
	
	func setUpDatePicker() {
		self.datePicker.transform =  CGAffineTransform(rotationAngle:rotationAngle)
		self.datePicker.frame = CGRect(x: -50, y: 0, width: self.datePickerBackgroundView.frame.width + 100, height: 35)
		self.datePickerBackgroundView.backgroundColor = UIColor.white
		self.datePicker.backgroundColor = UIColor.clear
		self.selectedDateLabelView.layer.borderColor = UIColor.SOS_CommonRedColor.cgColor
		self.selectedDateLabelView.layer.borderWidth = 2.0
		self.selectedDateLabelView.layer.cornerRadius = selectedDateLabelView.frame.height/2
		self.selectedDateLabelView.backgroundColor = UIColor.white
	}
	
	func setUpTimePicker() {
		self.timePicker.transform =  CGAffineTransform(rotationAngle:rotationAngle)
		self.timePicker.frame = CGRect(x: -50, y: 0, width: self.datePickerBackgroundView.frame.width + 100, height: 35)
		self.timePickerBackgroundView.backgroundColor = UIColor.white
		self.timePicker.backgroundColor = UIColor.clear
		self.selectedTimeLabelView.layer.borderColor = UIColor.SOS_CommonRedColor.cgColor
		self.selectedTimeLabelView.layer.borderWidth = 2.0
		self.selectedTimeLabelView.layer.cornerRadius = selectedTimeLabelView.frame.height/2
		self.selectedTimeLabelView.backgroundColor = UIColor.white
	}
	
	@IBAction func closeAttendeesSearchAction(_ sender: Any) {
		loadUsers()
		self.removeAnimatedSearchView()
		self.removeAnimation()
	}
	
	
	@IBAction func closeLocationSearchAction(_ sender: Any) {
		self.locationSearchTextField.resignFirstResponder()
		UIView.animate(withDuration: 0.5) {
			self.removeLocationShowingView()
		}
	}
	
	func setupPreviousDatas()
	{
		self.categoryView.isHidden = true
		self.subCategoryView.isHidden = true
		self.eventDescriptionview.isHidden = true
		self.confirmEventView.isHidden = true
		self.horizontalDateAndTimePickerView.isHidden = true
		self.horizontalDateAndTimePickerView.alpha = 0
		self.attendeesSearchView.isHidden = true
		self.attendeesSearchView.alpha = 0
		self.selectedCategoryAndSubcategoryOuterView.isHidden = false
		self.selectedDateAndTimeOuterView.isHidden = false
		self.selectedAttendeesView.isHidden = false
		self.selectedLocationLabel.isHidden = true
		self.descriptionTextViewHeight.constant = 0
		self.selectedDescriptionTextView.isHidden = true
		self.selecteAttendeesListingCollectionView.isHidden = false
		self.selectedDataStackView.isHidden = false
		self.locationView.alpha = 1.0
		self.locationView.isHidden = false
		
		let width = textWidth(text: selectedCategory, font: Application.shared.proximaFontMedium23) + 20
		self.selectedCategoryWidth.constant = width
		self.selectedCategoryLabel.text = selectedCategory
		self.selectedCategoryLabel.font = Application.shared.proximaFontMedium23
		self.seletedDateLabel.text = Application.shared.potentialDate.string("MM/dd")
		self.seletedTimeLabel.text = selectedTime.string("HH:mm")
		self.seletedDateLabel.font = Application.shared.proximaFontMedium23
		self.seletedTimeLabel.font = Application.shared.proximaFontMedium23
		self.selectedAttendeesCountLabel.text = String(format: "%d", self.selectedAttendees.count)
		self.locationSearchTextField.resignFirstResponder()
		self.attendeesSearchTextField.resignFirstResponder()
	}
	
	func removeLocationShowingView() {
		self.selectedDataStackView.arrangedSubviews[0].isHidden = false
		self.selectedDataStackView.arrangedSubviews[1].isHidden = false
		self.selectedDataStackView.arrangedSubviews[3].isHidden = false
		self.selectedLocationLabel.isHidden = true
		self.selectedDescriptionTextView.isHidden = true
		self.selectedDataStackView.isHidden = false
		self.locationSearchTextField.layer.masksToBounds = true
		self.locationSearchBackgroundView.layer.borderWidth = 0
		self.setBorder(textField: locationSearchTextField)
		self.locationSearchTableView.isHidden = true
		self.locationSearchViewAnimated = false
		self.locationSearchTextField.text = ""
		//		self.locationSearchTextField.resignFirstResponder()
	}
	
	func registerTableviewAndCollectionView() {
		self.locationManager?.delegate = self
		self.categoriesCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
		self.categoriesCollectionView.delegate = self
		self.categoriesCollectionView.dataSource = self
		let flowLayout = CustomFlowLayout()
		self.categoriesCollectionView.collectionViewLayout = flowLayout
		
		let nib =  UINib(nibName: "AttendeesSearchTableViewCell", bundle: nil)
		self.attendeesSearchTableView.register(nib, forCellReuseIdentifier: "cell")
		self.selectedAttendeesCollectionview.register(UINib(nibName: "SelectedAttendeesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "selectedAttendeesCell")
		self.selectedAttendeesCollectionview.delegate = self
		self.selectedAttendeesCollectionview.dataSource = self
		self.attendeesSearchTableView.allowsMultipleSelection = true
		
		self.selecteAttendeesListingCollectionView.register(UINib(nibName: "SelectedAttendeesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "selectedAttendeesCell")
		self.selecteAttendeesListingCollectionView.delegate = self
		self.selecteAttendeesListingCollectionView.dataSource = self
		
		let cellNibCal = UINib(nibName: "MapSearchTableViewCell", bundle: nil)
		self.locationSearchTableView.register(cellNibCal, forCellReuseIdentifier: "searchCell")
		self.locationSearchTableView.delegate = self
		self.locationSearchTableView.dataSource = self
	}
	
	//handle tap
	func touchToView() {
		self.selectedCategoryAndSubcategoryOuterView.isUserInteractionEnabled = true
		self.selectedDateAndTimeOuterView.isUserInteractionEnabled = true
		self.selectedLocationLabel.isUserInteractionEnabled = true
		let categoryTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		let dateAndTimeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		let attendeesViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		let locationTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
		self.selectedCategoryAndSubcategoryOuterView.addGestureRecognizer(categoryTapGesture)
		self.selectedDateAndTimeOuterView.addGestureRecognizer( dateAndTimeTapGesture)
		self.selectedAttendeesView.addGestureRecognizer(attendeesViewTapGesture)
		self.selectedLocationLabel.addGestureRecognizer(locationTapGesture)
	}
	
	@objc func handleTap(_ sender: UITapGestureRecognizer) {
		self.attendeesSearchTextField.resignFirstResponder()
		self.locationSearchTextField.resignFirstResponder()
		if sender.view == self.selectedCategoryAndSubcategoryOuterView {
			self.subCategoryView.isHidden = true
			self.horizontalDateAndTimePickerView.isHidden = true
			self.horizontalDateAndTimePickerView.alpha = 0
			self.attendeesSearchView.isHidden = true
			self.attendeesSearchView.alpha = 0
			self.selectedCategoryAndSubcategoryOuterView.isHidden = true
			self.selectedDateAndTimeOuterView.isHidden = true
			self.selectedLocationLabel.isHidden = true
			self.selectedAttendeesView.isHidden = true
			self.selectedDescriptionTextView.isHidden = true
			self.selectedDataStackView.isHidden = true
			self.selectedDataStackView.isHidden = true
			self.locationView.isHidden = true
			self.locationView.alpha = 0
			self.eventDescriptionview.isHidden = true
			self.confirmEventView.isHidden = true
			
			self.removeContactSelection()
			self.selectedDescriptionTextView.text = ""
			self.eventDescriptionTextView.text = ""
			self.selectedAttendees.removeAll()
			//self.freeTimeUsers.removeAll()
			self.selectedAttendeesCollectionview.reloadData()
			self.attendeesSearchTableView.reloadData()
			
			self.categoryView.isHidden = false
			self.mainView.bringSubviewToFront(self.categoryView)
			
		} else if sender.view == self.selectedDateAndTimeOuterView  {
			self.selectedCategoryAndSubcategoryOuterView.isHidden = true
			self.selectedDateAndTimeOuterView.isHidden = true
			self.selectedLocationLabel.isHidden = true
			self.selectedAttendeesView.isHidden = true
			self.selectedDescriptionTextView.isHidden = true
			self.selectedDataStackView.isHidden = true
			self.selectedDataStackView.isHidden = true
			self.locationView.isHidden = true
			self.locationView.alpha = 0
			self.eventDescriptionview.isHidden = true
			self.confirmEventView.isHidden = true
			self.subCategoryView.isHidden = true
			self.categoryView.isHidden = true
			
			self.selectedDescriptionTextView.text = ""
			self.eventDescriptionTextView.text = ""
			self.horizontalDateAndTimePickerView.isHidden = false
			self.horizontalDateAndTimePickerView.alpha = 1
			self.attendeesSearchView.isHidden = false
			self.attendeesSearchView.alpha = 1
			
			self.removeContactSelection()
			self.selectedAttendees.removeAll()
			//self.freeTimeUsers.removeAll()
			self.selectedAttendeesCollectionview.reloadData()
			self.attendeesSearchTableView.reloadData()
			self.removeAnimatedSearchView()
			self.removeAnimation()
			
			self.mainView.bringSubviewToFront(horizontalDateAndTimePickerView)
			
		} else if sender.view == self.selectedAttendeesView  {
			self.selectedCategoryAndSubcategoryOuterView.isHidden = true
			self.selectedDateAndTimeOuterView.isHidden = true
			self.selectedLocationLabel.isHidden = true
			self.selectedAttendeesView.isHidden = true
			self.selectedDescriptionTextView.isHidden = true
			self.selectedDataStackView.isHidden = true
			self.selectedDataStackView.isHidden = true
			self.locationView.isHidden = true
			self.locationView.alpha = 0
			self.eventDescriptionview.isHidden = true
			self.confirmEventView.isHidden = true
			self.subCategoryView.isHidden = true
			self.categoryView.isHidden = true
			
			self.attendeesSearchTextField.becomeFirstResponder()
			self.selectedDescriptionTextView.text = ""
			self.eventDescriptionTextView.text = ""
			self.horizontalDateAndTimePickerView.isHidden = false
			self.horizontalDateAndTimePickerView.alpha = 1
			self.attendeesSearchView.isHidden = false
			self.attendeesSearchView.alpha = 1
			self.removeAnimatedSearchView()
			self.removeAnimation()
			self.mainView.bringSubviewToFront(self.attendeesSearchView)
		} else if sender.view == selectedLocationLabel {
			self.eventDescriptionview.isHidden = true
			self.confirmEventView.isHidden = true
			self.subCategoryView.isHidden = true
			self.categoryView.isHidden = true
			self.horizontalDateAndTimePickerView.isHidden = true
			self.horizontalDateAndTimePickerView.alpha = 0
			self.attendeesSearchView.isHidden = true
			self.attendeesSearchView.alpha = 0
			//self.locationSearchTextField.text = selectedLocationLabel.text
			self.locationSearchTextField.becomeFirstResponder()
			self.selectedDescriptionTextView.text = ""
			self.eventDescriptionTextView.text = ""
			
			self.selectedCategoryAndSubcategoryOuterView.isHidden = false
			self.selectedDateAndTimeOuterView.isHidden = false
			self.selectedLocationLabel.isHidden = true
			self.selectedAttendeesView.isHidden = false
			self.selectedDescriptionTextView.isHidden = true
			self.selectedDataStackView.isHidden = false
			self.locationView.alpha = 1
			self.locationView.isHidden = false
			self.descriptionTextViewHeight.constant = 0
			self.mainView.bringSubviewToFront(locationView)
		}
	}
	func touchtoTextView() {
		let textViewRecognizer = UITapGestureRecognizer()
		textViewRecognizer.addTarget(self, action: #selector(tappedTextView(_:)))
		self.selectedDescriptionTextView.addGestureRecognizer(textViewRecognizer)
	}
	func textWidth(text: String, font: UIFont?) -> CGFloat {
		let attributes = font != nil ? [NSAttributedString.Key.font: font!] : [:]
		return text.size(withAttributes: attributes).width
	}
	func textHeight(text: String, font: UIFont?) -> CGFloat {
		let attributes = font != nil ? [NSAttributedString.Key.font: font!] : [:]
		return text.size(withAttributes: attributes).height
	}
	
	func removeContactSelection() {
		for i in 0..<self.getContacts().count {
			self.getContacts()[i].isSelected = false
		}
	}
	@objc func tappedTextView(_ sender: UITapGestureRecognizer) {
		self.categoryView.isHidden = true
		self.subCategoryView.isHidden = true
		self.horizontalDateAndTimePickerView.isHidden = true
		self.horizontalDateAndTimePickerView.alpha = 0
		self.attendeesSearchView.isHidden = true
		self.attendeesSearchView.alpha = 0
		self.locationView.isHidden = true
		self.locationView.alpha = 0
		self.confirmEventView.isHidden = true
		self.selectedCategoryAndSubcategoryOuterView.isHidden = false
		self.selectedDateAndTimeOuterView.isHidden = false
		self.selectedLocationLabel.isHidden = false
		self.selectedAttendeesView.isHidden = false
		self.selectedDescriptionTextView.isHidden = true
		
		self.selectedDataStackView.isHidden = false
		self.eventDescriptionview.isHidden = false
		self.eventDescriptionTextView.becomeFirstResponder()
		self.descriptionTextViewHeight.constant = 0
		self.mainView.bringSubviewToFront(eventDescriptionview)
	}
	
	func GooglePlacePicker(place_id: String, place_name: String) {
		placesClient.lookUpPlaceID(place_id, callback: { (place, error) -> Void in
			if error != nil {
				return
			}
			guard let place = place else {
				return
			}
			self.selectedLatitude = place.coordinate.latitude
			self.selectedLongitude = place.coordinate.longitude
			SosApi.geoPositionSearch(lat: String(self.selectedLatitude), lon: String(self.selectedLongitude), from : "addEvent")
				.onSuccess {(dict:[String: Any]) in
					self.weather = dict
				}.onFailure { error in
					
			}
		})
	}
	func setupLocationAlert() {
		let alert = UIAlertController(title: "Allow Location Access", message: "SoShall needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
		
		// Button to Open Settings
		alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
			guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
				return
			}
			if UIApplication.shared.canOpenURL(settingsUrl) {
				UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
					print("Settings opened: \(success)")
				})
			}
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	func checkServiceEnabledOrNot() {
		if CLLocationManager.locationServicesEnabled() {
			switch CLLocationManager.authorizationStatus() {
			case .notDetermined, .restricted, .denied:
				print("No access")
				self.setupLocationAlert()
				
			case .authorizedAlways, .authorizedWhenInUse:
				print("Access")
				
			@unknown default:
				break
			}
		} else {
			print("Location services are not enabled")
		}
	}
	// MARK:Next Button Action
	@IBAction func getNextFreeTimeAction(_ sender: Any) {
		self.getNextFreeTime()
	}
	// MARK:Find free Time
	func getNextFreeTime() {
			self.view.addSubview(progressIndicator)
			self.progressIndicator.startAnimating()
			self.view.bringSubviewToFront(progressIndicator)
			guard let nextPotentialDate = determineNextFreeTime(add:0)  else {
				Application.showAlert(onViewController: self, title: "Error", message: "Could not find any potential date", actionTitle: "OK", cancelButton: false, handler: nil)
				self.progressIndicator.removeFromSuperview()
				self.progressIndicator.stopAnimating()
				return
			}
			Application.shared.nextFreeDate = nextPotentialDate
			self.progressIndicator.removeFromSuperview()
			self.progressIndicator.stopAnimating()
			Application.shared.potentialDate = nextPotentialDate
		print(nextPotentialDate)
			self.endDate = Calendar.current.date(byAdding: .minute, value: duration, to: nextPotentialDate)!
			let endTime = Calendar.current.date(byAdding: .minute, value: duration, to: nextPotentialDate)!
			let eventInterval = DateInterval(start: nextPotentialDate, end: endTime)
			Application.shared.potentialInterval = eventInterval
			self.selectedDate = Application.shared.potentialDate
			if Application.shared.potentialDate.startOfDay == Date().startOfDay{
				setUpTimeArray()
			}
			if self.timeArray.contains(Application.shared.nextFreeDate!), let index = self.timeArray.firstIndex(of: Application.shared.nextFreeDate!) {
				let scrollIndex = index
				self.timePicker.selectRow(scrollIndex, inComponent: 0, animated: true)
			}
		
			if self.dateArray.contains(Application.shared.nextFreeDate!.startOfDay), let index = self.dateArray.firstIndex(of: Application.shared.nextFreeDate!.startOfDay) {
				let scrollIndex = index
				self.datePicker.selectRow(scrollIndex, inComponent: 0, animated: true)
			}
			self.autoFindNextAvailableDateButton.setImage(UIImage(named: "freetimegrey"), for: UIControl.State())
			self.autoFindNextAvailableDateButton.alpha = 0.5
			self.autoFindNextAvailableDateButton.isUserInteractionEnabled = false
			NotificationCenter.default.post(name: Notification.Name(SOS_FlutterPotentialDateUpdated), object: nil)
	}
	func determineNextFreeTime(add: Int) -> Date? {
		
		if let potentialDate = Application.shared.nextFreeDate {
			return potentialDate
		}
		else {
			var adder = add
			//Get all users schedules. TODO possible performance issues here if a lot of group users.
			var allUsersIntervals = [DateInterval]()
			let utcNow = Date().addingTimeInterval(TimeInterval(24 * 60 * 60 * add)).nearestFifteenthMinute()
			let seconds = TimeInterval(TimeZone.current.secondsFromGMT())
			let now = utcNow.addingTimeInterval(seconds)
			
			if self.freeTimeUsers.count > 0 {
				for user in self.freeTimeUsers {
					if let intervals = user.User?.getSchedule(forDay: now) {
						allUsersIntervals.append(contentsOf: intervals)
					}
				}
			}
			
			// Now merge the intervals down.
			let combinedIntervals = DateTools.combineIntervals(intervals: allUsersIntervals)
			if combinedIntervals.isEmpty && now.startOfDay == Date().startOfDay{//no busy schedule for today
				self.progressIndicator.removeFromSuperview()
				self.progressIndicator.stopAnimating()
				return Date().nearestFifteenthMinute()
			}
			let freeIntervals = self.getFreeIntervalsForDate(date: now, intervals: combinedIntervals, duration: TimeInterval(duration*60))
			if !freeIntervals.isEmpty {
				var nextDayIntervals = [DateInterval]()
				if self.freeTimeUsers.count > 0  {
					for user in self.freeTimeUsers {
						if let intervals = user.User?.getSchedule(forDay: now.addingTimeInterval(TimeInterval(24*60*60))) {
							nextDayIntervals.append(contentsOf: intervals)
						}
					}
				}
				let nextDayCombinedIntervals = DateTools.combineIntervals(intervals: nextDayIntervals)
				if !nextDayCombinedIntervals.isEmpty{//check with next day's busy schedules
					let nextDayFirstInterval = nextDayCombinedIntervals.first
					if let freeInterval = freeIntervals.filter({!$0.intersects(nextDayFirstInterval!)}).first{//compare with next day's first schedule
						return freeInterval.start
					}
					else {//no free time for today after comparing with next day's first schedule
						adder = adder + 1
						return determineNextFreeTime(add: adder)
					}
					
				}
				else {//no free time for the next day
					if now.startOfDay != Date().startOfDay{// check with previous day schedules for date other than today
						var previousDayIntervals = [DateInterval]()
						if self.freeTimeUsers.count > 0 {
							for user in self.freeTimeUsers {
								if let intervals = user.User?.getSchedule(forDay: now.addingTimeInterval(TimeInterval(-24*60*60))) {
									previousDayIntervals.append(contentsOf: intervals)
								}
							}
						}
						let previousDayCombinedIntervals = DateTools.combineIntervals(intervals: previousDayIntervals)
						var previousDayLastIntervalDuration = previousDayCombinedIntervals.last?.duration
						if previousDayLastIntervalDuration?.remainder(dividingBy: TimeInterval(900)) != 0{
							previousDayLastIntervalDuration = previousDayLastIntervalDuration! + 1
						}
						let previousDayLastInterval = DateInterval(start: (previousDayCombinedIntervals.last?.start)!, duration: previousDayLastIntervalDuration!)// due to duration mismatch, 1 second is added to the last interval
						if let freeInterval = freeIntervals.filter({!$0.intersects(previousDayLastInterval)}).first{//compare with previous day's last schedule(midnight)
							return freeInterval.start
						}
					}
					else {//for today
						if let freeInterval = freeIntervals.first {
							return freeInterval.start
						}
					}
				}
			}
			else {//no free time for today
				adder = adder + 1
				return determineNextFreeTime(add: adder)
			}
			return Date().nearestFifteenthMinute()
		}
	}
	
	func getFreeIntervalsForDate(date: Date, intervals:[DateInterval], duration:TimeInterval) -> [DateInterval] {
		var freeIntervals = [DateInterval]()
		if intervals.isEmpty && date.startOfDay != Date().startOfDay {//when there is no busy schedule for the next day, append intervals from 00:00 and 00:15
			freeIntervals.append(DateInterval(start: date.startOfDay,duration: duration))
			freeIntervals.append(DateInterval(start: date.startOfDay.nextFifteenthMinute(),duration: duration))
		}
		else {
			for interval in intervals {//check every busy schedule
				if interval == intervals.first{//midnight to first
					var startInterval = DateInterval(start: interval.start.startOfDay,duration: duration)
					while !startInterval.intersects(interval) {
						freeIntervals.append(startInterval)
						startInterval = DateInterval(start: startInterval.start.nextFifteenthMinute(),duration: duration)
					}
					//for one combined interval only
					if interval == intervals.last {//last to midnight
						var startInterval = DateInterval(start: interval.end.nearestFifteenthMinute(),duration: duration)
						while startInterval.start < interval.end.endOfDay! {
							freeIntervals.append(startInterval)
							startInterval = DateInterval(start: startInterval.start.nextFifteenthMinute(),duration: duration)
						}
					}
				}
				else {
					let previousIndex = intervals.firstIndex(of: interval)!-1
					var startInterval = DateInterval(start: intervals[previousIndex].end.nearestFifteenthMinute(),duration: duration)
					while !startInterval.intersects(interval) {
						freeIntervals.append(startInterval)
						startInterval = DateInterval(start: startInterval.start.nextFifteenthMinute(),duration: duration)
					}
					if interval == intervals.last {//last to midnight
						var startInterval = DateInterval(start: interval.end.nearestFifteenthMinute(),duration: duration)
						while startInterval.start < interval.end.endOfDay! {
							freeIntervals.append(startInterval)
							startInterval = DateInterval(start: startInterval.start.nextFifteenthMinute(),duration: duration)
						}
					}
				}
			}
		}
		return freeIntervals.filter({ $0.start > Date() }).sorted()
	}
	
	func checkUserFree() -> Bool {
		//		for user in freeTimeUsers {
		//			isfree =  ((user.User?.isFree(atDate: Application.shared.potentialDate))!)
		//			if isfree == false {
		//				break
		//			}
		//		}
		//			return isfree
		
		var isfree = Bool()
		for user in self.freeTimeUsers {
			if let singleUser = user.User {
			if let potentialInterval = Application.shared.potentialInterval {
				let intervals = DateTools.generateMergedIntervals(singleUser, date: (potentialInterval.start))
				if intervals.isEmpty {
					 isfree = true
				}
				else {
					let intervalArray = intervals.filter({$0.intersects(potentialInterval) == true})
					if intervalArray.count > 0 {
						isfree = false
					break
					}else {
						isfree = true
					}
				}
			}
		}
		}
		return isfree
	}
	func loadUsers() {
		freeTimeUsers.forEach {
			$0.delegate = self
			$0.loadUser()
		}
	}
	
	
	func updateUserFreeUI() {
		self.endDate = Calendar.current.date(byAdding: .hour, value: 2, to: Application.shared.potentialDate)!
		let eventInterval =  DateInterval(start: (Application.shared.potentialDate.toLocalTime()), end: self.endDate!.toLocalTime())
		Application.shared.potentialInterval = eventInterval
		let isFree = self.checkUserFree()
		if isFree {
			self.autoFindNextAvailableDateButton.setImage(UIImage(named: "freetimegrey"), for: UIControl.State())
			self.autoFindNextAvailableDateButton.alpha = 0.5
			self.autoFindNextAvailableDateButton.isUserInteractionEnabled = false
		}else {
			self.autoFindNextAvailableDateButton.setImage(UIImage(named: "freetimered"), for: UIControl.State())
			self.autoFindNextAvailableDateButton.alpha = 1.0
			self.autoFindNextAvailableDateButton.isUserInteractionEnabled = true
		}
	}
	
	
	@IBAction func nextButtonAction(_ sender: Any) {
		self.setupPreviousDatas()
		self.removeAnimatedSearchView()
		self.removeAnimation()
		self.selecteAttendeesListingCollectionView.reloadData()
	}
	@IBAction func previousButtonAction(_ sender: Any) {
		self.loadUsers()
		self.removeAnimatedSearchView()
		self.removeAnimation()
	}
	
	@IBAction func confirmEventClicked(_ sender: Any) {
		self.createEvent()
	}
	// MARK:Fetch Data
	@objc func autoCompleteApi(_ timer: Timer){
		var currentLocation: CLLocation!
		if let text = timer.userInfo as? String {
			if text == "" {
				self.placeDict = [[:]]
				self.locationSearchTableView.reloadData()
//				UIView.animate(withDuration: 0.5) {
//					//self.removeLocationShowingView()
//				}
				//self.locationSearchTableView.isHidden = true
			} else {
				if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
					CLLocationManager.authorizationStatus() ==  .authorizedAlways){
					currentLocation = locationManager?.location
					
					SosApi.LocationAutoComplete(place: text, latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude ) {(dict:[String: Any]) in
						if let predictions = dict["predictions"] as? [[String: AnyObject]] {
							self.placeDict = predictions
							DispatchQueue.main.async {
								self.locationSearchTableView.reloadData()
							}
						}
					}
				}
				
			}
		}
	}
	
	func createEvent() {
		self.view.addSubview(progressIndicator)
		progressIndicator.startAnimating()
		self.eventEndDate = Calendar.current.date(byAdding: .hour, value: 2, to: Application.shared.potentialDate)!
		let starts = Application.shared.potentialDate
		let ends = self.eventEndDate
		if let title = self.eventNameLabel.text {
			//self.view.addSubview(progressIndicator)
			//progressIndicator.startAnimating()
			//self.view.isUserInteractionEnabled = false
			if weather.count == 0 {
				self.weather = ["temperature": "",
								"condition": ""]
			}
			EventApi.addEventToEventDocument(name: title, location: selectedLocationLabel.text!, latitude: self.selectedLatitude, longitude: self.selectedLongitude, starts: starts, ends: ends, people: self.selectedAttendees, admin: (Application.shared.appUser?.key)!, category : selectedCategoryLabel.text!, subCategory: "", isPublic: true, weather: weather, details: selectedDescriptionTextView.text).onComplete { result in
				if result.value != nil {
					self.progressIndicator.removeFromSuperview()
					self.progressIndicator.stopAnimating()
					let alertView = UIAlertController(title: "Success", message: "Event created", preferredStyle: .alert)
					alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
						Application.shared.nextFreeDate = nil
						self.tabBarController?.selectedIndex = 0
					}))
					self.present(alertView, animated: true, completion: nil)
				}
			}
		}
	}
	
}

extension AddEventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	// MARK:CollectionView Methods
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == selectedAttendeesCollectionview ||  collectionView == selecteAttendeesListingCollectionView  {
			return self.selectedAttendees.count
		} else {
			return categoriesArray.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == selectedAttendeesCollectionview  ||  collectionView == selecteAttendeesListingCollectionView  {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedAttendeesCell", for: indexPath as IndexPath) as! SelectedAttendeesCollectionViewCell
			cell.layer.cornerRadius = cell.frame.size.width / 2
			cell.clipsToBounds = true
			cell.layer.borderWidth = 2
			if collectionView == selectedAttendeesCollectionview {
				cell.layer.borderColor = UIColor.black.cgColor
				cell.selectedAttendeesLabel.textColor = UIColor.black
			} else {
				cell.layer.borderColor = UIColor.SOS_CommonRedColor.cgColor
				cell.selectedAttendeesLabel.textColor = UIColor.SOS_AttendeesRedBorder
			}
			cell.attendee = selectedAttendees[indexPath.item]
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath as IndexPath) as! CategoryCollectionViewCell
			cell.categoryName = categoriesArray[indexPath.row]
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if collectionView == selectedAttendeesCollectionview ||  collectionView == selecteAttendeesListingCollectionView  {
			if collectionView == selectedAttendeesCollectionview {
				return CGSize(width: 60 , height: 60)
			} else {
				return CGSize(width: 45 , height: 45)
			}
		} else {
			let width = self.textWidth(text: categoriesArray[indexPath.row], font: Application.shared.proximaFontRegular20) + 20
			return CGSize(width: width , height: 40)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == selectedAttendeesCollectionview {
			if !usersArray.contains(selectedAttendees[indexPath.row]) {
				usersArray.append(selectedAttendees[indexPath.row])
			}
		} else {
			self.categoryView.isHidden = true
			self.subCategoryView.isHidden = true
			self.selectedCategoryAndSubcategoryOuterView.isHidden = true
			self.selectedDateAndTimeOuterView.isHidden = true
			self.selectedLocationLabel.isHidden = true
			self.selectedAttendeesView.isHidden = true
			self.selectedDescriptionTextView.isHidden = true
			self.selectedDataStackView.isHidden = true
			
			self.locationView.isHidden = true
			self.locationView.alpha = 0
			self.eventDescriptionview.isHidden = true
			self.confirmEventView.isHidden = true
			
			self.horizontalDateAndTimePickerView.isHidden = false
			self.horizontalDateAndTimePickerView.alpha = 1
			attendeesSearchView.isHidden = false
			attendeesSearchView.alpha = 1
			
			removeAnimatedSearchView()
			removeAnimation()
			
			let width = textWidth(text: categoriesArray[indexPath.row], font: Application.shared.proximaFontMedium23) + 20
			categoryAndSubCategoryWidth.constant = width
			
			self.categoryAndSubCategoryNameLabel.text = categoriesArray[indexPath.row]
			self.selectedCategory = categoriesArray[indexPath.row]
			self.horizontalDateAndTimePickerView.easeOutAnimation()
			
			setUpDatePicker()
			setUpTimePicker()
		}
	}
}

// MARK:TableView Methods
extension AddEventViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == attendeesSearchTableView {
			return self.getContacts().count
		} else {
			return placeDict.count
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 45
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if tableView == attendeesSearchTableView {
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttendeesSearchTableViewCell
			cell.attendees = self.getContacts()[indexPath.row]
			if self.getContacts()[indexPath.row].isSelected == false {
				cell.attendeesLabel.textColor = UIColor.gray
			} else {
				cell.attendeesLabel.textColor = UIColor.red
			}
			cell.selectionStyle = .none
			return cell
		} else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! MapSearchTableViewCell
			if let placeName = placeDict[indexPath.row]["description"]{
				cell.title.text = placeName as? String
			}
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView == attendeesSearchTableView {
			if 	self.getContacts()[indexPath.row].isSelected == false {
				self.getContacts()[indexPath.row].isSelected = true
				self.selectedAttendees.append(self.getContacts()[indexPath.row])
			
				let attendee = SoSEventUser(self.getContacts()[indexPath.row].userID, self.getContacts()[indexPath.row].name)
				self.freeTimeUsers.append(attendee)
			} else {
				self.getContacts()[indexPath.row].isSelected = false
				if self.selectedAttendees.contains(self.getContacts()[indexPath.row]) {
					let index = selectedAttendees.firstIndex(of: self.getContacts()[indexPath.row])
					self.selectedAttendees.remove(at: index!)
				}
				let attendee = SoSEventUser(self.getContacts()[indexPath.row].userID, self.getContacts()[indexPath.row].name)
				if freeTimeUsers.contains(attendee) {
					let index = freeTimeUsers.firstIndex(of: attendee)
					self.freeTimeUsers.remove(at: index!
					
					)
					self.updateUserFreeUI()
				}
				
			
			}
			self.attendeesSearchTableView.reloadData()
			selectedAttendeesCollectionview.isHidden = false
			selectedAttendeesCollectionview.reloadData()
			if selectedAttendees.count > 0 {
				self.nextButton.isHidden = true
					self.previousButton.isHidden = false
			} else {
				self.nextButton.isHidden = true
					self.previousButton.isHidden = true
			}
		} else {
			self.locationSearchTextField.resignFirstResponder()
			if let place_desc = placeDict[indexPath.row]["description"]{
				if let place_id = placeDict[indexPath.row]["place_id"]{
					GooglePlacePicker(place_id: place_id as! String, place_name: place_desc as! String)
					self.removeLocationShowingView()
					self.selectedDataStackView.arrangedSubviews[2].isHidden = false
					if let placeDescription = place_desc as? String {
						let height = selectedLocationLabel.heightForLabel(text: placeDescription, font: Application.shared.proximaFontMedium15, width: mainView.frame.size.width - 60) + 10
						if height < 37.0 {
							self.selectedLocationHeight.constant = 37
						} else {
							self.selectedLocationHeight.constant = height
						}
						self.selectedLocationLabel.text = placeDescription
					}
					self.selectedLocationLabel.textInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
					self.selectedCategoryAndSubcategoryOuterView.isHidden = false
					self.selectedDateAndTimeOuterView.isHidden = false
					self.selectedLocationLabel.isHidden = false
					self.selectedAttendeesView.isHidden = false
					self.selectedDescriptionTextView.isHidden = true
					self.selectedDataStackView.isHidden = false
					self.selectedLocationLabel.numberOfLines = 0
					self.selectedLocationLabel.lineBreakMode = .byWordWrapping
					self.selectedLocationLabel.font = Application.shared.proximaFontMedium15
					self.locationView.isHidden = true
					self.eventDescriptionTextView.text = ""
					self.eventDescriptionview.isHidden = false
				}
			}
		}
	}
}

// MARK:PickerView Methods
extension AddEventViewController: UIPickerViewDelegate, UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if pickerView == datePicker {
			return self.dateArray.count
		}else {
			return self.timeArray.count
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		let label = UILabel()
		label.font = Application.shared.proximaFontMedium20
		label.minimumScaleFactor = 0.5
		label.textAlignment = .center
		label.textColor = UIColor.SOS_CommonGrayColor
		label.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180 ))
		if pickerView == datePicker {
			let date =  self.dateArray[row]
			label.text = date.string("d")
		} else {
			let date = self.timeArray[row]
			let dateString = date.string("HH:mm")
			label.text = dateString
		}
		//selectedTime = self.timeArray[0]
		
		if let selectedLabel = pickerView.view(forRow: pickerView.selectedRow(inComponent: component), forComponent: component) as? UILabel {
			selectedLabel.font = Application.shared.proximaFontMedium23
			selectedLabel.textColor = UIColor.SOS_CommonRedColor
		}
		return label
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		if pickerView == datePicker {
			return 55
		}else {
			return 80.0
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		guard let label = pickerView.view(forRow: row, forComponent: component) as? UILabel else {
			return
		}
		label.font = Application.shared.proximaFontMedium23
		label.textColor = UIColor.SOS_CommonRedColor
		
		if pickerView == datePicker {
			self.selectedDate =  dateArray[row]
			let nameOfMonth = selectedDate.monthString()
			self.monthLabel.text = nameOfMonth
			setUpTimeArray()
			if self.selectedDate.startOfDay  == Date().startOfDay {
				selectedTime = self.timeArray[0]
			} else {
				selectedTime = self.timeArray[48]
			}
		} else {
			selectedTime = timeArray[row]
		}
		
		print("Time###", selectedTime)
		Application.shared.potentialDate = self.selectedDate.startOfDay.addingTimeInterval(TimeInterval(self.selectedTime.secondsSinceStartOfDay))
		if freeTimeUsers.count > 0 {
		self.updateUserFreeUI()
		}
		//Calendar.current.date(byAdding: .second, value: self.selectedTime.secondsSinceStartOfDay, to: self.selectedDate.startOfDay)!
	}
}

extension AddEventViewController: UITextFieldDelegate {
	func animateTextField(textField: UITextField, up: Bool) {
		let movementDistance = 20
		let movementDuration = 0.5
		let movement = (up) ? -movementDistance : movementDistance
		UIView.beginAnimations("anim", context: nil)
		UIView.setAnimationBeginsFromCurrentState(true)
		UIView.setAnimationDuration(movementDuration)
		if textField == attendeesSearchTextField {
			self.attendeesSearchView.frame = self.attendeesSearchView.frame.offsetBy(dx: 0, dy: CGFloat(movement))
			attendeesSearchViewAnimated = true
			if selectedAttendees.count > 0 {
				self.previousButton.isHidden = false
				self.nextButton.isHidden = true
			} else {
				self.previousButton.isHidden = true
				self.nextButton.isHidden = true
			}
		}
		UIView.commitAnimations()
	}
}
extension AddEventViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			if !locationSearchTextField.text!.isEmpty {
				searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(autoCompleteApi(_:)), userInfo: locationSearchTextField.text!, repeats: false)
			} else {
				self.placeDict.removeAll()
				self.locationSearchTableView.reloadData()
			}
			//self.autoCompleteApi(text: locationSearchTextField.text!)
		}
		
	}
}
extension AddEventViewController: SoSEventUserDelegate {
	func userLoaded(_ user: SOSUser) {
		if user == self.freeTimeUsers.last?.User {
			self.updateUserFreeUI()
		}
	}
}
