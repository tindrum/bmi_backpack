//
//  BMI_calculator.swift
//  BMI Backpack
//
//  Created by Daniel Henderson on 2/18/17.
//  Copyright © 2017 Daniel Henderson. All rights reserved.
//
//  Model for BMI Backpack app. 
//  
//  Units are set to metric initially.
//  When weight and height are nil, BMI is not calculated.
//  When weight and height have values, BMI is calculated.
//  When units changes, weight and height values are re-calculated
//    to equivalent values.
//  
//  When object is init'ed, look for values from UserDefaults
//    to populate initial values.
//  Idea from Course: Building a Note-Taking App for iOS 10 with Swift
//    by Todd Perkins, from Lynda.com

//  BMI images based on artwork at 
//  http://www.pre-diabetes.com/info/medical-encyclopedia/body-mass-about.html
//  http://www.pre-diabetes.com/wp-content/uploads/2011/07/BMI-Chart.jpg

import Foundation

/**
  *MeasurementSystems of measure*
  - Important: metric and imperial 
     are the two MeasurementSystems supported.
 
  - Author: Daniel Henderson
 
*/

enum MeasurementSystem {
    case metric, imperial
}

enum Units {
    case kilo, pound, meter, foot, inch, centimeter
}

enum BMICategory {
    case severeThinness, moderateThinness, mildThinness
}

/**
 *BMI struct*
 - Important: Simple struct to hold height, weight, 
   MeasurementSystems (metric or imperial) and a calculated
   value for bmi score.
 
   If imperial MeasurementSystems are used, 
   weight is in pounds and height is in inches.
   If metric MeasurementSystems are used, 
   weight is in kilograms and height is in centimeters.
   When MeasurementSystems is changed, struct re-computes
   these values and saves them to the struct.
 
 - Author: Daniel Henderson

 - Parameters: 
   weight: the person's weight (without MeasurementSystems)
   height: the person's height (without MeasurementSystems)
   MeasurementSystems: MeasurementSystem of measure (metric or imperial)
 
 */

struct BMI {
    var weight:Float? = nil
    var height:Float? = nil
    var _measure:MeasurementSystem = .metric
    
    init(_ weight: Float, _ height: Float) {
        self.weight = weight
        self.height = height
    }
    
    var measureSystem: MeasurementSystem {
        set {
            if ( newValue == _measure ) {
                // do nothing, no change
            } else {
                if ( newValue == MeasurementSystem.metric ) {
                    // convert w & h imperial -> metric
                    self.weight = self.weight! * 0.453592
                    self.height = self.height! * 2.5400013716
                } else {
                    // convert w & h metric -> imperial
                    self.weight = self.weight! * 2.20462
                    self.height = self.height! * 0.393701
                }
            }
            _measure = newValue
        }
        get { return _measure }
    }

    
    
    // read-only computed property
    var bmi:Float {
        
            return toKG(weight) / ( toM(height) * toM(height))
    }
    
    func convert(value: Float, from: MeasurementSystem, to: MeasurementSystem) -> Float {
        return 0.0
    }
    
    func toKG(_ w : Float?) -> Float {
        if measureSystem == .metric {
            return weight!
        } else {
            return weight! * 0.453592
        }
    }
    
    func toM( _ h: Float?) -> Float {
        if measureSystem == .metric {
            return height! / 100
        } else {
            return height! * 0.0254
        }
    }
    
    
}
