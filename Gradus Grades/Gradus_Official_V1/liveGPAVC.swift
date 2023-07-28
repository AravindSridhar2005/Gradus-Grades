//
//  liveGPAVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/31/22.
//

import UIKit
import SwiftSoup
import Alamofire
class liveGPAVC: UIViewController {
    
    
    var transcriptHTML = UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)transcript") as? String
    var currentGradesHTML = UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)currentGrades") as? String ?? ""
    var transcriptGPAString = UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)weightedGPA") as? String
    var transcriptYears = [transcriptYear]()
    var classList = [String: Double]()
    var displayLabel = UILabel()
    var currentMP = ""
    private var viewDidAppearQueue: [() -> ()] = []
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
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: view.frame.height)
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
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        
        floatingButton.frame = CGRect(x: view.frame.size.width - 75, y: 75, width: 50, height: 50)
        var rightNavBarButton = UIBarButtonItem(customView:floatingButton)
         self.navigationItem.leftBarButtonItem = rightNavBarButton
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        currentMP = setCurrentMP(HTML: currentGradesHTML)
        initializeDictionary()
        var transcriptGPA: Double = 0.0
        if transcriptGPAString == nil {
            getTranscriptHTML() {
                response in
               // print(self.currentGradesHTML)
                print(self.currentGradesHTML)
                UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)transcript")
                self.transcriptHTML = response
                self.updateTranscriptGPA(HTML: response)
                self.currentMP = self.setCurrentMP(HTML: self.currentGradesHTML)
                //self.currentMP = "1"
                print(self.currentMP)
                print("NIG")
                print("HELLO")
                if self.transcriptGPAString != "" {
                    print(self.transcriptGPAString)
                    transcriptGPA = Double(self.transcriptGPAString!)!
                }
                    var liveGPA = 0.0
                if self.currentMP == "1" || self.currentMP == "3" {
                    liveGPA = self.generateLiveGpa13(currentGradesHTML: self.currentGradesHTML, transcriptGPA: transcriptGPA, refresh: false)
                    liveGPA = round(liveGPA * 1000.0) / 1000.0
                    print(liveGPA)
                    }
                else if self.currentMP == "2" || self.currentMP == "4" {
                    liveGPA = self.generateLiveGpa24(currentGradesHTML:  self.currentGradesHTML, transcriptGPA: transcriptGPA, refresh: false)
                        liveGPA = round(liveGPA * 1000.0) / 1000.0
                    print(transcriptGPA)
                    }
                print(liveGPA)
                self.displayLabel = UILabel(frame: CGRect(x: self.containerView.frame.width * 0.1, y: self.containerView.frame.height * 0.2, width:    self.view.frame.width * 0.8, height: 150))
                self.displayLabel.backgroundColor = .systemGray5
                self.displayLabel.text = "\(liveGPA)"
                self.displayLabel.font = UIFont(name:"ArialRoundedMTBold", size: 60.0)
                self.displayLabel.layer.cornerRadius = 15
                self.displayLabel.textAlignment = .center
                self.containerView.addSubview(self.displayLabel)
                
                
                
                self.viewDidAppearQueue.append {
                    GradesLoadingOverlay.shared.showOverlay(view: self.containerView)
                        self.getGradestHTML() {
                        response in
                            self.currentMP = self.setCurrentMP(HTML: response)
                            UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username")     as! String)currentGrades")
                            var transcriptGPA: Double = 0.0
                            if  self.transcriptGPAString != "" {
                                transcriptGPA = Double(self.transcriptGPAString!)!
                            }
                            var liveGPA = 0.0
                            if self.currentMP == "1" || self.currentMP == "3" {
                                liveGPA = self.generateLiveGpa13(currentGradesHTML:     response, transcriptGPA: transcriptGPA , refresh: false)
                                liveGPA = round(liveGPA * 1000.0) / 1000.0
                            }
                            if self.currentMP == "2" || self.currentMP == "4" {
                                liveGPA = self.generateLiveGpa24(currentGradesHTML:     self.currentGradesHTML, transcriptGPA:  transcriptGPA, refresh: false)
                                liveGPA = round(liveGPA * 1000.0) / 1000.0
                            }
                            self.displayLabel.text = "\(liveGPA)"
                        
                            GradesLoadingOverlay.shared.hideOverlayView()

                        }
                    }
            }
        }
        else {
        if transcriptGPAString != "" {
            print(transcriptGPAString)
            transcriptGPA = Double(transcriptGPAString!)!
        }
            var liveGPA = 0.0
            if currentMP == "1" || currentMP == "3" {
            liveGPA = generateLiveGpa13(currentGradesHTML: currentGradesHTML, transcriptGPA: transcriptGPA, refresh: false)
            liveGPA = round(liveGPA * 1000.0) / 1000.0
            }
            if currentMP == "2" || currentMP == "4" {
                liveGPA = generateLiveGpa24(currentGradesHTML:  currentGradesHTML, transcriptGPA: transcriptGPA, refresh: false)
                liveGPA = round(liveGPA * 1000.0) / 1000.0
            }
            displayLabel = UILabel(frame: CGRect(x: containerView.frame.width * 0.1, y: containerView.frame.height * 0.2, width:    view.frame.width * 0.8, height: 150))
            displayLabel.backgroundColor = .systemGray5
            displayLabel.text = "\(liveGPA)"
            displayLabel.font = UIFont(name:"ArialRoundedMTBold", size: 60.0)
            displayLabel.layer.cornerRadius = 15
            displayLabel.textAlignment = .center
            containerView.addSubview(displayLabel)
        
        
        
            viewDidAppearQueue.append {
            GradesLoadingOverlay.shared.showOverlay(view: self.containerView)
                self.getGradestHTML() {
                response in
                    self.currentMP = self.setCurrentMP(HTML: response)
                    UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username")     as! String)currentGrades")
                    var transcriptGPA: Double = 0.0
                    if  self.transcriptGPAString != "" {
                        transcriptGPA = Double(self.transcriptGPAString!)!
                    }
                    var liveGPA = 0.0
                    if self.currentMP == "1" || self.currentMP == "3" {
                        liveGPA = self.generateLiveGpa13(currentGradesHTML:     response, transcriptGPA: transcriptGPA , refresh: false)
                        liveGPA = round(liveGPA * 1000.0) / 1000.0
                    }
                    if self.currentMP == "2" || self.currentMP == "4" {
                        liveGPA = self.generateLiveGpa24(currentGradesHTML:     self.currentGradesHTML, transcriptGPA:  transcriptGPA, refresh: false)
                        liveGPA = round(liveGPA * 1000.0) / 1000.0
                    }
                    self.displayLabel.text = "\(liveGPA)"
                
                    GradesLoadingOverlay.shared.hideOverlayView()

                }
            }
        }
    }
    func updateTranscriptGPA(HTML: String) {
        do {
            let doc = try SwiftSoup.parse(HTML)
            transcriptGPAString = try doc.select("span#plnMain_rpTranscriptGroup_lblGPACum1").text()
            UserDefaults.standard.set(transcriptGPAString, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)weightedGPA")
        }
        catch {
            
        }
    }
    func generateLiveGpa24(currentGradesHTML: String, transcriptGPA: Double, refresh: Bool) -> Double {
        var liveGPA = transcriptGPA
        var numCredits = getTranscriptCredits(HTML: transcriptHTML!)
        print(numCredits)
        var totalGPA = 2 * round(numCredits * transcriptGPA * 10000.0) / 10000.0
        var newGPA = 0.0
        var newCredits = 0.0
        var numClasses = 0.0
        if currentMP == "2" || currentMP == "4" {
            getNewHTMl(mp: currentMP, isRefresh: false) {
                response in
                print(response)
                var randDict = self.getGradesAndClasses(HTML: response)
           
            var arrayOfClassNamesCurrent = randDict[0]
            var arrayOfGradesCurrent = randDict[1]
            
            var mp = "1"
                if self.currentMP == "4" {
                mp = "3"
            }
                self.getNewHTMl(mp: mp, isRefresh: refresh) { [self]
                response1 in
                var randDict2 = self.getGradesAndClasses(HTML: response1)
                
                let arrayOfClassNamesPrevious = randDict2[0]
                let arrayOfGradesPrevious = randDict2[1]
                for i in 0..<arrayOfClassNamesCurrent.count {
                    if !arrayOfClassNamesCurrent[i].contains("NO GPA"){
                    var gradeCurrent = 0.0
                    var gradePrevious = 0.0
                    var sum = 0.0
                    var isTrue = false
                        var tempCredits = 0.0
                        if arrayOfGradesCurrent[i] != ""{
                        isTrue = true
                            gradeCurrent = Double(arrayOfGradesCurrent[i])!
                            let array = self.calcClassGPA(className: arrayOfGradesCurrent[i], classGrade: gradeCurrent)
                        sum+=array[0]
                        tempCredits = array[1]
                    }
                        if arrayOfGradesPrevious[i] != ""{
                            gradePrevious = Double(arrayOfGradesPrevious[i])!
                            let array1 = self.calcClassGPA(className: arrayOfClassNamesPrevious[i], classGrade: gradePrevious)
                            sum+=array1[0]
                            tempCredits = array1[1]
                        }
                        if arrayOfGradesCurrent[i] != "" && arrayOfGradesPrevious[i] != "" {
                            sum = sum / 2
                        }
                        newGPA += sum
                        numClasses += tempCredits
                        print(gradeCurrent)
                    //print(gradeCurrent)
                    //let calcedGPA:Double = (self.calcClassGPA(className: arrayOfClassNamesCurrent[i], classGrade: gradeCurrent) + self.calcClassGPA(className: arrayOfClassNamesPrevious[i], classGrade: gradePrevious)) / 2.0
                    //newGPA += calcedGPA
                 
                    }
                }
                print(newGPA)
                print(totalGPA)
                print(numClasses)
                totalGPA += newGPA
                liveGPA = totalGPA / (2 * numCredits + numClasses)
                print(liveGPA)
            }
            }
        }
        return liveGPA
    }
    func generateLiveGpa13(currentGradesHTML: String, transcriptGPA: Double, refresh: Bool) -> Double{
        var liveGPA = transcriptGPA
        var numCredits = getTranscriptCredits(HTML: transcriptHTML!)
        print(numCredits)
        var totalGPA = 2 * round(numCredits * transcriptGPA * 10000.0) / 10000.0
        var newGPA = 0.0
        var newCredits = 0.0
        var numClasses = 0.0
        
        if currentMP == "1" || currentMP == "3" {
            var randDict = getGradesAndClasses(HTML: currentGradesHTML)
            
            var arrayOfClassNames = randDict[0]
            print(arrayOfClassNames)
            var arrayOfGrades = randDict[1]
           
            
            for i in 0..<arrayOfClassNames.count {
                if !arrayOfClassNames[i].contains("NO GPA") {
                    var gradeString = arrayOfGrades[i]
                    var grade = 0.0
                    if gradeString != ""{
                        grade = Double(gradeString)!
                        let array = calcClassGPA(className: arrayOfClassNames[i], classGrade: grade)
                        let calcedGPA:Double = array[0]
                        print(arrayOfClassNames[i])
                        print(calcedGPA)
                        newGPA+=calcedGPA
                        numClasses+=array[1]
                    }
                    
                
                }
            }
            totalGPA += newGPA / 2.0
            liveGPA = totalGPA / (2.0 * numCredits + numClasses/2.0)
            
        }
        return liveGPA
    }
    override func viewDidAppear(_ animated: Bool) {
        while !viewDidAppearQueue.isEmpty {
               viewDidAppearQueue.removeFirst()()
           }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
    }

    @objc func didTapButton() {
        let vc = ProfileVC()
        vc.title = "Profile"
        vc.view.backgroundColor = .white
        
        navigationController?.pushViewController(vc, animated: true)
    }
    func setCurrentMP(HTML: String) -> String{
        var mp = ""
        do {
            let doc2 = try SwiftSoup.parse(HTML)
            let currentMPHelper = try doc2.select("div.sg-content-grid-container").select("#plnMain_ddlReportCardRuns").select("option")
            
            var currentMPTemp:String = ""
            for element in currentMPHelper{
                if (element.hasAttr("selected")){
                    mp = try element.text()
                }
            }
        }
        catch {
            
        }
        return mp
    }
    func getGradesAndClasses(HTML: String) -> [[String]] {
        var arrayOfClassNames = [String]()
        var arrayOfGrades = [String]()
        do {
            let doc = try SwiftSoup.parse(HTML)
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
            for i in 0..<arrayOfClassNames.count {
                var className = arrayOfClassNames[i]
                className = className.replacingOccurrences(of: " S1@CTEC", with: "")
                className = className.replacingOccurrences(of: " S2@CTEC", with: "")
                className = className.replacingOccurrences(of: " S1", with: "")
                className = className.replacingOccurrences(of: " S2", with: "")
                
                className = className.replacingOccurrences(of: " A Lunch", with: "")
                className = className.replacingOccurrences(of: " B Lunch", with: "")
                className = className.replacingOccurrences(of: " C Lunch", with: "")
                className = className.replacingOccurrences(of: " D Lunch", with: "")
                
                arrayOfClassNames[i] = className
            }
            for i in 0..<arrayOfGrades.count {
                var grade = arrayOfGrades[i]
                if grade != "" {
                    grade.removeLast()
                }
                arrayOfGrades[i] = grade
            }
        }
        catch {
            
        }
        return [arrayOfClassNames, arrayOfGrades]
    }
    func getTranscriptGPA(HTML: String) -> Double {
        var gpa = 0.0
        do {
            let doc3 = try SwiftSoup.parse(HTML)
            gpa = Double(try doc3.select("span#plnMain_rpTranscriptGroup_lblGPACum1").text()) ?? 0.0
        }
        catch {
            
        }
        return gpa
    }
    func initializeDictionary() {
            classList["ISM"] = 5.5
            classList["Computer Science 3 Adv"] = 6.0 //Double Weight
            classList["AcDec 1"] = 5.5 //Double Weight?
            classList["AcDec 2"] = 5.5 //Double Weight?
            classList["GT HumanitiesI"] = 5.5 //TODO: Check with freshman
            classList["GT Humanities 2"] = 6.0 //TODO: Check with sophomores
            classList["Civil Engineering"] = 5.5
            classList["Aerospace Engineering"] = 5.5
            classList["Digital Electronics"] = 5.5
            classList["Engineering Design & Development"] = 5.5
            classList["GT Amer Studies/AP US Hist"] = 12.0 //Double Weight BUT it shows up as 2 classes
    }
    func getTranscriptCredits(HTML: String) -> Double{
        var credits = 0.0
        do{
            
            let doc3 = try SwiftSoup.parse(HTML)
            let array = try doc3.select("td.sg-transcript-group")
            var a = 0
            for element in array{

                var arrayOfCredits = [String]()
                let tempDataTables = try element.select("tr.sg-asp-table-data-row").select("td")
                for i in 0..<tempDataTables.count{
                    if (i%6==0){
                     
                        arrayOfCredits.append(try tempDataTables[i+5].text())
                    }
                }
                for i in 0..<arrayOfCredits.count {
                    credits += Double(arrayOfCredits[i])!
                }

            }
            return credits
             
        }
        catch {
            
        }
        return credits
    }
    
    func calcClassGPA(className: String, classGrade: Double) -> [Double]{
        var rGrade = classGrade.rounded()
        var returnGPA = 0.0
        var returnNum = 0.0
        
        if classGrade > 100.0 {
            rGrade = 100.0
        }
        var isInClassKeys:Bool = false
        if classGrade <  70 {
            returnGPA = 0.0
        }
        else if Constants.classList[className] != nil {
            
            returnGPA = Constants.classList[className]! - ((100.0-rGrade) / 10.0)
            
            isInClassKeys = true
        }
        
        else if !isInClassKeys {
            if className.contains("AP ") {
                returnGPA = 6.0 - ((100.0-rGrade) / 10.0)
            }
            else if (className.contains(" Advanced")) {
                returnGPA = 5.5 - ((100.0-rGrade) / 10.0)
            }
            else if className.contains("IB ") {
                returnGPA = 6.0 - ((100.0-rGrade) / 10.0)
            }
            else if (className.contains("NO GPA")) {
                returnGPA = 0.0
            }
            else{
                returnGPA = 5.0 - ((100.0-rGrade) / 10.0)
            }
        }
        if Constants.classNum[className] != nil {
            returnNum = Double(Constants.classNum[className]!)
            returnGPA *= Double(Constants.classNum[className]!)
        }
        else {
            returnNum = 1
        }
        return [returnGPA, returnNum]
    }
    
    
    
    func getGradestHTML(completion: @escaping (String) -> Void) {
        
        let Demographics = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Registration.aspx")
        var DemograhpicsHTML:String = ""
        let currentGradesURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Assignments.aspx")
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
                        completion(try String(contentsOf: currentGradesURL!, encoding: .ascii))
                    }
                    catch{
                        
                    }
                }
            }
            else {
                completion(try String(contentsOf: currentGradesURL!, encoding: .ascii))
                print("NO LOGIN")
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
            self.getGradestHTML() {
                response in
                UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)currentGrades")
                var transcriptGPA: Double = 0.0
                if  self.transcriptGPAString != "" {
                    transcriptGPA = Double(self.transcriptGPAString!)!
                }
                
                var liveGPA = 0.0
                if self.currentMP == "1" || self.currentMP == "3" {
                    liveGPA = self.generateLiveGpa13(currentGradesHTML: response, transcriptGPA: transcriptGPA , refresh: true)
                    liveGPA = round(liveGPA * 1000.0) / 1000.0
                }
                if self.currentMP == "2" || self.currentMP == "4" {
                    liveGPA = self.generateLiveGpa24(currentGradesHTML: self.currentGradesHTML, transcriptGPA: transcriptGPA, refresh: false)
                    liveGPA = round(liveGPA * 1000.0) / 1000.0
                }
                self.displayLabel.text = "\(liveGPA)"
                
                self.refreshControl.endRefreshing()

            }
                
        }
            
            

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
        else if mp == currentMP {
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
    
    func setUpCurrentGradesHTML() {
        
        let currentGradesURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Assignments.aspx")
        do {
            self.currentGradesHTML = try String(contentsOf: currentGradesURL!, encoding: .ascii)
        }
        catch {
            
        }
    }
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
}
