//
//  ViewController.swift
//  BMI Backpack
//
//  Created by Daniel Henderson on 2/18/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var weightTextField: UITextField!
    @IBAction func calcBmi(_ sender: UIButton) {
        calculateBMI()
    }
    @IBAction func unitsToggle(_ sender: UISwitch) {
        toggleUnits(sender)
    }
    @IBAction func weightEditing(_ sender: UITextField) {
        editingWeight(sender: sender)
    }
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBAction func heightValue(_ sender: UISlider) {
        setHeight(sender: sender)
    }
    @IBOutlet weak var imageView: UIImageView!
//    @IBAction func weightValue(_ sender: UITextField) {
//        setWeight(sender: sender)
//    }
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var maxSliderLabel: UILabel!
    @IBOutlet weak var minSliderLabel: UILabel!
    var data:BMI = BMI(40, 100)
    
    private var currentTextField: UITextField?
    
    // min and max height of people from
    // http://www.cnn.com/2014/11/13/living/tallest-shortest-man-guinness/
    // Tallest man is 8 foot 3 inches,
    // Shortest is 21 1.2 inches.
    let maxHeightCm: Float = convert(value: (8 * 12) + 3 + 3, from: .inch, to: .centimeter)! // add three just in case
    let minHeightCm: Float = convert(value: 21.5 - 3, from: .inch, to: .centimeter)! // subtract 3 just in case

    override func viewDidLoad() {
        super.viewDidLoad()
        weightTextField.delegate = self

        heightSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))

        let sliderRect:CGRect = CGRect(x: (parentView.layer.frame.width - 30), y: (parentView.layer.frame.height - 410) , width: 20, height: 350)
        heightSlider.frame = sliderRect
        
//        load()
        print("current bmi object has \(data.height) height and \(data.weight) weight")
        setSliderMinMax(slider: heightSlider, units: (data.measureSystem))
        heightSlider.setValue((data.height), animated: false)
        weightTextField.text = String(data.weight)
        
        
        
        
        // initialize image view
        imageView.image = UIImage(named: "bmi_30")

    }

    func save() {
        UserDefaults.standard.set(data, forKey: "bmi")
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        if let loadedData = UserDefaults.standard.value(forKey: "bmi") as? BMI {
            data = loadedData
            // table.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func setHeight(sender: UISlider ) {
        let heightValue = Int(sender.value)
        print("slider value changed to \(heightValue)")
        self.data.height = Float(heightValue)
        heightLabel.text = String(heightValue)
        
        bmiLabel.text = String((self.data.bmi))
        calculateBMI()
    }
    
    func setWeight(sender: UITextField ) {
        let weightValue = Float(sender.text!)
        print("text value changed to \(weightValue)")
        self.data.weight = Float(weightValue!)
        
        bmiLabel.text = String((self.data.bmi))
        calculateBMI()
    }
    
    func toggleUnits( _ sender: UISwitch) {
        if (sender.isOn) {
            print("metric ON")
            self.data.measureSystem = .metric
        } else {
            print("metric OFF (imperial)")
            self.data.measureSystem = .imperial
        }
        let currentUnits: MeasurementSystem = (self.data.measureSystem)
        setSliderMinMax(slider: heightSlider, units: currentUnits)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func editingWeight(sender: UITextField) {
        print("currently editing")
    }
    
    func calculateBMI() {
        print("clicked calculate button")
        //: TODO fix the text field issue
        currentTextField?.resignFirstResponder()
        print(data.height)
        print(data.weight)
        let currentBMI:Double = Double((self.data.bmi))
        switch currentBMI {
        case 0.0..<16.0:
            imageView.image = UIImage(named: "bmi_L18_5")
        case 16.0..<17.0:
            imageView.image = UIImage(named: "bmi_L18_5")
        case 17.0..<18.5:
            imageView.image = UIImage(named: "bmi_L18_5")
        case 18.5..<25.0:
            imageView.image = UIImage(named: "bmi_18_5-25")
        case 25.0..<30.0:
            imageView.image = UIImage(named: "bmi_25-30")
        case 30.0..<35.0:
            imageView.image = UIImage(named: "bmi_30")
        default:
            imageView.image = UIImage(named: "bmi_40")
        }
        
    }
    
    func setSliderMinMax( slider: UISlider, units: MeasurementSystem) {
        // Set the minimum and maximum allowable values for 
        // the height slider. Adjust for metric or imperial units.
        //
        // The min and max values of the slider are based on
        // the shortest and tallest man in the world, according to google,
        // plus or minus a little bit. BMI is probably not even accurate for
        // people out at the edges of the height bell curve.
        let newUnits:BmiUnit = ( units == .metric ? .centimeter : .inch)
        let oldUnits:BmiUnit = ( units == .metric ? .inch : .centimeter)
        print("Toggle is changing slider labels from \(oldUnits) to \(newUnits)")
        
        let minLabel: Float = round(Float(convert(value: minHeightCm, from: oldUnits, to: newUnits)!))

        let maxLabel: Float = round(Float(convert(value: maxHeightCm, from: oldUnits, to: newUnits)!))
        
        
        let unitText: String
        if (self.data.measureSystem == MeasurementSystem.metric) {
            unitText = " cm"
        } else {
            unitText = " in."
        }
        minSliderLabel.text = String(Int(minLabel)) + unitText
        maxSliderLabel.text = String(Int(maxLabel)) + unitText
        
        heightSlider.minimumValue = minLabel
        heightSlider.maximumValue = maxLabel
        
        bmiLabel.text = String((data.bmi))
//        data.weight = Float(weightTextField.text!)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

