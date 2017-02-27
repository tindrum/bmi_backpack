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
  *Units of measure*
  - Important: metric and imperial 
     are the two units supported.
 
  - Author: Daniel Henderson
 
*/

enum Unit {
    case metric, imperial
}

enum BMICategory {
    case severeThinness, moderateThinness, mildThinness
}

/**
 *BMI struct*
 - Important: Simple struct to hold height, weight, 
   units (metric or imperial) and a calculated
   value for bmi score.
 
   If imperial units are used, 
   weight is in pounds and height is in inches.
   If metric units are used, 
   weight is in kilograms and height is in centimeters.
   When units is changed, struct re-computes
   these values and saves them to the struct.
 
 - Author: Daniel Henderson

 - Parameters: 
   weight: the person's weight (without units)
   height: the person's height (without units)
   units: unit of measure (metric or imperial)
 
 */

struct BMI {
    var weight:Float? = nil
    var height:Float? = nil
    var _units:Unit = .metric
    
    init(_ weight: Float, _ height: Float) {
        self.weight = weight
        self.height = height
    }
    
    var units: Unit {
        set {
            if ( newValue == _units ) {
                // do nothing, no change
            } else {
                if ( newValue == Unit.metric ) {
                    // convert w & h imperial -> metric
                    self.weight = self.weight! * 0.453592
                    self.height = self.height! * 2.5400013716
                } else {
                    // convert w & h metric -> imperial
                    self.weight = self.weight! * 2.20462
                    self.height = self.height! * 0.393701
                }
            }
            _units = newValue
        }
        get { return _units }
    }

    
    
    // read-only computed property
    var bmi:Float {
            return toKG(weight) / ( toM(height) * toM(height))
    }
    
    func toKG(_ w : Float?) -> Float {
        if units == .metric {
            return weight!
        } else {
            return weight! * 0.453592
        }
    }
    
    func toM( _ h: Float?) -> Float {
        if units == .metric {
            return height! / 100
        } else {
            return height! * 0.0254
        }
    }
    
    
}
