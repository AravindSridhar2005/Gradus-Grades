//
//  BellScheduleVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/29/22.
//

import UIKit
import SwiftSoup
import EFAutoScrollLabel
import DropDown
import Alamofire
class BellScheduleVC: UIViewController {
    var scheduleHTML = UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)schedule")
    var classes = [ClassSpecifics]()
    var semOneADaySchedule = [ClassSpecifics]()
    var semOneBDaySchedule = [ClassSpecifics]()
    var semTwoADaySchedule = [ClassSpecifics]()
    var semTwoBDaySchedule = [ClassSpecifics]()
    
    
    var semOneADayButton = [UIButton]()
    var semOneBDayButton = [UIButton]()
    var semTwoADayButton = [UIButton]()
    var semTwoBDayButton = [UIButton]()
    var arrayOfLabels = [UILabel]()
    var arrayOfButtons = [UIButton]()
    var arrayOfEFAutoLabels = [EFAutoScrollLabel]()
    var advisory = [ClassSpecifics]()
    
    
    @IBOutlet weak var SemesterButton: UIBarButtonItem!
    
    
    @IBAction func navBarClicked(_ sender: Any) {
        menu.show()
    }
    
    
    
    
    var yPos = 0.0
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: getScrollingHeight(sem: "Q1, Q2") + 50)
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
    var menu: DropDown {
        let menu = DropDown()
        menu.dataSource = ["Sem1", "Sem2"]
        menu.anchorView = SemesterButton
        menu.selectionAction = { index, title in
            self.SemesterButton.title = title
            for label in self.arrayOfEFAutoLabels {
                label.removeFromSuperview()
            }
            for button in self.arrayOfButtons {
                button.removeFromSuperview()
            }
            self.arrayOfEFAutoLabels.removeAll()
            self.arrayOfButtons.removeAll()
            var mp = ""
            if title == "Sem1" {
                mp = "Q1, Q2"
            }
            else {
                mp = "Q3, Q4"
            }
            self.contentViewSize.height = self.getScrollingHeight(sem: mp) + 50
            self.scrollView.contentSize = self.contentViewSize
            self.containerView.frame.size = self.contentViewSize
            self.yPos = 0.0
            if title == "Sem1" {
                self.readySem1Labels()
            }
            else {
                self.readySem2Labels()
            }
            self.readyAdvisory()
        }
        return menu
    }
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = contentViewSize
        return view
    }()
    func getScrollingHeight(sem: String) -> CGFloat {
        var height = 30.0
        do {
            let docS = try SwiftSoup.parse(scheduleHTML as! String)
            let Schedule = try docS.select("table.sg-asp-table").first()
            let elementsOfScedule = try Schedule?.select("tr.sg-asp-table-data-row")
            
            var count = 0
            for element in elementsOfScedule! {
                let markingPeriods = try element.select("td").get(6).text()
                print(markingPeriods)
                if markingPeriods == sem {
                    count+=1
                }
                
            }
            count+=1
            height = CGFloat(50.0 * Double(count))
        }
        catch {
            
        }
        return height
    }
    override func viewDidLoad() {
        view.addSubview(containerView)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        SemesterButton.title = "Sem1"
        super.viewDidLoad()
        setUp(HTML: scheduleHTML as! String)
        var periodLabel = UILabel(frame: CGRect(x: view.frame.width * 0 , y: 0.0, width: view.frame.width * 0.2, height: 20))
        periodLabel.textAlignment = .center
        periodLabel.text = "Period"
      containerView.addSubview(periodLabel)
        var courseLabel = UILabel(frame: CGRect(x: view.frame.width * 0.20, y: 0.0, width: view.frame.width * 0.55, height: 20))
        courseLabel.text = "Course Name"
        courseLabel.textAlignment = .center
        containerView.addSubview(courseLabel)
        
        var daysLabel = UILabel(frame: CGRect(x: view.frame.width * 0.80, y: 0.0, width: view.frame.width * 0.15, height: 20))
        daysLabel.text = "Room"
        daysLabel.textAlignment = .center
        containerView.addSubview(daysLabel)
        readySem1Labels()
        readyAdvisory()
        
    }
    func readySem1Labels() {
        for i in 0..<semOneADaySchedule.count {
            yPos+=50
            let button = UIButton(frame: CGRect(x: 0, y: yPos, width: view.frame.width, height: 30))

            button.backgroundColor = .link
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(buttonAction1A), for: .touchUpInside)
            semOneADayButton.append(button)
            containerView.addSubview(button)
            var periodLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.0 , y: yPos, width: view.frame.width * 0.15, height: 30))
            periodLabel.textAlignment = .center
            periodLabel.text = "\(semOneADaySchedule[i].periods)\(semOneADaySchedule[i].days)"
            periodLabel.textColor = .white
          containerView.addSubview(periodLabel)
            var courseLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.20, y: yPos, width: view.frame.width * 0.55, height: 30))
            courseLabel.text = semOneADaySchedule[i].courseDescription
            courseLabel.textAlignment = .center
            courseLabel.textColor = .white
            containerView.addSubview(courseLabel)
            
            var daysLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.80, y: yPos, width: view.frame.width * 0.15, height: 30))
            daysLabel.text = "\(semOneADaySchedule[i].room)"
            daysLabel.textAlignment = .center
            daysLabel.textColor = .white
            containerView.addSubview(daysLabel)
            
            arrayOfEFAutoLabels.append(contentsOf: [daysLabel, periodLabel, courseLabel])
        }
        for i in 0..<semOneBDaySchedule.count {
            yPos+=50
            let button = UIButton(frame: CGRect(x: 0, y: yPos, width: view.frame.width, height: 30))

            button.backgroundColor = .link
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(buttonAction1B), for: .touchUpInside)
            semOneBDayButton.append(button)
            containerView.addSubview(button)
            var periodLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.0 , y: yPos, width: view.frame.width * 0.15, height: 30))
            periodLabel.textAlignment = .center
            periodLabel.text = "\(semOneBDaySchedule[i].periods)\(semOneBDaySchedule[i].days)"
            periodLabel.textColor = .white
          containerView.addSubview(periodLabel)
            var courseLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.20, y: yPos, width: view.frame.width * 0.55, height: 30))
            courseLabel.text = semOneBDaySchedule[i].courseDescription
            courseLabel.textAlignment = .center
            courseLabel.textColor = .white
            containerView.addSubview(courseLabel)
            
            var daysLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.80, y: yPos, width: view.frame.width * 0.15, height: 30))
            daysLabel.text = "\(semOneBDaySchedule[i].room)"
            daysLabel.textAlignment = .center
            daysLabel.textColor = .white
            containerView.addSubview(daysLabel)
        
            arrayOfEFAutoLabels.append(contentsOf: [daysLabel, periodLabel, courseLabel])
            
        }
        
    }
    func readyAdvisory() {
        yPos+=50
        let button = UIButton(frame: CGRect(x: 0, y: yPos, width: view.frame.width, height: 30))

        button.backgroundColor = .link
        button.layer.cornerRadius = 15
        //button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        //arrayOfButtons.append(button)
        containerView.addSubview(button)
        var periodLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.0 , y: yPos, width: view.frame.width * 0.15, height: 30))
        periodLabel.textAlignment = .center
        periodLabel.text = "\(advisory[0].periods)\(advisory[0].days)"
        periodLabel.textColor = .white
      containerView.addSubview(periodLabel)
        var courseLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.20, y: yPos, width: view.frame.width * 0.55, height: 30))
        courseLabel.text = advisory[0].courseDescription
        courseLabel.textAlignment = .center
        courseLabel.textColor = .white
        containerView.addSubview(courseLabel)
        
        var daysLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.80, y: yPos, width: view.frame.width * 0.15, height: 30))
        daysLabel.text = "\(advisory[0].room)"
        daysLabel.textAlignment = .center
        daysLabel.textColor = .white
        containerView.addSubview(daysLabel)
    
        arrayOfEFAutoLabels.append(contentsOf: [daysLabel, periodLabel, courseLabel])
    }
    func readySem2Labels() {
        for i in 0..<semTwoADaySchedule.count {
            yPos+=50
            let button = UIButton(frame: CGRect(x: 0, y: yPos, width: view.frame.width, height: 30))

            button.backgroundColor = .link
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(buttonAction2A), for: .touchUpInside)
            semTwoADayButton.append(button)
            containerView.addSubview(button)
            var periodLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.0 , y: yPos, width: view.frame.width * 0.15, height: 30))
            periodLabel.textAlignment = .center
            periodLabel.text = "\(semTwoADaySchedule[i].periods)\(semTwoADaySchedule[i].days)"
            periodLabel.textColor = .white
          containerView.addSubview(periodLabel)
            var courseLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.20, y: yPos, width: view.frame.width * 0.55, height: 30))
            courseLabel.text = semTwoADaySchedule[i].courseDescription
            courseLabel.textAlignment = .center
            courseLabel.textColor = .white
            containerView.addSubview(courseLabel)
            
            var daysLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.80, y: yPos, width: view.frame.width * 0.15, height: 30))
            daysLabel.text = "\(semTwoADaySchedule[i].room)"
            daysLabel.textAlignment = .center
            daysLabel.textColor = .white
            containerView.addSubview(daysLabel)
            
            arrayOfEFAutoLabels.append(contentsOf: [daysLabel, periodLabel, courseLabel])
        }
        for i in 0..<semTwoBDaySchedule.count {
            yPos+=50
            let button = UIButton(frame: CGRect(x: 0, y: yPos, width: view.frame.width, height: 30))

            button.backgroundColor = .link
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(buttonAction2B), for: .touchUpInside)
            semTwoBDayButton.append(button)
            containerView.addSubview(button)
            var periodLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.0 , y: yPos, width: view.frame.width * 0.15, height: 30))
            periodLabel.textAlignment = .center
            periodLabel.text = "\(semTwoBDaySchedule[i].periods)\(semTwoBDaySchedule[i].days)"
            periodLabel.textColor = .white
          containerView.addSubview(periodLabel)
            var courseLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.20, y: yPos, width: view.frame.width * 0.55, height: 30))
            courseLabel.text = semTwoBDaySchedule[i].courseDescription
            courseLabel.textAlignment = .center
            courseLabel.textColor = .white
            containerView.addSubview(courseLabel)
            
            var daysLabel = EFAutoScrollLabel(frame: CGRect(x: view.frame.width * 0.80, y: yPos, width: view.frame.width * 0.15, height: 30))
            daysLabel.text = "\(semTwoBDaySchedule[i].room)"
            daysLabel.textAlignment = .center
            daysLabel.textColor = .white
            containerView.addSubview(daysLabel)
        
            arrayOfEFAutoLabels.append(contentsOf: [daysLabel, periodLabel, courseLabel])        }
        
    }
    @objc func buttonAction1A(sender:UIButton!) {
       
        if semOneADayButton.contains(sender) {
            var i = semOneADayButton.firstIndex(of: sender)!
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedulePopOver") as! schedulePopOverVC
            popOverVC.classSpecfic = semOneADaySchedule[i]
            self.addChild(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
            
        }
      }
    @objc func buttonAction1B(sender:UIButton!) {
       
        if semOneBDayButton.contains(sender) {
            var i = semOneBDayButton.firstIndex(of: sender)!
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedulePopOver") as! schedulePopOverVC
            popOverVC.classSpecfic = semOneBDaySchedule[i]
            self.addChild(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
            
        }
      }
    @objc func buttonAction2A(sender:UIButton!) {
       
        if semTwoADayButton.contains(sender) {
            var i = semTwoADayButton.firstIndex(of: sender)!
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedulePopOver") as! schedulePopOverVC
            popOverVC.classSpecfic = semTwoADaySchedule[i]
            self.addChild(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
            
        }
      }
    @objc func buttonAction2B(sender:UIButton!) {
       
        if semTwoBDayButton.contains(sender) {
            var i = semTwoBDayButton.firstIndex(of: sender)!
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedulePopOver") as! schedulePopOverVC
            popOverVC.classSpecfic = semTwoBDaySchedule[i]
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
                if (markingPeriods == "Q1, Q2"){
                    if days == "A" {
                        semOneADaySchedule.append(classSpecifics)
                    } else {
                        semOneBDaySchedule.append(classSpecifics)
                    }
                }
                else {
                    if days == "A" {
                        semTwoADaySchedule.append(classSpecifics)
                    } else if days == "B"{
                        semTwoBDaySchedule.append(classSpecifics)
                    }
                }
                if(markingPeriods == "Q1, Q2, Q3, Q4"){
                    advisory.append(classSpecifics)
                }
            }
        }
        catch {
            
        }
    }
    var refreshControl = UIRefreshControl()
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            scrollView.refreshControl = refreshControl
            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        }

        @objc func refresh()
        {
            for label in arrayOfLabels {
                label.removeFromSuperview()
            }
            arrayOfLabels.removeAll()
            for button in arrayOfButtons {
                button.removeFromSuperview()
            }
            arrayOfButtons.removeAll()
            self.semOneADaySchedule.removeAll()
            self.semTwoADaySchedule.removeAll()
            self.semOneBDaySchedule.removeAll()
            self.semTwoBDaySchedule.removeAll()
            self.classes.removeAll()
            for button in arrayOfEFAutoLabels {
                button.removeFromSuperview()
            }
            arrayOfEFAutoLabels.removeAll()
            
            yPos = 0.0
            getScheduleHTML() {
                response in
                self.setUp(HTML: response)
                self.readySem1Labels()
                self.readyAdvisory()
                UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)schedule")
                print(response)
            }
            
            
            refreshControl.endRefreshing()

        }
    func getScheduleHTML(completion: @escaping (String) -> Void) {
        let Demographics = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Registration.aspx")
        var DemograhpicsHTML:String = ""
        let scheduleURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Classes.aspx")
        do {
            
            DemograhpicsHTML = try String(contentsOf: Demographics!, encoding: .ascii)
            let logonDoc = try SwiftSoup.parse(DemograhpicsHTML)
            //print(DemograhpicsHTML)
            if try logonDoc.select("[name=__RequestVerificationToken]").count == 1 {
                let logonURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Account/LogOn?")
                var logonHTML:String = ""
                logonHTML = try String(contentsOf: logonURL!, encoding: .ascii)
                let logonDoc = try SwiftSoup.parse(logonHTML)
                let token = try logonDoc.select("[name=__RequestVerificationToken]").val()
                print(UserDefaults.standard.object(forKey: "username"))
                print(UserDefaults.standard.object(forKey: "password"))
                let parametersForLogon = ["LogOnDetails.UserName": UserDefaults.standard.object(forKey: "username") as! String, "LogOnDetails.Password": UserDefaults.standard.object(forKey: "password") as! String, "SCKTY00328510CustomEnabled":"false","SCKTY00436568CustomEnabled":"false","__RequestVerificationToken":token, "Database":"10", "tempUN":"", "tempPW": "", "VerificationOption": "UsernamePassword"]
                AF.request("https://hac.friscoisd.org/HomeAccess/Account/LogOn?", method: .post, parameters: parametersForLogon, encoding: URLEncoding()).response { response in
                    let data = String(data: response.data!, encoding: .utf8)
                    do {
                        let verification_doc = try SwiftSoup.parse(data!)
                        completion(try String(contentsOf: scheduleURL!, encoding: .ascii))
                    }
                    catch{
                        
                    }
                }
            }
            else {
                completion(try String(contentsOf: scheduleURL!, encoding: .ascii))
            }
        }
        catch {
            
        }
    }
}
