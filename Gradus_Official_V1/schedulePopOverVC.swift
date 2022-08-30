//
//  schedulePopOverVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/30/22.
//

import UIKit
import EFAutoScrollLabel
class schedulePopOverVC: UIViewController {

    @IBOutlet weak var TeacherLabel: UILabel!
    
    @IBOutlet var tempview: UIView!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var MPLabel: UILabel!
    
    @IBOutlet weak var buildingLabel: UILabel!
    
    var classSpecfic = ClassSpecifics(course: "", courseDescription: "", periods: "", teacherName: "", room: "", days: "", markingPeriods: "", buiding: "", status: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        tempview.layer.cornerRadius = 10

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        TeacherLabel.text = "Teacher: \(classSpecfic.teacherName)"
        
        roomLabel.text = "Room: \(classSpecfic.room)"
        MPLabel.text = "MPS: \(classSpecfic.markingPeriods)"
        buildingLabel.text = "Bulding: \(classSpecfic.buiding)"
        showAnimate()
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
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.removeAnimate()
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
