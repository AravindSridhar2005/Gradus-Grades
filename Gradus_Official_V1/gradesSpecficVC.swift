//
//  gradesSpecficVC.swift
//  Ind_Page_Tests
//
//  Created by Aravind Sridhar on 7/27/22.
//

import UIKit
class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var assigmment: Assignment?
}
class gradesSpecficVC: UIViewController {
    var arrayOfMajorGrades = [Assignment]()
    var arrayOfMinorGrades = [Assignment]()
    var dict = [String: Assignment]()
    var MajorLabel = UILabel()
    var arrayOfButtons = [UIButton]()
    var MinorLabel = UILabel()
    var arrayOfAssignments = [Assignment]()
    //var assignmentToBePassed = Assignment(dateDue: "", dateAss: "", assName: "", cat: "", score: "", totalPts: "", weight: "", className: "")
    var yMinor = 0.0
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        arrayOfMajorGrades = [Assignment]()
        arrayOfMinorGrades = [Assignment]()
        for element in arrayOfAssignments {
            if element.cat == "Major Grades" {
                arrayOfMajorGrades.append(element)
            }
            else {
                arrayOfMinorGrades.append(element)
            }
        }
        if arrayOfAssignments.count == 0 {
            let label = UILabel(frame: CGRect(x: containerView.center.x, y: containerView.center.y, width: containerView.frame.width, height: 70))
            label.center.x = self.containerView.center.x
            label.text = "No Assignments to Display"
            label.textAlignment = .center
            label.font = label.font.withSize(25)
            containerView.addSubview(label)
            //
        }
        else if arrayOfMajorGrades.count == 0 {
            MinorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 49))
            MinorLabel.center.x = self.containerView.center.x
            MinorLabel.center.y = 30.0
            MinorLabel.textAlignment = .center
            MinorLabel.text = "Minor Grades"
            MinorLabel.font = MinorLabel.font.withSize(30)
            containerView.addSubview(MinorLabel)
            setUpMinorGrades(arrayOfMinorGrades: arrayOfMinorGrades, majorIsEmpty: true)
            
        }
        else if arrayOfMinorGrades.count == 0 {
            MajorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 49))
            MajorLabel.center.x = self.containerView.center.x
            MajorLabel.center.y = 30.0
            MajorLabel.textAlignment = .center
            MajorLabel.text = "Major Grades"
            MajorLabel.font = MajorLabel.font.withSize(30)
            containerView.addSubview(MajorLabel)
            setUpMajorGrades(arrayOfMajorGrades: arrayOfMajorGrades)
        }
        else {
            MajorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 49))
            MajorLabel.center.x = self.containerView.center.x
            MajorLabel.center.y = 30.0
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
            let nameButton = UIButton()
            dict[arrayOfMajorGrades[i].assName] = arrayOfMajorGrades[i]
            nameButton.setTitle(arrayOfMajorGrades[i].assName, for: .normal)
            nameButton.setTitleColor(.white, for: .normal)
            nameButton.contentHorizontalAlignment = .left
            nameButton.setTitleColor(.black, for: .normal)
            
            nameButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            
            containerView.addSubview(nameButton)
            let gradeLabel = UIButton()
            gradeLabel.setTitle(arrayOfMajorGrades[i].score, for: .normal)
            gradeLabel.setTitleColor(.black, for: .normal)
            gradeLabel.contentHorizontalAlignment = .right
            containerView.addSubview(gradeLabel)
            if arrayOfButtons.count == 0{
                nameButton.translatesAutoresizingMaskIntoConstraints = false
                gradeLabel.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.75, constant: 0.0)
                let topConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .topMargin, relatedBy: .greaterThanOrEqual, toItem: MajorLabel, attribute: .bottomMargin, multiplier: 1.5, constant: 0)
            
                let leftConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .leftMargin, relatedBy: .equal, toItem: nameButton, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0.0)
                let topConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .topMargin, relatedBy: .greaterThanOrEqual, toItem: MajorLabel, attribute: .bottomMargin, multiplier: 1.5, constant: 0)
                view.addConstraints([leftConstraint1, rightConstraint1, topConstraint1, leftConstraint2, rightConstraint2, topConstraint2])
                print(nameButton.frame.height)
                yMinor+=((gradeLabel.intrinsicContentSize.height * 1.5) + nameButton.intrinsicContentSize.height + 10)
                
                
            }
            else if arrayOfButtons.count != 0 {
                nameButton.translatesAutoresizingMaskIntoConstraints = false
                gradeLabel.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.75, constant: 0.0)
                let topConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .topMargin, relatedBy: .greaterThanOrEqual, toItem: arrayOfButtons[arrayOfButtons.count - 2], attribute: .bottomMargin, multiplier: 1, constant: 10)
            
                let leftConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .leftMargin, relatedBy: .equal, toItem: nameButton, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0.0)
                let topConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .topMargin, relatedBy: .greaterThanOrEqual, toItem: arrayOfButtons[arrayOfButtons.count - 1], attribute: .bottomMargin, multiplier: 1, constant: 10)
                print(topConstraint2.accessibilityFrame.minY)
                view.addConstraints([leftConstraint1, rightConstraint1, topConstraint1, leftConstraint2, rightConstraint2, topConstraint2])
                print(nameButton.center.y)
                yMinor+=(nameButton.intrinsicContentSize.height)
                
            }
            arrayOfButtons.append(nameButton)
            arrayOfButtons.append(gradeLabel)
            //arrayOfLabels.append(gradeLabel)

        }
    }
    @objc func buttonAction(sender:UIButton!) {
        //let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popover") as! gradePopOverVC
        popOverVC.assignment = dict[sender.titleLabel!.text!]!
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
      }

    
    func setUpMinorGrades(arrayOfMinorGrades: [Assignment], majorIsEmpty: Bool) {
        if majorIsEmpty == false {
            MinorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 49))
        //print(arrayOfButtons[arrayOfButtons.count-1].frame.origin.y)
            MinorLabel.center.x = self.containerView.center.x
            MinorLabel.center.y = yMinor + 10
            MinorLabel.textAlignment = .center
            MinorLabel.text = "Minor Grades"
            MinorLabel.font = MinorLabel.font.withSize(30)
            containerView.addSubview(MinorLabel)
        }
        
        for i in 0..<arrayOfMinorGrades.count {
            let nameButton = UIButton()
            dict[arrayOfMinorGrades[i].assName] = arrayOfMinorGrades[i]
            nameButton.setTitle(arrayOfMinorGrades[i].assName, for: .normal)
            nameButton.setTitleColor(.white, for: .normal)
            nameButton.contentHorizontalAlignment = .left
            nameButton.setTitleColor(.black, for: .normal)
            
            nameButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            
            containerView.addSubview(nameButton)
            let gradeLabel = UIButton()
            gradeLabel.setTitle(arrayOfMinorGrades[i].score, for: .normal)
            gradeLabel.setTitleColor(.black, for: .normal)
            gradeLabel.contentHorizontalAlignment = .right
            containerView.addSubview(gradeLabel)
            if i == 0{
                nameButton.translatesAutoresizingMaskIntoConstraints = false
                gradeLabel.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.75, constant: 0.0)
                let topConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .topMargin, relatedBy: .greaterThanOrEqual, toItem: MinorLabel, attribute: .bottomMargin, multiplier: 1.5, constant: 0)
            
                let leftConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .leftMargin, relatedBy: .equal, toItem: nameButton, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0.0)
                let topConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .topMargin, relatedBy: .greaterThanOrEqual, toItem: MinorLabel, attribute: .bottomMargin, multiplier: 1.5, constant: 0)
                view.addConstraints([leftConstraint1, rightConstraint1, topConstraint1, leftConstraint2, rightConstraint2, topConstraint2])
                print(nameButton.frame.height)
                
                
                
            }
            else if arrayOfButtons.count != 0 {
                nameButton.translatesAutoresizingMaskIntoConstraints = false
                gradeLabel.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.75, constant: 0.0)
                let topConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .topMargin, relatedBy: .greaterThanOrEqual, toItem: arrayOfButtons[arrayOfButtons.count - 2], attribute: .bottomMargin, multiplier: 1, constant: 10)
            
                let leftConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .leftMargin, relatedBy: .equal, toItem: nameButton, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0.0)
                let topConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .topMargin, relatedBy: .greaterThanOrEqual, toItem: arrayOfButtons[arrayOfButtons.count - 1], attribute: .bottomMargin, multiplier: 1, constant: 10)
            
                view.addConstraints([leftConstraint1, rightConstraint1, topConstraint1, leftConstraint2, rightConstraint2, topConstraint2])
                
                
            }
            arrayOfButtons.append(nameButton)
            arrayOfButtons.append(gradeLabel)
            //arrayOfLabels.append(gradeLabel)

        }
        
        
    }


}
