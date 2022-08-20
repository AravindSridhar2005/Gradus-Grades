//
//  HomeViewController.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/28/22.
//

import UIKit
import SwiftSoup
import Alamofire
class HomeViewController: UIViewController {
    var transcriptHTML = ""
    var reportCardHTML = ""
    var weekViewHTML = ""
    var scheduleHTML = ""
    var progressReportHTML = ""
    var DemographicsHTML = ""
    
    @IBOutlet weak var contactTeachers: UIButton!

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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //print("Hello")
        /*
        self.getReportCardHTML()
        self.getTranscriptHTML()
        self.getWeekViewHTML()
        self.getScheduleHTML()
       // self.getProgressReportHTML()
        self.getDemographicsHTML()
        //print(self.DemographicsHTML)
        UserDefaults.standard.set(self.reportCardHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)RC")
       
        UserDefaults.standard.set(self.transcriptHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)transcript")
        UserDefaults.standard.set(self.weekViewHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)weekview")
        UserDefaults.standard.set(self.scheduleHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)schedule")
        UserDefaults.standard.set(self.progressReportHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)ProgressReport")
        UserDefaults.standard.set(self.DemographicsHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)demographics")
         */
        
       
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
       
        keepLoggedIn() {
            response in
            if response == true {
                self.getReportCardHTML()
                self.getTranscriptHTML()
                self.getWeekViewHTML()
                self.getScheduleHTML()
               // self.getProgressReportHTML()
                self.getDemographicsHTML()
                //print(self.DemographicsHTML)
                UserDefaults.standard.set(self.reportCardHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)RC")
               
                UserDefaults.standard.set(self.transcriptHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)transcript")
                UserDefaults.standard.set(self.weekViewHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)weekview")
                UserDefaults.standard.set(self.scheduleHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)schedule")
                UserDefaults.standard.set(self.progressReportHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)ProgressReport")
                UserDefaults.standard.set(self.DemographicsHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)demographics")
            }
            else{
                
                
            }
        //print(UserDefaults.standard.object(forKey: "247070transcript"))
        }
    }
    @objc func didTapButton() {
        let vc = ProfileVC()
        vc.title = "Profile"
        vc.view.backgroundColor = .white
        
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 75, y: 75, width: 50, height: 50)
        var rightNavBarButton = UIBarButtonItem(customView:floatingButton)
         self.navigationItem.leftBarButtonItem = rightNavBarButton
    }
    func getScheduleHTML() {
        let scheduleURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Classes.aspx")
        do {
            self.scheduleHTML = try String(contentsOf: scheduleURL!, encoding: .ascii)
        }
        catch {
            
        }
    }
    func getWeekViewHTML() {
        let weekViewURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Home/WeekView")
        
        do {
            self.weekViewHTML = try String(contentsOf: weekViewURL!, encoding: .ascii)
        }
        catch {
            
        }
    }
    func getDemographicsHTML() {
    
        let demographicURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Registration.aspx")
        do {
            self.DemographicsHTML = try String(contentsOf: demographicURL!, encoding: .ascii)
        }
        catch {
            
        }
    }
    func getProgressReportHTML() {
        let file = "Users/aravindsridhar/gradus/HacHtmls/ProgressReport.txt"
        let path=URL(fileURLWithPath: file)
        self.progressReportHTML = try! String(contentsOf: path)
        let char: Set<Character> = ["\\"]
        progressReportHTML.removeAll(where: { char.contains($0) })
    }
    func getTranscriptHTML() {
        let transcriptURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Transcript.aspx")
        do {
            self.transcriptHTML = try String(contentsOf: transcriptURL!, encoding: .ascii)
        }
        catch {
            
        }
    }
    
    
    func getReportCardHTML() {
        
        let file = "Users/aravindsridhar/gradus/HacHtmls/Report Card MP4.txt"
        let path=URL(fileURLWithPath: file)
        self.reportCardHTML = try! String(contentsOf: path)
        let char: Set<Character> = ["\\"]
        reportCardHTML.removeAll(where: { char.contains($0) })
        
        /*
        let RCURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/ReportCards.aspx")
        do {
            self.reportCardHTML = try String(contentsOf: RCURL!, encoding: .ascii)
            print(reportCardHTML)
        }
        catch {
            
        }
         */
        
    }
    
    
    
    @IBAction func reportCardPressed(_ sender: Any) {
        getReportCardHTML()
        //print(reportCardHTML)
        let vc = reportCardVC()
        vc.view.backgroundColor = .white
        vc.title = "Report Card"
        vc.reportCardHTML = reportCardHTML
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactTeachersPressed(_ sender: Any) {
        
        
        //print(reportCardHTML)
        DispatchQueue.main.async {
            let vc = ContactTeachersVC()
            vc.title = "Contact Teachers"
            //vc.weekViewHTML = self.weekViewHTML
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func progressReportPressed(_ sender: Any) {
        let vc = progressReportVC()
        vc.view.backgroundColor = .white
        vc.title = "Progress Report"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func transcriptPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let vc : UIViewController = transcriptVC()
            vc.title = "Transcript"
                  self.navigationController?.pushViewController(vc, animated: true)
             }
    }
    
    
    func keepLoggedIn(completion: @escaping (Bool) -> Void) {
        
        let Demographics = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Registration.aspx")
        var DemograhpicsHTML:String = ""
        
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
                        //print(data)
                        completion(true)
                    }
                    catch{
                        
                    }
                }
            }
            else {
                completion(false)
            }
        }
        catch {
            
        }
    }
}
