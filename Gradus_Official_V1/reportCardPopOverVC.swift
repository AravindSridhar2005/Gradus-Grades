//
//  reportCardPopOverVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/29/22.
//

import UIKit

class reportCardPopOverVC: UIViewController {

    
    @IBOutlet weak var tempview: UIView!
    @IBOutlet weak var teacherLabel: UILabel!
    
    @IBOutlet weak var tardiesLabel: UILabel!
    @IBOutlet weak var YTDYLabel: UILabel!
    
    @IBOutlet weak var YTDALabel: UILabel!
    @IBOutlet weak var absencesLabel: UILabel!
    var RCO: ReportCardObject? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        tempview.layer.cornerRadius = (tempview.frame.height / 3) - 10

        teacherLabel.text = "Teacher: \(RCO!.teacher)"
        tardiesLabel.text = "Tardies: \(RCO!.tardies)"
        absencesLabel.text = "Absences: \(RCO!.absences)"
        YTDYLabel.text = "YTDY: \(RCO!.YTDY)"
        YTDALabel.text = "YTDA: \(RCO!.YTDA)"
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 12))
        button.backgroundColor = .link
        tempview.center.x = 12
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
