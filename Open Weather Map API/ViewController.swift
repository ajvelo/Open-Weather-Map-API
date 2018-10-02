//
//  ViewController.swift
//  Open Weather Map API
//
//  Created by Andreas Velounias on 02/10/2018.
//  Copyright © 2018 Andreas Velounias. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImgView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let gradientLayer: CAGradientLayer = {
        let caGradient = CAGradientLayer()
        caGradient.frame = UIScreen.main.bounds
        caGradient.colors = [UIColor.cyan.cgColor, UIColor.blue.cgColor]
        caGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        caGradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        return caGradient
    }()

    @IBAction func refreshBtnAction(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

