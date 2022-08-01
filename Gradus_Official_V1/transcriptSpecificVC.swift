//
//  transcriptSpecific.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/28/22.
//

import UIKit

class transcriptSpecificVC: UIViewController {
    var ypos = 30
    var courseLabel = UILabel()
    var sem1Label = UILabel()
    var sem2Label = UILabel()

    var testLabel = UILabel()
    
    var arrayOfButtons = [UIButton]()
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+10)
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .white
        view.contentSize = contentViewSize
        view.frame = self.view.bounds
        view.autoresizingMask = .flexibleHeight
        view.showsVerticalScrollIndicator = true
        view.bounces = true
        return view
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = contentViewSize
        return view
    }()

    var transcriptyear = transcriptYear(grade: "", building: "", years: "", arrayOfCourses: [""], arrayOfDescriptions: [""], arrayOfSem1Grades: [""], arrayOfSem2Grades: [""], arrayOfFinGrades: [""], arrayOfCredits: [""])
    
    
    
    override func viewDidLoad() {
       
        
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        
        courseLabel = UILabel(frame: CGRect(x: view.frame.width * 0.04, y: 30, width: view.frame.width * 0.4, height: 49))
        courseLabel.center.y = 30.0
        courseLabel.textAlignment = .center
        courseLabel.text = "Course Name"
        
        containerView.addSubview(courseLabel)
        sem1Label = UILabel(frame: CGRect(x: view.frame.width * 0.48, y: 30, width: view.frame.width * 0.2, height: 49))
        sem1Label.center.y = 30.0
        sem1Label.textAlignment = .center

        sem1Label.text = "Sem1"
        containerView.addSubview(sem1Label)
        sem2Label = UILabel(frame: CGRect(x: view.frame.width * 0.72, y: 30, width: view.frame.width * 0.2, height: 49))
        sem2Label.center.y = 30.0
        sem2Label.textAlignment = .center
        sem2Label.text = "Sem2"
        containerView.addSubview(sem2Label)
        /*
        let topConstraint1 = NSLayoutConstraint(item: courseLabel, attribute: .topMargin, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0.0)
        let leftConstraint1 = NSLayoutConstraint(item: courseLabel, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
        let rightConstraint1 = NSLayoutConstraint(item: courseLabel, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.4, constant: 0.0)
        
        let topConstraint2 = NSLayoutConstraint(item: sem1Label, attribute: .topMargin, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0.0)
        let leftConstraint2 = NSLayoutConstraint(item: sem1Label, attribute: .leftMargin, relatedBy: .equal, toItem: courseLabel, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
        let rightConstraint2 = NSLayoutConstraint(item: sem1Label, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.2, constant: 0.0)
        
        let topConstraint3 = NSLayoutConstraint(item: sem2Label, attribute: .topMargin, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0.0)
        let leftConstraint3 = NSLayoutConstraint(item: sem2Label, attribute: .leftMargin, relatedBy: .equal, toItem: sem1Label, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
        let rightConstraint3 = NSLayoutConstraint(item: sem2Label, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.2, constant: 0.0)
        
        
        view.addConstraints([topConstraint1, leftConstraint1, rightConstraint1, topConstraint2, leftConstraint2, rightConstraint3, rightConstraint2, leftConstraint3, topConstraint3])
         */
         
        testLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 49))
        
        testLabel.center.x = self.containerView.center.x
        testLabel.center.y = 10
        testLabel.textAlignment = .center
        
        testLabel.font = testLabel.font.withSize(41)
        containerView.addSubview(testLabel)
        setUpButtons()
    }
    
    func setUpButtons() {
        for i in 0..<transcriptyear.arrayOfCourses.count {
            ypos = ypos + 30
            let name = UILabel(frame: CGRect(x: view.frame.width * 0.04, y: CGFloat(ypos), width: view.frame.width * 0.4, height: 55))
            name.text = transcriptyear.arrayOfDescriptions[i]
            name.textAlignment = .center
            name.textColor = .black
            let sem1 = UILabel(frame: CGRect(x: view.frame.width * 0.48, y: CGFloat(ypos), width: view.frame.width * 0.2, height: 55))
            sem1.text = transcriptyear.arrayOfSem1Grades[i]
            sem1.textAlignment = .center
            
            sem1.textColor = .black
            let sem2 = UILabel(frame: CGRect(x: view.frame.width * 0.72, y: CGFloat(ypos), width: view.frame.width * 0.2, height: 55))
            sem2.text = transcriptyear.arrayOfSem2Grades[i]
            sem2.textAlignment = .center
            sem2.textColor = .black
            containerView.addSubview(name)
            containerView.addSubview(sem1)
            containerView.addSubview(sem2)
            /*
            if arrayOfButtons.count == 0 {
                
                name.translatesAutoresizingMaskIntoConstraints = false
                sem1.translatesAutoresizingMaskIntoConstraints = false
                sem2.translatesAutoresizingMaskIntoConstraints = false
                let topConstraint1 = NSLayoutConstraint(item: name, attribute: .topMargin, relatedBy: .equal, toItem: testLabel, attribute: .bottomMargin, multiplier: 1, constant: 0.0)
                let leftConstraint1 = NSLayoutConstraint(item: name, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint1 = NSLayoutConstraint(item: name, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.4, constant: 0.0)
                
                let topConstraint2 = NSLayoutConstraint(item: sem1, attribute: .topMargin, relatedBy: .equal, toItem: testLabel, attribute: .bottomMargin, multiplier: 1, constant: 0.0)
                let leftConstraint2 = NSLayoutConstraint(item: sem1, attribute: .leftMargin, relatedBy: .equal, toItem: name, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint2 = NSLayoutConstraint(item: sem1, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.2, constant: 0.0)
                
                let topConstraint3 = NSLayoutConstraint(item: sem2, attribute: .topMargin, relatedBy: .equal, toItem: testLabel, attribute: .bottomMargin, multiplier: 1, constant: 0.0)
                let leftConstraint3 = NSLayoutConstraint(item: sem2, attribute: .leftMargin, relatedBy: .equal, toItem: sem1, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint3 = NSLayoutConstraint(item: sem2, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.2, constant: 0.0)
                
                view.addConstraints([topConstraint1, leftConstraint1, rightConstraint1, topConstraint2, leftConstraint2, rightConstraint3, rightConstraint2, leftConstraint3, topConstraint3])
                return
            }
            else {
                
            }
             */
        }
    }

}
