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
    var data:BMI? = nil
    
    // min and max height of people from
    // http://www.cnn.com/2014/11/13/living/tallest-shortest-man-guinness/
    // Tallest man is 8 foot 3 inches,
    // Shortest is 21 1.2 inches.
    let maxHeightInches: Float = (8 * 12) + 3 + 3 // add three just in case
    let minHeightInches: Float = 21.5 - 3 // subtract 3 just in case

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // positioning the rotated slider is difficult
//        print("Before Transform:")
//        print("slider bounds: \(heightSlider.layer.bounds)")
//        print("slider frame: \(heightSlider.layer.frame)")
//        print("parent view bounds: \(parentView.layer.bounds)")
//        print("parent view frame: \(parentView.layer.frame)")
        // adjusting the pivot point works...
        // let point = CGPoint(x: 0.6, y: -4)
        // heightSlider.layer.anchorPoint = point
        // ...but may not work with variable screen sizes
        heightSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
//        print("After Rotate Transform:")
//        print("slider bounds: \(heightSlider.layer.bounds)")
//        print("slider frame: \(heightSlider.layer.frame)")
//        print("parent view bounds: \(parentView.layer.bounds)")
//        print("parent view frame: \(parentView.layer.frame)")
//        print("parent view width: \(parentView.layer.frame.width)")
//        print("parent view height: \(parentView.layer.frame.height)")
        // Rotating the control, then moving its rect relative to
        //   current screen dimensions.
        // This is a stupid way to move the control, but it seems to work
        //   for multiple screen sizes.
        // Use parent width - 30, parent height - 300 for lower-right corner position
        // TODO: get actual control width and height, instead of 20, 300 (a guess)
        let sliderRect:CGRect = CGRect(x: (parentView.layer.frame.width - 30), y: (parentView.layer.frame.height - 410) , width: 20, height: 350)
        heightSlider.frame = sliderRect
//        print("After Moving Frame:")
//        print("slider bounds: \(heightSlider.layer.bounds)")
//        print("slider frame: \(heightSlider.layer.frame)")
        
        load()
        if (data != nil){
            if ((data?.height) != nil) {
                // get the units
                let units = data?.units
                
                setSliderMinMax(slider: heightSlider, units: units!)
                
                // figure out where the slider should be
                
                // set the slider to where it should be
            }
            if ((data?.weight) != nil) {
                // get the units
                
                // figure out what weight should be
                
                // set the text field to what it should be
            }
        } else {
            // no values set, so set some defaults
            // self.data!.bmi = Unit.metric
            self.data = BMI(40, 100)
        }
        setSliderMinMax(slider: heightSlider, units: (data?.units)!)
        heightSlider.setValue((self.data?.height)!, animated: false)
        weightTextField.text = String(Int((self.data?.weight)!))

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

    func setHeight(sender: UISlider ) {
        let heightValue = Int(sender.value)
        print("slider value changed to \(heightValue)")
        self.data?.height = Float(heightValue)
        heightLabel.text = String(heightValue)
        
        bmiLabel.text = String((self.data?.bmi)!)

    }
    
    func setWeight(sender: UITextField ) {
        let weightValue = Float(sender.text!)
        print("text value changed to \(weightValue)")
        self.data?.weight = Float(weightValue!)
        
        bmiLabel.text = String((self.data?.bmi)!)
        
    }
    
    func toggleUnits( _ sender: UISwitch) {
        if (sender.isOn) {
            print("metric ON")
            self.data?.units = Unit.metric
            print(self.data?.height! ?? "no height")
            print(self.data?.weight! ?? "no weight")
        } else {
            print("metric OFF (imperial)")
            self.data?.units = Unit.imperial
            print(self.data?.height! ?? "no height")
            print(self.data?.weight! ?? "no weight")
        }
        let currentUnits: Unit = (self.data?.units)!
        setSliderMinMax(slider: heightSlider, units: currentUnits)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == weightTextField ) {
            let weightValue = Float(textField.text!)
            print("text value changed to \(weightValue)")
            self.data?.weight = Float(weightValue!)
            
            bmiLabel.text = String((self.data?.bmi)!)

        }
    }
    
    func editingWeight(sender: UITextField) {
        print("currently editing")
    }
    
    func calculateBMI() {
        print("clicked calculate button")
    }
    
    func setSliderMinMax( slider: UISlider, units: Unit) {
        // Set the minimum and maximum allowable values for 
        // the height slider. Adjust for metric or imperial units.
        //
        // The min and max values of the slider are based on
        // the shortest and tallest man in the world, according to google,
        // plus or minus a little bit. BMI is probably not even accurate for
        // people out at the edges of the height bell curve.
        let minLabel: Float = round(Float(convertHeight(fromUnits: Unit.imperial, value: minHeightInches, toUnit: units)))
        
        let maxLabel: Float = round(Float(convertHeight(fromUnits: Unit.imperial, value: maxHeightInches, toUnit: units)))
        
        let unitText: String
        if (self.data?.units == Unit.metric) {
            unitText = " cm"
        } else {
            unitText = " inches"
        }
        minSliderLabel.text = String(Int(minLabel)) + unitText
        maxSliderLabel.text = String(Int(maxLabel)) + unitText
        
        heightSlider.minimumValue = minLabel
        heightSlider.maximumValue = maxLabel
        
        bmiLabel.text = String((self.data?.bmi)!)
        
    }
    
    func convertHeight(fromUnits: Unit, value: Float, toUnit: Unit) -> Float {
        //: TODO: I have more than one metric to imperial conversion functions
        //        Try to unify into one function
        if fromUnits == toUnit {
            return value
        }
        switch fromUnits {
            // the incoming units
        case Unit.metric:
            // convert TO imperial
            return value * 0.393701
        case Unit.imperial:
            // convert TO metric
            return value * 2.5400013716
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

