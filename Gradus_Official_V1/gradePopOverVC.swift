//
//  gradePopOverVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/28/22.
//

import UIKit

class gradePopOverVC: UIViewController {
    var assignment = Assignment(dateDue: "", dateAss: "", assName: "", cat: "", score: "", totalPts: "", weight: "", className: "")
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var label5: UILabel!
    
    @IBOutlet weak var label6: UILabel!
    
    
    @IBOutlet weak var tempview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        tempview.layer.cornerRadius = (tempview.frame.height / 3) - 10
        label1.text = "Date Assigned: \(assignment.dateAss)"
        label2.text = "Date Due: \(assignment.dateDue)"
        label3.text = "Weight: \(assignment.weight)"
        label4.text = "Score: \(assignment.score)"
        label5.text = "Total Points: \(assignment.totalPts)"
        label6.text = "Percentage: \(assignment.score)"
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.removeAnimate()
    }
    
    func showAnimate()
        {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            });
        }
        
        func removeAnimate()
        {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0;
                }, completion:{(finished : Bool)  in
                    if (finished)
                    {
                        self.view.removeFromSuperview()
                    }
            });
        }
}
