//
//  gradesSpecficVC.swift
//  Ind_Page_Tests
//
//  Created by Aravind Sridhar on 7/27/22.
//

import UIKit
import SwiftUI
class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var assigmment: Assignment?
}
class gradesSpecficVC: UIViewController {
    var ypos = 50.0
    var arrayOfMajorGrades = [Assignment]()
    var arrayOfMinorGrades = [Assignment]()
    var arrayOfNonGraded = [Assignment]()
    var arrayOfMajorButtons = [UIButton]()
    var arrayOfMinorButtons = [UIButton]()
    var courseName = ""
    var dict = [String: Assignment]()
    var MajorLabel = UILabel()
    var arrayOfButtons = [UIButton]()
    var MinorLabel = UILabel()
    var arrayOfAssignments = [Assignment]()
    //var assignmentToBePassed = Assignment(dateDue: "", dateAss: "", assName: "", cat: "", score: "", totalPts: "", weight: "", className: "")
    var yMinor = 0.0
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: scrollHeight())
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
    func scrollHeight() -> CGFloat {
        var height = 80.0 + (60.0 * Double(arrayOfAssignments.count)) + 100
        return height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        arrayOfMajorGrades = [Assignment]()
        arrayOfMinorGrades = [Assignment]()
        arrayOfNonGraded = [Assignment]()
        for element in arrayOfAssignments {
            if element.cat == "Major Grades" {
                arrayOfMajorGrades.append(element)
            }
            if element.cat == "Non-graded" {
                arrayOfNonGraded.append(element)
            }
            else {
                arrayOfMinorGrades.append(element)
            }
            
            
            
        }
        let courseLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.125, y: 10, width: self.view.frame.width * 0.75 , height: 30))
        courseLabel.text = courseName
        courseLabel.textAlignment = .center
        courseLabel.font = courseLabel.font.withSize(25)
        containerView.addSubview(courseLabel)
        if arrayOfAssignments.count == 0 {
            let label = UILabel(frame: CGRect(x: containerView.center.x, y: containerView.center.y, width: containerView.frame.width, height: 70))
            label.center.x = self.containerView.center.x
            label.text = "No Assignments to Display"
            label.textAlignment = .center
            label.font = label.font.withSize(25)
            containerView.addSubview(label)
            //
        }
        
        else if arrayOfMajorGrades.count == 0 && arrayOfMinorGrades.count == 0 {
            var NGLabel = UILabel(frame: CGRect(x: 0, y: ypos, width: view.frame.width, height: 49))
            //MinorLabel.center.x = self.containerView.center.x
            NGLabel.center.y = 70.0
            NGLabel.textAlignment = .center
            NGLabel.text = "Non_Graded"
            NGLabel.font = MinorLabel.font.withSize(30)
            containerView.addSubview(NGLabel)
            setUpMinorGrades(arrayOfMinorGrades: arrayOfMinorGrades, majorIsEmpty: true)
        }
        else if arrayOfMajorGrades.count == 0 {
            MinorLabel = UILabel(frame: CGRect(x: 0, y: ypos, width: view.frame.width, height: 49))
            //MinorLabel.center.x = self.containerView.center.x
            MinorLabel.center.y = 70.0
            MinorLabel.textAlignment = .center
            MinorLabel.text = "Minor Grades"
            MinorLabel.font = MinorLabel.font.withSize(30)
            containerView.addSubview(MinorLabel)
            setUpMinorGrades(arrayOfMinorGrades: arrayOfMinorGrades, majorIsEmpty: true)
            
        }
        else if arrayOfMinorGrades.count == 0 {
            MajorLabel = UILabel(frame: CGRect(x: 0, y: ypos, width: view.frame.width, height: 49))
            //MajorLabel.center.x = self.containerView.center.x
            MajorLabel.center.y = 70.0
            MajorLabel.textAlignment = .center
            MajorLabel.text = "Major Grades"
            MajorLabel.font = MajorLabel.font.withSize(30)
            containerView.addSubview(MajorLabel)
            setUpMajorGrades(arrayOfMajorGrades: arrayOfMajorGrades)
        }
        else {
            MajorLabel = UILabel(frame: CGRect(x: 0, y: ypos, width: view.frame.width, height: 49))
            //MajorLabel.center.x = self.containerView.center.x
            MajorLabel.center.y = 70.0
            MajorLabel.textAlignment = .center
            MajorLabel.text = "Major Grades"
            MajorLabel.font = MajorLabel.font.withSize(30)
            containerView.addSubview(MajorLabel)
            
            setUpMajorGrades(arrayOfMajorGrades: arrayOfMajorGrades)
            setUpMinorGrades(arrayOfMinorGrades: arrayOfMinorGrades, majorIsEmpty: false)
        }
        
        
    }
    
    func setUpMajorGrades(arrayOfMajorGrades: [Assignment]) {
        for i in 0..<arrayOfMajorGrades.count {
            ypos += 60
            var button = UIButton(frame: CGRect(x: 0, y: ypos, width: view.frame.width, height: 20))
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            arrayOfMajorButtons.append(button)
            containerView.addSubview(button)
            if i != 0 {
                var lineView = UIView(frame: CGRect(x: view.frame.width * 0.05, y: ypos-25.0, width: view.frame.width*0.9, height: 1))
                lineView.backgroundColor = .lightGray
                containerView.addSubview(lineView)
            }
            var nameLabel = UILabel(frame: CGRect(x: 15, y: ypos, width: view.frame.width * 0.7 , height: 20))
            nameLabel.text = arrayOfMajorGrades[i].assName
            nameLabel.textColor = .black
            nameLabel.textAlignment = .left
            containerView.addSubview(nameLabel)
            var gradeLabel = UILabel(frame: CGRect(x: view.frame.width * 0.80, y: ypos, width: view.frame.width * 0.20 - 15.0 , height: 20))
            gradeLabel.text = arrayOfMajorGrades[i].score
            gradeLabel.textColor = .black
            gradeLabel.textAlignment = .center
            containerView.addSubview(gradeLabel)
            if arrayOfMajorGrades[i].totalPts != "100.00" {
                var totalPts = UILabel(frame: CGRect(x: view.frame.width * 0.80, y: ypos+20, width: view.frame.width * 0.2 , height: 10))
                totalPts.text = "/\(arrayOfMajorGrades[i].totalPts)"
                totalPts.textAlignment = .center
                totalPts.textColor = .black
                totalPts.font = totalPts.font.withSize(12.0)
                containerView.addSubview(totalPts)

            }
            var dateLabel = UILabel(frame: CGRect(x: 17, y: ypos+20, width: view.frame.width * 0.4 , height: 15))
            if arrayOfMajorGrades[i].weight == "1.00"{
                dateLabel.text = arrayOfMajorGrades[i].dateDue
            }
            else {
                dateLabel.text = "\(arrayOfMajorGrades[i].dateDue) | Weight: \(arrayOfMajorGrades[i].weight)"
            }
            dateLabel.textAlignment = .left
            dateLabel.textColor = .black
            dateLabel.font = dateLabel.font.withSize(12.0)
            containerView.addSubview(dateLabel)

        }
    }
    @objc func buttonAction(sender:UIButton!) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popover") as! gradePopOverVC
        if arrayOfMajorButtons.contains(sender) {
            var i = arrayOfMajorButtons.firstIndex(of: sender)
            popOverVC.assignment = arrayOfMajorGrades[i!]
        }
        if arrayOfMinorButtons.contains(sender) {
            var i = arrayOfMinorButtons.firstIndex(of: sender)
            popOverVC.assignment = arrayOfMinorGrades[i!]
        }
        
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
      }

    func setUpNonGraded(arrayOfNonGraded: [Assignment], MinorIsEmpty: Bool) {
                        
    }
    func setUpMinorGrades(arrayOfMinorGrades: [Assignment], majorIsEmpty: Bool) {
        if majorIsEmpty == false {
            ypos += 50
            MinorLabel = UILabel(frame: CGRect(x: 0, y: ypos, width: view.frame.width, height: 49))
        //print(arrayOfButtons[arrayOfButtons.count-1].frame.origin.y)
            //MinorLabel.center.x = self.containerView.center.x
            MinorLabel.textAlignment = .center
            MinorLabel.text = "Minor Grades"
            MinorLabel.font = MinorLabel.font.withSize(30)
            containerView.addSubview(MinorLabel)
            
        }
        
        for i in 0..<arrayOfMinorGrades.count {
            ypos += 60
            var button = UIButton(frame: CGRect(x: 0, y: ypos, width: view.frame.width, height: 20))
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            arrayOfMinorButtons.append(button)
            containerView.addSubview(button)
            if i != 0 {
                var lineView = UIView(frame: CGRect(x: view.frame.width * 0.05, y: ypos-25.0, width: view.frame.width*0.9, height: 1))
                lineView.backgroundColor = .lightGray
                containerView.addSubview(lineView)
            }
            var nameLabel = UILabel(frame: CGRect(x: 15, y: ypos, width: view.frame.width * 0.7 , height: 20))
            nameLabel.text = arrayOfMinorGrades[i].assName
            nameLabel.textColor = .black
            nameLabel.textAlignment = .left
            containerView.addSubview(nameLabel)
            var gradeLabel = UILabel(frame: CGRect(x: view.frame.width * 0.80, y: ypos, width: view.frame.width * 0.20 - 15 , height: 20))
            gradeLabel.text = arrayOfMinorGrades[i].score
            gradeLabel.textColor = .black
            gradeLabel.textAlignment = .center
            containerView.addSubview(gradeLabel)
            if arrayOfMinorGrades[i].totalPts != "100.00" {
                var totalPts = UILabel(frame: CGRect(x: view.frame.width * 0.80, y: ypos+20, width: view.frame.width * 0.2 , height: 10))
                totalPts.text = "/\(arrayOfMinorGrades[i].totalPts)"
                totalPts.textAlignment = .center
                totalPts.textColor = .black
                totalPts.font = totalPts.font.withSize(12.0)
                containerView.addSubview(totalPts)

            }
            var dateLabel = UILabel(frame: CGRect(x: 17, y: ypos+20, width: view.frame.width * 0.4 , height: 15))
            if arrayOfMinorGrades[i].weight == "1.00"{
                dateLabel.text = arrayOfMinorGrades[i].dateDue
            }
            else {
                dateLabel.text = "\(arrayOfMinorGrades[i].dateDue) | Weight: \(arrayOfMinorGrades[i].weight)"
            }
            dateLabel.textAlignment = .left
            dateLabel.textColor = .black
            dateLabel.font = dateLabel.font.withSize(12.0)
            containerView.addSubview(dateLabel)
            
        }
        
        
    }


}
