//
//  SliderTestViewController.swift
//  MyVideoApp
//
//  Created by Firoze Moosakutty on 16/07/18.
//  Copyright © 2018 Gizmeon. All rights reserved.
//

import UIKit

class SliderTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        // Add a gesture recognizer to the slider
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action:  #selector(self.sliderTapped(gestureRecognizer: )))
        tapGestureRecognizer.minimumPressDuration = 0
        self.testSlider.addGestureRecognizer(tapGestureRecognizer)
//        self.testSlider.addTarget(self, action: #selector(touchEnded), for: .touchUpInside.touchUpOutside)
//        self.testSlider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)
        self.hideSliderImage()
        // Do any additional setup after loading the view.
    }
    var touchEnabled = false
    @IBOutlet weak var testSlider: UISlider! {
        didSet {
            testSlider.minimumValue = 0
            testSlider.maximumValue = 500
            testSlider.setMinimumTrackImage(UIImage(named: "blu"), for: .normal)
            testSlider.setMaximumTrackImage(UIImage(named: "red"), for: .normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sliderAction(_ sender: UISlider, forEvent event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("touches began")
                sliderTouchBegan()
            case .moved:
                print("Moved")
            case .ended:
                print("touches ended")
                sliderTouchEnded()
            default:
                sliderValueUpdated(sender.value)
            }
        }
    }
    func sliderTouchBegan() {
        self.testSlider.setThumbImage(UIImage(named: "Group 2865"), for: .normal)
        testSlider.setMinimumTrackImage(UIImage(named: "green"), for: .normal)

//        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
//
//        let positionOfSlider: CGPoint = testSlider.frame.origin
//        let widthOfSlider: CGFloat = testSlider.frame.size.width
//        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(testSlider.maximumValue) / widthOfSlider)
    }
    func sliderTouchEnded() {
        self.hideSliderImage()

    }
    func sliderValueUpdated(_ value: Float) {
        print(value)
    }
    func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        print("A")
        if (gestureRecognizer.state == .began) {
            self.testSlider.setThumbImage(UIImage(named: "Group 2865"), for: .normal)
            testSlider.setMinimumTrackImage(UIImage(named: "green"), for: .normal)

            touchEnabled = true
        } else if gestureRecognizer.state == .ended {
            touchEnabled = false
            self.hideSliderImage()

        }
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        let positionOfSlider: CGPoint = testSlider.frame.origin
        let widthOfSlider: CGFloat = testSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(testSlider.maximumValue) / widthOfSlider)
        testSlider.setValue(Float(newValue), animated: true)
    }
    
    func timerAction(){
        let Range =  testSlider.maximumValue - testSlider.minimumValue;
        let Increment = Range/100;
        let newval = testSlider.value + Increment;
        if(Increment <= testSlider.maximumValue) {
            testSlider.setValue(newval, animated: true)
            print("The value of the testSlider is now \(testSlider.value)")
//            let sliderValue = Int(testSlider.value)
            
        } else if (Increment >= testSlider.minimumValue) {
            testSlider.setValue(newval, animated: true)
        }
    }
    func hideSliderImage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            if !self.touchEnabled {
            self.testSlider.setThumbImage(UIImage(), for: .normal)
            }
        })
    }

}
