//
//  ViewController.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/28/22.
//

import UIKit
import SwiftSoup
import DropDown
import EFAutoScrollLabel
import Alamofire
class CellClass: UITableViewCell {
    
}
class gradesVC: UIViewController {
    
    @IBOutlet weak var MPButton: UIBarButtonItem!
    //@IBOutlet weak var MPButton: UIButton!
    @IBOutlet weak var GradesLabel: UINavigationItem!
    var selectedMPButton = UIBarButtonItem()
    let transparentView = UIView()
    let tableView = UITableView()
    var dataSource = [String]()
    var ypos = 0.0
    
    var arrayOfButtons = [UIButton]()
    var arrayOfLabels = [UILabel]()
    var currentGradesHTML = UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)currentGrades") as? String ?? ""
    var arrayOfClassNames = [String]()
    var arrayOfGrades = [String]()
    var dict = [String: [Assignment]]()
    
    var firstGradesHTML = ""
    var secondGradesHTML = ""
    var thirdGradesHTML = ""
    var fourthGradesHTML = ""
    
    var displayMultiplier = 0.0
    var currentMP = ""
    var testLabel = UILabel()
    var menu: DropDown {
        let menu = DropDown()
        do {
            
            
            let doc2 = try SwiftSoup.parse(currentGradesHTML)
            let currentMPHelper = try doc2.select("div.sg-content-grid-container").select("#plnMain_ddlReportCardRuns").select("option")
        
            var currentMPTemp:String = ""
            for element in currentMPHelper{
                if try element.text() != "(All Runs)" {
                    menu.dataSource.append("MP\(try element.text())")
                }
            }
             
        }
        catch {
        
        }
        menu.anchorView = MPButton
        menu.selectionAction = { index, title in
            self.MPButton.title = title
            var mp = title
            var array = Array(mp)
            array.remove(at: 0)
            array.remove(at: 0)
            mp = String(array)
            self.getNewHTMl(mp: mp, isRefresh: false) {
                response in
                
                for button in self.arrayOfButtons {
                    button.removeFromSuperview()
                }
                self.arrayOfButtons.removeAll()
                self.arrayOfClassNames.removeAll()
                self.arrayOfGrades.removeAll()
                self.dict.removeAll()
                for label in self.arrayOfLabels {
                    label.removeFromSuperview()
                }
                self.arrayOfLabels.removeAll()
                self.ypos = 0.0
                self.contentViewSize.height = self.getScrollHeight(HTML: response) + 100
                self.scrollView.contentSize = self.contentViewSize
                self.containerView.frame.size = self.contentViewSize
                self.display(html: response)
            }
            
            
        }
        return menu
    }
    
    @IBAction func didTapNavBarButton(_ sender: Any) {
        menu.show()
    }
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: getScrollHeight(HTML: currentGradesHTML) + 100)
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
    
    func setUpCurrentGradesHTML() {
        
        let currentGradesURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Assignments.aspx")
        do {
            self.currentGradesHTML = try String(contentsOf: currentGradesURL!, encoding: .ascii)
        }
        catch {
            
        }
    }
    let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.backgroundColor = .link
        let image = UIImage(systemName: "person.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        //button.layer.shadowRadius = 10
        //button.layer.shadowOpacity = 0.3
        return button
    }()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 75, y: 75, width: 50, height: 50)
        var rightNavBarButton = UIBarButtonItem(customView:floatingButton)
         self.navigationItem.leftBarButtonItem = rightNavBarButton
    }
  
    @objc func didTapProfileButton() {
        let vc = ProfileVC()
        vc.title = "Profile"
        vc.view.backgroundColor = .white
        
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        
    //self.setUpCurrentGradesHTML()

        super.viewDidLoad()
        //setUpCurrentGradesHTML()
            self.view.addSubview(self.containerView)
        
        print("Hello")
        
        do {
            let doc2 = try SwiftSoup.parse(self.currentGradesHTML)
            let currentMPHelper = try doc2.select("div.sg-content-grid-container").select("#plnMain_ddlReportCardRuns").select("option")
            
            var currentMPTemp:String = ""
            for element in currentMPHelper{
                if (element.hasAttr("selected")){
                    self.MPButton.title = "MP\(try element.text())"
                    self.currentMP = try element.text()
                }
            }
            self.view.addSubview(self.scrollView)
            self.scrollView.addSubview(self.containerView)
            
            self.floatingButton.addTarget(self, action: #selector(self.didTapProfileButton), for: .touchUpInside)
            
        }
        catch {
            
        }
        
        
            self.display(html: self.currentGradesHTML)
        
        
   
    }
    func getScrollHeight(HTML: String) -> CGFloat {
        if HTML == "" {
            
            setUpCurrentGradesHTML()
            
            var height = 0.0
            do {
                let doc = try SwiftSoup.parse(currentGradesHTML)
                let arrayOfClassNamesTemp:Elements = try doc.select("a.sg-header-heading")
                height = 70.0 * Double(arrayOfClassNamesTemp.count)
                print(arrayOfClassNamesTemp.count)
            }
            catch {
                
            }
            return height
        }
        var height = 0.0
        do {
            let doc = try SwiftSoup.parse(HTML)
            let arrayOfClassNamesTemp:Elements = try doc.select("a.sg-header-heading")
            height = 70.0 * Double(arrayOfClassNamesTemp.count)
            print(arrayOfClassNamesTemp.count)
        }
        catch {
            
        }
        return height
    }
    func display(html: String) {
        setUp(html: html)
        for i in 0..<arrayOfClassNames.count {
            ypos += 70
            let button = UIButton(frame: CGRect(x: 10, y: ypos, width: view.frame.width - 20.0, height: 40))
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            button.center.y = ypos
        
            
            button.backgroundColor = .link
            button.layer.cornerRadius = 20
            containerView.addSubview(button)
            var nameLabel = UILabel(frame: CGRect(x: 20, y: ypos, width: view.frame.width * 0.75 - 20, height: 20))
            nameLabel.text = arrayOfClassNames[i]
            nameLabel.center.y = ypos
            nameLabel.textColor = .white
            nameLabel.textAlignment = .left
            containerView.addSubview(nameLabel)
            var gradeLabel = UILabel(frame: CGRect(x: view.frame.width * 0.75, y: ypos, width: view.frame.width * 0.25, height: 20))
            gradeLabel.textColor = .white
            gradeLabel.text = arrayOfGrades[i]
            gradeLabel.textAlignment = .center
            gradeLabel.center.y = ypos
            containerView.addSubview(gradeLabel)
            
            
            arrayOfButtons.append(button)
            arrayOfLabels.append(nameLabel)
            arrayOfLabels.append(gradeLabel)

        }
    }
    
    @objc func buttonAction(sender:UIButton!) {
        if arrayOfButtons.contains(sender) {
            var i = arrayOfButtons.firstIndex(of: sender)!
            
            var className = arrayOfClassNames[i]
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let Homevc : gradesSpecficVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gradesSpecificVC") as! gradesSpecficVC
            Homevc.arrayOfAssignments = dict[className]!
            Homevc.courseName = className
            self.present(Homevc, animated: true, completion: nil)
        }
      }
    
    
    
    func setUp(html: String) {
        do {
            let doc = try SwiftSoup.parse(html)
            let arrayOfClassNamesTemp:Elements = try doc.select("a.sg-header-heading")
            for element in arrayOfClassNamesTemp {
                let tempStr: String = try element.text()
                //appending the class name to the REAL variable
                arrayOfClassNames.append(tempStr.components(separatedBy: " ").dropFirst(3).joined(separator: " "))
            }
            var i = 0;
            for elements in arrayOfClassNames{
               // print(try elements.text())
                var str = "#plnMain_rptAssigmnetsByCourse_lblHdrAverage_" + (String(i));
                var arrayOfGrades2:Elements = try doc.select("div.AssignmentClass").select(str)
                arrayOfGrades.append(try arrayOfGrades2[0].text().components(separatedBy: " ").dropFirst(2).joined(separator: " "))
                i+=1
            }
            
            for i in 0..<arrayOfClassNames.count{
                let str = "#plnMain_rptAssigmnetsByCourse_dgCourseAssignments_\(i)"
                let rand = try doc.select(str).select("tr.sg-asp-table-data-row")
                var arrayOfAssignments = [Assignment]()
                for element in rand {
                    let dateDue = try element.select("td").get(0).text()
                    let dateAss = try element.select("td").get(1).text()
                    var assName = try element.select("td").get(2).text()
                    var charArray = Array(assName)
                    var index1 = charArray.count - 1
                    while(charArray[index1] == " " || charArray[index1] == "*") {
                        charArray.remove(at: charArray.count-1)
                        index1-=1
                        
                    }
                    assName = String(charArray)
                    let category = try element.select("td").get(3).text()
                    let score = try element.select("td").get(4).text()
                    let totalPts = try element.select("td").get(5).text()
                    let weight = try element.select("td").get(6).text()
                    let assignment = Assignment(dateDue: dateDue, dateAss: dateAss, assName: assName, cat: category, score: score, totalPts: totalPts, weight: weight, className: arrayOfClassNames[i])
                    arrayOfAssignments.append(assignment)
                }
                self.dict[arrayOfClassNames[i]] = arrayOfAssignments
            }

        }
        catch {
            
        }
    }
    
    
    
    
    
    
    
    
    
    //BY POSTING OR MAKING GET REQUEST
    func getFiles(mp: String, completion: @escaping (String) -> Void){
        let Demographics = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Registration.aspx")
        var DemograhpicsHTML:String = ""
        
        do {
            
            DemograhpicsHTML = try String(contentsOf: Demographics!, encoding: .ascii)
            let logonDoc = try SwiftSoup.parse(DemograhpicsHTML)
            //print(DemograhpicsHTML)
            if try logonDoc.select("[name=__RequestVerificationToken]").count == 1 {
                //POST REQUEST HERE with USERNAME AND PASSWORD
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
                        //print(data)
                        self.setUpCurrentGradesHTML()
                        let doc2 = try SwiftSoup.parse(self.currentGradesHTML)
                        
                        var viewStateKey = try doc2.select("#__VIEWSTATE").first()!.attr("value")
                        var eventValidationKey = try doc2.select("#__EVENTVALIDATION").first()!.attr("value")
                        var MPData = [String:String]()
                        MPData["__EVENTTARGET"] =  "ctl00$plnMain$btnRefreshView"
                                       MPData["__EVENTARGUMENT"] =  ""
                                       MPData["__VIEWSTATE"] = viewStateKey
                                       MPData["__VIEWSTATEGENERATOR"] = "B0093F3C"
                                       MPData["__EVENTVALIDATION"] = eventValidationKey
                                       MPData["ctl00$plnMain$hdnValidMHACLicense"] =  "Y"
                                       MPData["ctl00$plnMain$hdnIsVisibleClsWrk"] = "N"
                                       MPData["ctl00$plnMain$hdnIsVisibleCrsAvg"] = "N"
                                       MPData["ctl00$plnMain$hdnJsAlert"] = "Averages cannot be displayed when  Report Card Run is set to (All Runs)."
                                       MPData["ctl00$plnMain$hdnTitle"] = "Classwork"
                                       MPData["ctl00$plnMain$hdnLastUpdated"] = "Last Updated"
                                       MPData["ctl00$plnMain$hdnDroppedCourse"] = "This course was dropped as of"
                                       MPData["ctl00$plnMain$hdnddlClasses"] = "(All Classes)"
                                       MPData["ctl00$plnMain$hdnddlCompetencies"] = "(All Classes)"
                                       MPData["ctl00$plnMain$hdnCompDateDue"] = "Date Due"
                                       MPData["ctl00$plnMain$hdnCompDateAssigned"] = "Date Assigned"
                                       MPData["ctl00$plnMain$hdnCompCourse"] = "Course"
                                       MPData["ctl00$plnMain$hdnCompAssignment"] = "Assignment"
                                       MPData["ctl00$plnMain$hdnCompAssignmentLabel"] = "Assignments Not Related to Any Competency"
                                       MPData["ctl00$plnMain$hdnCompNoAssignments"] = "No assignments found"
                                       MPData["ctl00$plnMain$hdnCompNoClasswork"] = "Classwork could not be found for this competency for the selected report card run."
                                       MPData["ctl00$plnMain$hdnCompScore"] = "Score"
                                       MPData["ctl00$plnMain$hdnCompPoints"] = "Points"
                                       MPData["ctl00$plnMain$hdnddlReportCardRuns1"] = "(All Runs)" //TODO: huh
                                       MPData["ctl00$plnMain$hdnddlReportCardRuns2"] = "(All Terms)"
                                       MPData["ctl00$plnMain$hdnbtnShowAverage"] = "Show All Averages"
                                       MPData["ctl00$plnMain$hdnShowAveragesToolTip"] = "Show all student's averages"
                                       MPData["ctl00$plnMain$hdnPrintClassworkToolTip"] = "Print all classwork"
                                       MPData["ctl00$plnMain$hdnPrintClasswork"] = "Print Classwork"
                                       MPData["ctl00$plnMain$hdnCollapseToolTip"] = "Collapse all courses"
                                       MPData["ctl00$plnMain$hdnCollapse"] = "Collapse All"
                                       MPData["ctl00$plnMain$hdnFullToolTip"] = "Switch courses to Full View"
                                       MPData["ctl00$plnMain$hdnViewFull"] = "Full View"
                                       MPData["ctl00$plnMain$hdnQuickToolTip"] = "Switch courses to Quick View"
                                       MPData["ctl00$plnMain$hdnViewQuick"] = "Quick View"
                                       MPData["ctl00$plnMain$hdnExpand"] = "Expand All"
                                       MPData["ctl00$plnMain$hdnExpandToolTip"] = "Expand all courses"
                                       MPData["ctl00$plnMain$hdnChildCompetencyMessage"] = "This competency is calculated as an average of the following competencies"
                                       MPData["ctl00$plnMain$hdnCompetencyScoreLabel"] = "Grade"
                                       MPData["ctl00$plnMain$hdnAverageDetailsDialogTitle"] = "Average Details"
                                       MPData["ctl00$plnMain$hdnAssignmentCompetency"] = "Assignment Competency"
                                       MPData["ctl00$plnMain$hdnAssignmentCourse"] = "Assignment Course"
                                       MPData["ctl00$plnMain$hdnTooltipTitle"] = "Title"
                                       MPData["ctl00$plnMain$hdnCategory"] = "Category"
                                       MPData["ctl00$plnMain$hdnDueDate"] = "Due Date"
                                       MPData["ctl00$plnMain$hdnMaxPoints"] = "Max Points"
                                       MPData["ctl00$plnMain$hdnCanBeDropped"] = "Can Be Dropped"
                                       MPData["ctl00$plnMain$hdnHasAttachments"] = "Has Attachments"
                                       MPData["ctl00$plnMain$hdnExtraCredit"] = "Extra Credit"
                                       MPData["ctl00$plnMain$hdnType"] = "Type"
                                     MPData["ctl00$plnMain$hdnAssignmentDataInfo"] = "Information could not be found for the assignment"
                                        MPData["ctl00$plnMain$ddlReportCardRuns"] = "\(mp)-2023" //TODO: maybe not 2022 always, check
                                        MPData["ctl00$plnMain$ddlClasses"] = "ALL"
                                        MPData["ctl00$plnMain$ddlCompetencies"] = "ALL"
                                        MPData["ctl00$plnMain$ddlOrderBy"] = "Class"
                        AF.request("https://hac.friscoisd.org/HomeAccess/Content/Student/Assignments.aspx", method: .post, parameters: MPData, encoding: URLEncoding()).response { response in
                            let data1 = String(data: response.data!, encoding: .utf8)
                            completion(data1!)
                            print("HAD TO LOGIN")
                        }
                    }
                    catch{
                        
                    }
                }
            }
            else{//GET GRADES FROM MP HERE
            let doc2 = try SwiftSoup.parse(currentGradesHTML)
            
            var viewStateKey = try doc2.select("#__VIEWSTATE").first()!.attr("value")
            var eventValidationKey = try doc2.select("#__EVENTVALIDATION").first()!.attr("value")
            var MPData = [String:String]()
            MPData["__EVENTTARGET"] =  "ctl00$plnMain$btnRefreshView"
                           MPData["__EVENTARGUMENT"] =  ""
                           MPData["__VIEWSTATE"] = viewStateKey
                           MPData["__VIEWSTATEGENERATOR"] = "B0093F3C"
                           MPData["__EVENTVALIDATION"] = eventValidationKey
                           MPData["ctl00$plnMain$hdnValidMHACLicense"] =  "Y"
                           MPData["ctl00$plnMain$hdnIsVisibleClsWrk"] = "N"
                           MPData["ctl00$plnMain$hdnIsVisibleCrsAvg"] = "N"
                           MPData["ctl00$plnMain$hdnJsAlert"] = "Averages cannot be displayed when  Report Card Run is set to (All Runs)."
                           MPData["ctl00$plnMain$hdnTitle"] = "Classwork"
                           MPData["ctl00$plnMain$hdnLastUpdated"] = "Last Updated"
                           MPData["ctl00$plnMain$hdnDroppedCourse"] = "This course was dropped as of"
                           MPData["ctl00$plnMain$hdnddlClasses"] = "(All Classes)"
                           MPData["ctl00$plnMain$hdnddlCompetencies"] = "(All Classes)"
                           MPData["ctl00$plnMain$hdnCompDateDue"] = "Date Due"
                           MPData["ctl00$plnMain$hdnCompDateAssigned"] = "Date Assigned"
                           MPData["ctl00$plnMain$hdnCompCourse"] = "Course"
                           MPData["ctl00$plnMain$hdnCompAssignment"] = "Assignment"
                           MPData["ctl00$plnMain$hdnCompAssignmentLabel"] = "Assignments Not Related to Any Competency"
                           MPData["ctl00$plnMain$hdnCompNoAssignments"] = "No assignments found"
                           MPData["ctl00$plnMain$hdnCompNoClasswork"] = "Classwork could not be found for this competency for the selected report card run."
                           MPData["ctl00$plnMain$hdnCompScore"] = "Score"
                           MPData["ctl00$plnMain$hdnCompPoints"] = "Points"
                           MPData["ctl00$plnMain$hdnddlReportCardRuns1"] = "(All Runs)" //TODO: huh
                           MPData["ctl00$plnMain$hdnddlReportCardRuns2"] = "(All Terms)"
                           MPData["ctl00$plnMain$hdnbtnShowAverage"] = "Show All Averages"
                           MPData["ctl00$plnMain$hdnShowAveragesToolTip"] = "Show all student's averages"
                           MPData["ctl00$plnMain$hdnPrintClassworkToolTip"] = "Print all classwork"
                           MPData["ctl00$plnMain$hdnPrintClasswork"] = "Print Classwork"
                           MPData["ctl00$plnMain$hdnCollapseToolTip"] = "Collapse all courses"
                           MPData["ctl00$plnMain$hdnCollapse"] = "Collapse All"
                           MPData["ctl00$plnMain$hdnFullToolTip"] = "Switch courses to Full View"
                           MPData["ctl00$plnMain$hdnViewFull"] = "Full View"
                           MPData["ctl00$plnMain$hdnQuickToolTip"] = "Switch courses to Quick View"
                           MPData["ctl00$plnMain$hdnViewQuick"] = "Quick View"
                           MPData["ctl00$plnMain$hdnExpand"] = "Expand All"
                           MPData["ctl00$plnMain$hdnExpandToolTip"] = "Expand all courses"
                           MPData["ctl00$plnMain$hdnChildCompetencyMessage"] = "This competency is calculated as an average of the following competencies"
                           MPData["ctl00$plnMain$hdnCompetencyScoreLabel"] = "Grade"
                           MPData["ctl00$plnMain$hdnAverageDetailsDialogTitle"] = "Average Details"
                           MPData["ctl00$plnMain$hdnAssignmentCompetency"] = "Assignment Competency"
                           MPData["ctl00$plnMain$hdnAssignmentCourse"] = "Assignment Course"
                           MPData["ctl00$plnMain$hdnTooltipTitle"] = "Title"
                           MPData["ctl00$plnMain$hdnCategory"] = "Category"
                           MPData["ctl00$plnMain$hdnDueDate"] = "Due Date"
                           MPData["ctl00$plnMain$hdnMaxPoints"] = "Max Points"
                           MPData["ctl00$plnMain$hdnCanBeDropped"] = "Can Be Dropped"
                           MPData["ctl00$plnMain$hdnHasAttachments"] = "Has Attachments"
                           MPData["ctl00$plnMain$hdnExtraCredit"] = "Extra Credit"
                           MPData["ctl00$plnMain$hdnType"] = "Type"
                         MPData["ctl00$plnMain$hdnAssignmentDataInfo"] = "Information could not be found for the assignment"
                            MPData["ctl00$plnMain$ddlReportCardRuns"] = "\(mp)-2023" //TODO: maybe not 2022 always, check
                            MPData["ctl00$plnMain$ddlClasses"] = "ALL"
                            MPData["ctl00$plnMain$ddlCompetencies"] = "ALL"
                            MPData["ctl00$plnMain$ddlOrderBy"] = "Class"
            AF.request("https://hac.friscoisd.org/HomeAccess/Content/Student/Assignments.aspx", method: .post, parameters: MPData, encoding: URLEncoding()).response { response in
                let data1 = String(data: response.data!, encoding: .utf8)
                completion(data1!)
                print("NO LOGIN")
            }
            }
            
        }
        catch {
            
        }
    }
    func getNewHTMl(mp: String, isRefresh: Bool, completion: @escaping (String) -> Void) {
        if isRefresh == true {
            getFiles(mp: mp) {
                response in
                UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username"))MP:\(mp)")
                if mp == self.currentMP {
                    self.currentGradesHTML = response
                    UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)currentGrades")
                }
                completion(response)
            }
            
        }
        if mp == currentMP {
            completion(currentGradesHTML)
        }
        else if UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username"))MP:\(mp)") != nil {
            print("Already Saved String")
          completion(UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username"))MP:\(mp)") as! String)
        }
        else{
            getFiles(mp: mp) {
                response in
                UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username"))MP:\(mp)")
                completion(response)
            }
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
            var mp = MPButton.title!
            var array = Array(mp)
            array.remove(at: 0)
            array.remove(at: 0)
            mp = String(array)
            self.getNewHTMl(mp: mp, isRefresh: true) {
                response in
                
                for button in self.arrayOfButtons {
                    button.removeFromSuperview()
                }
                self.arrayOfButtons.removeAll()
                self.arrayOfClassNames.removeAll()
                self.arrayOfGrades.removeAll()
                self.dict.removeAll()
                for label in self.arrayOfLabels {
                    label.removeFromSuperview()
                }
                self.arrayOfLabels.removeAll()
                self.ypos = 0.0
                self.contentViewSize.height = self.getScrollHeight(HTML: response) + 100
                self.scrollView.contentSize = self.contentViewSize
                self.containerView.frame.size = self.contentViewSize
                self.display(html: response)
                // Code to refresh table view
                self.refreshControl.endRefreshing()
            }
            
            

        }

}


