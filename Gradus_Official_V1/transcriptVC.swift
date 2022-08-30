//
//  transcriptVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/28/22.
//

import UIKit
import SwiftSoup
import Alamofire
class transcriptVC: UIViewController {


    var transcriptHTML = UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)transcript") as? String 
    var transcriptYears = [transcriptYear]()
    var testLabel = UILabel()
    var arrayOfButtons = [UIButton]()
    var rankLabel = UILabel()
    var dict = [String: transcriptYear]()
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
        
        view.backgroundColor = .white
        view.addSubview(containerView)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        testLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 49))
        
        testLabel.center.x = self.containerView.center.x
        testLabel.center.y = 10
        testLabel.textAlignment = .center
        
        testLabel.font = testLabel.font.withSize(41)
        containerView.addSubview(testLabel)
        setUp(HTML: transcriptHTML as! String)
        
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
            
            getTranscriptHTML(){
                response in
                for button in self.arrayOfButtons {
                    button.removeFromSuperview()
                }
                print(self.arrayOfButtons.count)
                self.arrayOfButtons.removeAll()
                self.transcriptYears.removeAll()
                print(self.arrayOfButtons.count)
                self.dict.removeAll()
                self.setUp(HTML: response)
                UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)transcript")
                self.refreshControl.endRefreshing()
            }
            
            

        }
    /*
    override func viewDidAppear(_ animated: Bool) {
        GradesLoadingOverlay.shared.showOverlay(view: self.containerView)

        
        self.getTranscriptHTML(){
            response in
            
            UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)transcript")
            for button in self.arrayOfButtons {
                button.removeFromSuperview()
            }
            self.arrayOfButtons.removeAll()
            self.transcriptYears.removeAll()

            self.dict.removeAll()
            self.setUp(HTML: response)
            GradesLoadingOverlay.shared.hideOverlayView()
        }
    }
    */
    func getTranscriptHTML(completion: @escaping (String) -> Void) {
        
        let Demographics = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Registration.aspx")
        var DemograhpicsHTML:String = ""
        let transcriptURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Transcript.aspx")
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
                        print("LOGIN REQUIRED")
                        completion(try String(contentsOf: transcriptURL!, encoding: .ascii))
                    }
                    catch{
                        
                    }
                }
            }
            else {
                completion(try String(contentsOf: transcriptURL!, encoding: .ascii))
                print("NO LOGIN")
            }
        }
        catch {
            
        }
    }
    func readyButtons(displayMultiplier: CGFloat) {
        if transcriptYears.count == 0 {
            
        }
        else {
            
            for i in 0..<transcriptYears.count {
                
                let nameButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                nameButton.layer.cornerRadius = 10
                var array = transcriptYears[i].building.components(separatedBy: " ")
                var charArray = [Character]()
                for element in array {
                    var temp = Array(element)
                    charArray.append(temp[0])
                }
                let building = String(charArray).uppercased()
                var title = "Grade: \(transcriptYears[i].grade) Building: \(building)"
                dict[title] = transcriptYears[i]
                nameButton.setTitle(title, for: .normal)
                nameButton.backgroundColor = .link
                nameButton.contentHorizontalAlignment = .center
                nameButton.setTitleColor(.white, for: .normal)
                nameButton.layer.cornerRadius = 20
                nameButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                containerView.addSubview(nameButton)
                if arrayOfButtons.count == 0 {
                    
                    nameButton.translatesAutoresizingMaskIntoConstraints = false
                    //gradeLabel.translatesAutoresizingMaskIntoConstraints = false
                    let leftConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
                    let rightConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0.0)
                    let topConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .topMargin, relatedBy: .equal, toItem: testLabel, attribute: .bottomMargin, multiplier: 2, constant: 0.0)
                
                    //let leftConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .leftMargin, relatedBy: .equal, toItem: nameButton, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
                    //let rightConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0.0)
                    //let topConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .topMargin, relatedBy: .equal, toItem: testLabel, attribute: .bottomMargin, multiplier: 2, constant: 0.0)
                    view.addConstraints([leftConstraint1, rightConstraint1, topConstraint1])
                }
                else if arrayOfButtons.count != 0 {
                    nameButton.translatesAutoresizingMaskIntoConstraints = false
                
                    let leftConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
                    let rightConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0.0)
                    let topConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .topMargin, relatedBy: .equal, toItem: arrayOfButtons[arrayOfButtons.count - 1], attribute: .bottomMargin, multiplier: displayMultiplier, constant: 0.0)
                
                    view.addConstraints([leftConstraint1, rightConstraint1, topConstraint1])
                }
                arrayOfButtons.append(nameButton)
                if transcriptYears.count-1 == i {
                    do {
                        let doc3 = try SwiftSoup.parse(transcriptHTML!)
                        var rank:String = ""
                        rank = try doc3.select("#plnMain_rpTranscriptGroup_lblGPARank1").text()
                        var unweightedGPA = try doc3.select("span#plnMain_rpTranscriptGroup_lblGPACum2").text()
                        var weightedGPA = try doc3.select("span#plnMain_rpTranscriptGroup_lblGPACum1").text()
                        let button = UIButton()
                        button.contentVerticalAlignment = .center
                        button.layer.cornerRadius = 20
                        button.titleLabel?.numberOfLines = 3
                        
                        let multilineString = """
                        Rank: \(rank)
                        Weighted GPA: \(weightedGPA)
                        Unweighted GPA: \(unweightedGPA)
                        """
                        button.setTitle(multilineString, for: .normal)
                        button.backgroundColor = .link
                        button.contentHorizontalAlignment = .center
                        button.setTitleColor(.black, for: .normal)
                        button.setTitleColor(.white, for: .normal)
                        containerView.addSubview(button)
                        button.translatesAutoresizingMaskIntoConstraints = false
                    
                        let leftConstraint1 = NSLayoutConstraint(item: button, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
                        let rightConstraint1 = NSLayoutConstraint(item: button, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0.0)
                        let topConstraint1 = NSLayoutConstraint(item: button, attribute: .topMargin, relatedBy: .equal, toItem: arrayOfButtons[arrayOfButtons.count - 1], attribute: .bottomMargin, multiplier: displayMultiplier, constant: 0.0)
                    
                        view.addConstraints([leftConstraint1, rightConstraint1, topConstraint1])
                        arrayOfButtons.append(button)
                    }
                    catch {
                        
                    }
                }
            }
            
        }
    }
    @objc func buttonAction(sender:UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let Homevc : transcriptSpecificVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "transcriptSpecific") as! transcriptSpecificVC
        Homevc.transcriptyear = dict[sender.titleLabel!.text!]!
        self.present(Homevc, animated: true, completion: nil)
      }

    func setUp(HTML: String) {
        do{
            let doc3:Document = try SwiftSoup.parse(HTML)
            let array = try doc3.select("td.sg-transcript-group")
            var a = 0
            for element in array{
                var arrayOfGPAAndRank = [String]()
                var arrayOfCourses = [String]() //course ID
                var arrayOfDescriptions = [String]() //course Name
                var arrayOfSem1Grades = [String]() // Sem 1 Grades
                var arrayOfSem2Grades = [String]() //Sem 2 Grades
                var arrayOfFinGrades = [String]() // Final Grades
                var arrayOfCredits = [String]()
                let tempDataTables = try element.select("tr.sg-asp-table-data-row").select("td")
                for i in 0..<tempDataTables.count{
                    if (i%6==0){
                        arrayOfCourses.append(try tempDataTables[i].text())
                        arrayOfDescriptions.append(try tempDataTables[i+1].text())
                        arrayOfSem1Grades.append(try tempDataTables[i+2].text())
                        arrayOfSem2Grades.append(try tempDataTables[i+3].text())
                        arrayOfFinGrades.append(try tempDataTables[i+4].text())
                        arrayOfCredits.append(try tempDataTables[i+5].text())
                    }
                }
                var buildingStr = "#plnMain_rpTranscriptGroup_lblBuildingValue_\(a)"
                var yearStr = "#plnMain_rpTranscriptGroup_lblYearValue_\(a)"
                var gradeStr = "#plnMain_rpTranscriptGroup_lblGradeValue_\(a)"
                
                let building = try element.select(buildingStr).text()
                let grade = try element.select(gradeStr).text()
                let year = try element.select(yearStr).text()
                
                var tempTransYear = transcriptYear(grade: grade, building: building, years: year, arrayOfCourses: arrayOfCourses, arrayOfDescriptions: arrayOfDescriptions, arrayOfSem1Grades: arrayOfSem1Grades, arrayOfSem2Grades: arrayOfSem2Grades, arrayOfFinGrades: arrayOfFinGrades, arrayOfCredits: arrayOfCredits)
                a+=1
                self.transcriptYears.append(tempTransYear)
            }
             
        }
        catch {
            
        }
        let height = view.frame.height
        var displayMultiplier = 2.0
        if height >= 800 {
            displayMultiplier = 3.0
        }
        else if height >= 700 {
            displayMultiplier = 2.5
        }
        else {
            displayMultiplier = 2.0
        }
        readyButtons(displayMultiplier: displayMultiplier)
    }
    
    

}
