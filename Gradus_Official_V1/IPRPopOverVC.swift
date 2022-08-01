//
//  IPRPopOverVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/30/22.
//

import UIKit

class IPRPopOverVC: UIViewController {

    
    @IBOutlet weak var TeacherLabel: UILabel!
    
    @IBOutlet weak var roomLabel: UILabel!
    
    
    @IBOutlet weak var tardiesLabel: UILabel!
    
    @IBOutlet weak var absencesLabel: UILabel!
    var iprobj = iprObject(course: "", description: "", period: "", teacher: "", room: "", score: "", absences: "", tardies: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        TeacherLabel.text = "Teacher: \(iprobj.teacher)"
        roomLabel.text =  "Room: \(iprobj.room)"
        tardiesLabel.text = "Tardies: \(iprobj.tardies)"
        absencesLabel.text = "Absences: \(iprobj.absences)"
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


