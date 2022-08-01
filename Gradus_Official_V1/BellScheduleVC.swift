//
//  BellScheduleVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/29/22.
//

import UIKit
import SwiftSoup
import EFAutoScrollLabel
class BellScheduleVC: UIViewController {
    var scheduleHTML = UserDefaults.standard.object(forKey: "247070schedule")
    var classes = [ClassSpecifics]()
    var yPos = 30.0
    var arrayOfButtons = [UIButton]()
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: getScrollingHeight() + 50)
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
    func getScrollingHeight() -> CGFloat {
        var height = 30.0
        do {
            let docS = try SwiftSoup.parse(scheduleHTML as! String)
            let Schedule = try docS.select("table.sg-asp-table").first()
            let elementsOfScedule = try Schedule?.select("tr.sg-asp-table-data-row")
            height = CGFloat(50.0 * Double(elementsOfScedule?.count ?? 0))
        }
        catch {
            
        }
        return height
    }
    override func viewDidLoad() {
        view.addSubview(containerView)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        super.viewDidLoad()
        setUp(HTML: scheduleHTML as! String)
        var periodLabel = UILabel(frame: CGRect(x: view.frame.width * 0 , y: 30.0, width: view.frame.width * 0.2, height: 20))
        periodLabel.textAlignment = .center
        periodLabel.text = "Period"
      containerView.addSubview(periodLabel)
        var courseLabel = UILabel(frame: CGRect(x: view.frame.width * 0.20, y: 30.0, width: view.frame.width * 0.55, height: 20))
        courseLabel.text = "Course Name"
        courseLabel.textAlignment = .center
        containerView.addSubview(courseLabel)
        
        var daysLabel = UILabel(frame: CGRect(x: view.frame.width * 0.80, y: 30.0, width: view.frame.width * 0.15, height: 20))
        daysLabel.text = "Room"
        daysLabel.textAlignment = .center
        containerView.addSubview(daysLabel)
        readyLabels()
        
    }
    func readyLabels() {
        for i in 0..<classes.count {
            yPos+=50
            let button = UIButton(frame: CGRect(x: 0, y: yPos, width: view.frame.width, height: 30))

            button.backgroundColor = .link
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            arrayOfButtons.append(button)
            containerView.addSubview(button)
            var periodLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.0 , y: yPos, width: view.frame.width * 0.15, height: 30))
            periodLabel.textAlignment = .center
            if classes[i].days.count == 1{
                periodLabel.text = "\(classes[i].periods)\(classes[i].days)"
            }
            else {
                periodLabel.text = "\(classes[i].periods) - \(classes[i].days) "
            }
            periodLabel.textColor = .white
          containerView.addSubview(periodLabel)
            var courseLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.20, y: yPos, width: view.frame.width * 0.55, height: 30))
            courseLabel.text = classes[i].courseDescription
            courseLabel.textAlignment = .center
            courseLabel.textColor = .white
            containerView.addSubview(courseLabel)
            
            var daysLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.80, y: yPos, width: view.frame.width * 0.15, height: 30))
            daysLabel.text = "\(classes[i].room)"
            daysLabel.textAlignment = .center
            daysLabel.textColor = .white
            containerView.addSubview(daysLabel)
            
        }
    }
    @objc func buttonAction(sender:UIButton!) {
       
        if arrayOfButtons.contains(sender) {
            var i = arrayOfButtons.firstIndex(of: sender)!
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedulePopOver") as! schedulePopOverVC
            popOverVC.classSpecfic = classes[i]
            self.addChild(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
            
        }
      }
    func setUp(HTML: String) {
        do {
            let docS = try SwiftSoup.parse(HTML)
            let Schedule = try docS.select("table.sg-asp-table").first()
            let elementsOfScedule = try Schedule?.select("tr.sg-asp-table-data-row")
            
            for elements in elementsOfScedule!{
                let rand = try elements.select("td")

                let course = try elements.select("td").get(0).text()
                
                let courseDescription = try elements.select("td").get(1).text()
                print(courseDescription)
                let periods = try elements.select("td").get(2).text()
                let teacherName = try elements.select("td").get(3).text()
                let room = try elements.select("td").get(4).text()
                let days = try elements.select("td").get(5).text()
                let markingPeriods = try elements.select("td").get(6).text()
                let building = try elements.select("td").get(7).text()
                let status = try elements.select("td").get(8).text()
                let classSpecifics = ClassSpecifics(course: course, courseDescription: courseDescription, periods: periods, teacherName: teacherName, room: room, days: days, markingPeriods: markingPeriods, buiding: building, status: status)
                classes.append(classSpecifics)
                print(classSpecifics)
            }
        }
        catch {
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
