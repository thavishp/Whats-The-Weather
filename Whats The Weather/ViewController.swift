//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Thavish on 2016-02-21.
//  Copyright © 2016 Thavish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    func runTask(url: NSURL) {
        
        var wasSuccessful = false
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data{
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                if websiteArray.count > 1 {
                    
                    let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                    
                    if weatherArray.count > 1 {
                        
                        wasSuccessful = true
                        
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.resultLabel.text = weatherSummary
                        })
                        
                        
                    }
                    
                }
                
                if wasSuccessful == false {
                    self.resultLabel.textColor = UIColor.redColor()
                    self.resultLabel.text = "Couldn't find the weather for that city - please try again"
                }
                
                
                
            }
            
        } //End of task

        task.resume()
        
    } //End of func
    
    @IBAction func findWeather(sender: AnyObject) {
        
        resultLabel.textColor = UIColor.whiteColor()
        resultLabel.text = "Checking..."
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if cityTextField.text != "" {
            
        
            if let url = attemptedUrl {
                
                runTask(url)
                
            } else {
                resultLabel.textColor = UIColor.redColor()
                resultLabel.text = "Couldn't find the weather for that city - please try again"
            }
        } else {
            resultLabel.textColor = UIColor.redColor()
            resultLabel.text = "Please enter a city"
        }
    } // End of Action
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }



}

