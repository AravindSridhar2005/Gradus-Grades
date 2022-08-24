//
//  progressReportVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/29/22.
//

import UIKit
import DropDown
import SwiftSoup
import Alamofire
class progressReportVC: UIViewController {
    var yPos = 0.0
    var currentDate = ""
    var progressReportHTML = UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)ProgressReport") as? String ?? ""
    var arrayOfIPRObjects = [iprObject]()
    var arrayOfButtons = [UIButton]()
    var arrayOfLabels = [UILabel]()
    var isProgressReportHere = true
    var menu: DropDown {
        let menu = DropDown()
        if isProgressReportHere {
            do {
                let docIPR = try SwiftSoup.parse(progressReportHTML)
                let rand = try docIPR.select("#plnMain_ddlIPRDates").text()
            
                menu.dataSource = rand.components(separatedBy: " ")
            
            }
            catch {
            
            }
            menu.anchorView = selectedButton
            menu.selectionAction = {
                index, title in
                let date = title
                self.selectedButton.title = title
               
        
                self.getNewHTMl(dates: date, isRefresh: false) {
                    response in
                    for button in self.arrayOfButtons {
                        button.removeFromSuperview()
                    }
                    for label in self.arrayOfLabels {
                        label.removeFromSuperview()
                    }
                    self.arrayOfLabels.removeAll()
                    self.arrayOfIPRObjects.removeAll()
                    self.arrayOfButtons.removeAll()
                    self.yPos = 0.0

                    self.contentViewSize.height = self.getScrollingHeight(HTML: response) + 20
                    self.scrollView.contentSize = self.contentViewSize
                    self.containerView.frame.size = self.contentViewSize
                    self.setUp(HTML: response)
                    self.readyLabels()
                    self.refreshControl.endRefreshing()

                }
           
            }
        }
        return menu
    }
    
    @IBOutlet weak var selectedButton: UIBarButtonItem!
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: getScrollingHeight(HTML: progressReportHTML) + 20)
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
    func getScrollingHeight(HTML: String) -> CGFloat {
        var height = 0.0
        do {
            let docIPR = try SwiftSoup.parse(HTML)
            var elem = try docIPR.select("tr.sg-asp-table-data-row")
            height = 50.0 * Double(elem.count)
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
        do {
            let doc = try SwiftSoup.parse(progressReportHTML ?? "")
            let label = try doc.select("#plnMain_lblMessage").text()
            if label == "This student does not have any Interim Progress Reports for this school year." {
                isProgressReportHere = false
                selectedButton.title = ""
            }
            let viewStateKey = try doc.select("#__VIEWSTATE").get(0).attr("value")
            let eventValidationKey = try doc.select("#__EVENTVALIDATION").get(0).attr("value")
            print(viewStateKey)
            print("HELLO")
            print(eventValidationKey)
        
        }
        catch {
        
        }
        if isProgressReportHere {
            do {
                let docIPR = try SwiftSoup.parse(progressReportHTML)
                let rand = try docIPR.select("#plnMain_ddlIPRDates").select("option")
                for element in rand {
                    if element.hasAttr("selected") {
                        currentDate = try element.text()
                    }
                }
            }
            catch {
            
            }
            var periodLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.15, height: 20.0))
            periodLabel.text = "Period"
        
            periodLabel.textAlignment = .center
            containerView.addSubview(periodLabel)
            var courseLabel = UILabel(frame: CGRect(x: view.frame.width * 0.2, y: 0, width: view.frame.width * 0.6, height: 20.0))
            courseLabel.text = "Course Name"
            courseLabel.textAlignment = .center
            containerView.addSubview(courseLabel)
            var gradeLabel = UILabel(frame: CGRect(x: view.frame.width * 0.85, y: 0, width: view.frame.width * 0.15, height: 20.0))
            gradeLabel.text = "Grade"
            
            gradeLabel.textAlignment = .center
            containerView.addSubview(gradeLabel)
            selectedButton.title = currentDate
            setUp(HTML: progressReportHTML)
            readyLabels()
        }
    }
    
    func readyLabels() {
        
        for i in 0..<arrayOfIPRObjects.count {
            yPos+=50
            let button = UIButton(frame: CGRect(x: 0, y: yPos, width: view.frame.width, height: 30.0))
            button.layer.cornerRadius = 20
            button.backgroundColor = .link
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            arrayOfButtons.append(button)
            containerView.addSubview(button)
            let periodLabel = UILabel(frame: CGRect(x: 0, y: yPos, width: view.frame.width * 0.15, height: 30.0))
            periodLabel.text = arrayOfIPRObjects[i].period
            periodLabel.textAlignment = .center
            periodLabel.textColor = .white
            containerView.addSubview(periodLabel)
            let courseLabel = UILabel(frame: CGRect(x: view.frame.width * 0.2, y: yPos, width: view.frame.width * 0.6, height: 30.0))
            courseLabel.text = arrayOfIPRObjects[i].description
            courseLabel.textAlignment = .center
            courseLabel.textColor = .white

            containerView.addSubview(courseLabel)
            let gradeLabel = UILabel(frame: CGRect(x: view.frame.width * 0.85, y: yPos, width: view.frame.width * 0.15, height: 30.0))
            gradeLabel.text = arrayOfIPRObjects[i].score
            gradeLabel.textAlignment = .center
            gradeLabel.textColor = .white
            containerView.addSubview(gradeLabel)
            arrayOfLabels.append(contentsOf: [gradeLabel, periodLabel, courseLabel])
        }
    }
    @objc func buttonAction(sender:UIButton!) {
        
        if arrayOfButtons.contains(sender) {
            var i = arrayOfButtons.firstIndex(of: sender)!
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IPRPopOver") as! IPRPopOverVC
            popOverVC.iprobj = arrayOfIPRObjects[i]
            self.addChild(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
            
        }
        
      }
    func setUp(HTML: String) {
        do {
            let docIPR = try SwiftSoup.parse(HTML)
            var elem = try docIPR.select("tr.sg-asp-table-data-row")
            for elements in elem {
            
                var rand = try elements.select("td")
                if rand.count == 11 {
                    var clas = iprObject(course: try rand[0].text(), description: try rand[1].text(), period: try rand[2].text(), teacher: try rand[3].text(), room: try rand[4].text(), score: try rand[5].text(), absences: try rand[9].text(), tardies: try rand[10].text())
                    arrayOfIPRObjects.append(clas)
                    
                }
                
            }
        }
        catch {
            
        }
        
    }
    
    
    func getFiles(dates: String, completion: @escaping (String) -> Void){
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
                        let docIPR = try SwiftSoup.parse(self.progressReportHTML)
                        let viewstate = try docIPR.select("#__VIEWSTATE").first()!.attr("value")
                        let eventValidation = try docIPR.select("#__EVENTVALIDATION").first()!.attr("value")
                        var iprData = [String: String]()
                        iprData["__EVENTTARGET"] = "ctl00$plnMain$ddlIPRDates"
                        iprData["__EVENTARGUMENT"] = ""
                        iprData["__LASTFOCUS"] = ""
                        iprData["__VIEWSTATE"] = viewstate
                        iprData["__VIEWSTATEGENERATOR"] = "19DE7394"
                        iprData["__EVENTVALIDATION"] = eventValidation
                        iprData["ctl00$plnMain$hdnTitle"] = "Interim Progress Report For "
                        var dates1 = Array(dates)
                        if dates1[3] == "0" {
                            var i = dates1.index(0, offsetBy: 3)
                            var removed = dates1.remove(at: i)
                        }
                        if dates1[0] == "0" {
                            var i = dates1.index(0, offsetBy: 0)
                            var removed = dates1.remove(at: i)
                        }
                        iprData["ctl00$plnMain$ddlIPRDates"] = "\(dates1) 12:00:00 AM"
                        iprData["ctl00$plnMain$hdnMessage"] = "Interim Progress information could not be found for this date."
                        iprData["ctl00$plnMain$hdnMessage1"] = "This student does not have any Interim Progress Reports for this school year."
                        iprData["ctl00$plnMain$hdnTitleNoRecord"] = "Interim Progress Report"
                        AF.request("https://hac.friscoisd.org/HomeAccess/Content/Student/InterimProgress.aspx", method: .post, parameters: iprData, encoding: URLEncoding()).response { response in
                            let data1 = String(data: response.data!, encoding: .utf8)
                            completion(data1!)
                            print("HAD TO LOGIN")
                            }
                    }
                    catch {
                        
                    }
                }
            }
            else{//GET GRADES FROM MP HERE
                do {
                    let docIPR = try SwiftSoup.parse(progressReportHTML)
                    let viewstate = try docIPR.select("#__VIEWSTATE").first()!.attr("value")
                    let eventValidation = try docIPR.select("#__EVENTVALIDATION").first()!.attr("value")
                    var iprData = [String: String]()
                    iprData["__EVENTTARGET"] = "ctl00$plnMain$ddlIPRDates"
                    iprData["__EVENTARGUMENT"] = ""
                    iprData["__LASTFOCUS"] = ""
                    iprData["__VIEWSTATE"] = viewstate
                    iprData["__VIEWSTATEGENERATOR"] = "19DE7394"
                    iprData["__EVENTVALIDATION"] = eventValidation
                    iprData["ctl00$plnMain$hdnTitle"] = "Interim Progress Report For "
                    var dates1 = Array(dates)
                    if dates1[3] == "0" {
                        let i = dates1.index(0, offsetBy: 3)
                        let removed = dates1.remove(at: i)
                    }
                    if dates1[0] == "0" {
                        let i = dates1.index(0, offsetBy: 0)
                        let removed = dates1.remove(at: i)
                    }
                    let dates2 = String(dates1)
                    iprData["ctl00$plnMain$ddlIPRDates"] = "\(dates2) 12:00:00 AM"
                    iprData["ctl00$plnMain$hdnMessage"] = "Interim Progress information could not be found for this date."
                    iprData["ctl00$plnMain$hdnMessage1"] = "This student does not have any Interim Progress Reports for this school year."
                    iprData["ctl00$plnMain$hdnTitleNoRecord"] = "Interim Progress Report"
                    AF.request("https://hac.friscoisd.org/HomeAccess/Content/Student/InterimProgress.aspx", method: .post, parameters: iprData, encoding: URLEncoding()).response { response in
                        let data1 = String(data: response.data!, encoding: .utf8)
                        completion(data1!)
                        print("NO LOGIN")
                        }
                }
                catch {
                    
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
            let date = selectedButton.title
            
            
    
            self.getNewHTMl(dates: date!, isRefresh: true) {
                response in
                for button in self.arrayOfButtons {
                    button.removeFromSuperview()
                }
                for label in self.arrayOfLabels {
                    label.removeFromSuperview()
                }
                self.arrayOfLabels.removeAll()
                self.arrayOfIPRObjects.removeAll()
                self.arrayOfButtons.removeAll()
                self.yPos = 0.0
                self.contentViewSize.height = self.getScrollingHeight(HTML: response) + 20
                self.scrollView.contentSize = self.contentViewSize
                self.containerView.frame.size = self.contentViewSize
                self.setUp(HTML: response)
                self.readyLabels()
                self.refreshControl.endRefreshing()

            }
        }
    func getNewHTMl(dates: String, isRefresh: Bool, completion: @escaping (String) -> Void)  {
        
        if isRefresh == true {
            getFiles(dates: dates) {
                response in
                UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username"))PR:\(dates)")
                if dates == self.currentDate {
                    self.progressReportHTML = response
                    UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)ProgressReport")
                }
                completion(response)
            }
            
            
        }
        if dates == currentDate {
            completion(progressReportHTML)
        }
        else if UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username"))PR:\(dates)") != nil {
          completion(UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username"))PR:\(dates)") as! String)
        }
        else {
            getFiles(dates: dates) {
                response in
                UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username"))PR:\(dates)")
                completion(response)
            }
            
        }
         
    }
    
    @IBAction func didTapNavButton(_ sender: Any) {
        menu.show()
    }
    
}
