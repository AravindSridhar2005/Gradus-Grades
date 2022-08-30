//
//  HomeViewController.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/28/22.
//

import UIKit
import SwiftSoup
import Alamofire
import SwiftUI
class HomeViewController: UIViewController {
    var transcriptHTML = ""
    var reportCardHTML = ""
    var weekViewHTML = ""
    var scheduleHTML = ""
    var progressReportHTML = ""
    var DemographicsHTML = ""
    var currentGradesHTML = ""
    
    
    
    @IBOutlet weak var transcriptButton: UIButton!
    
    
    
    
    @IBOutlet weak var RCButton: UIButton!
    
    
    @IBOutlet weak var IPRButton: UIButton!
    
    @IBOutlet weak var scheduleButton: UIButton!
    
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
        transcriptButton.layer.cornerRadius = 25
        RCButton.layer.cornerRadius = 25
        IPRButton.layer.cornerRadius = 25
        scheduleButton.layer.cornerRadius = 25
        contactTeachers.layer.cornerRadius = 25
        floatingButton.frame = CGRect(x: view.frame.size.width - 75, y: 75, width: 50, height: 50)
        var rightNavBarButton = UIBarButtonItem(customView:floatingButton)
         self.navigationItem.leftBarButtonItem = rightNavBarButton
        self.floatingButton.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        //navigationController?.navigationBar.isHidden = true
        //self.tabBarController?.tabBar.isHidden = true
        //LoadingOverlay.shared.showOverlay(view: self.view)
       
        
        //self.present(vc, animated: false, completion: nil)



        
        //LoadingOverlay.shared.showOverlay(view: self.view)
        //To to long tasks
        
            self.keepLoggedIn() {
                response in
                if response == true {
                    print("Hello")
                    self.getReportCardHTML()
                    self.getTranscriptHTML()
                   
                    //self.getCurrentGradesHTML()
                    self.getProgressReportHTML()
                    //self.getDemographicsHTML()
                    
                    UserDefaults.standard.synchronize()
                    
                    //LoadingOverlay.shared.hideOverlayView()
                    //self.navigationController?.navigationBar.isHidden = false
                    //self.tabBarController?.tabBar.isHidden = false
                    //self.dismiss(animated: false, completion: nil)

                    
                }
                else{
                    self.getReportCardHTML()
                    self.getTranscriptHTML()
                    self.getWeekViewHTML()
                    self.getScheduleHTML()
                    self.getCurrentGradesHTML()
                    self.getProgressReportHTML()
                    self.getDemographicsHTML()
                    //print(self.DemographicsHTML)
                    //UserDefaults.standard.set(self.reportCardHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)RC")
                   
                   
                    
                    UserDefaults.standard.synchronize()
                    self.navigationController?.navigationBar.isHidden = false
                    self.tabBarController?.tabBar.isHidden = false
                    LoadingOverlay.shared.hideOverlayView()
                }
        
        
            super.viewDidLoad()
        }
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
        
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
       /*
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
                print("Hello")
                
            }
        //print(UserDefaults.standard.object(forKey: "247070transcript"))
        }
        */
    }
    @objc func didTapButton() {
        let vc = ProfileVC()
        vc.title = "Profile"
        vc.view.backgroundColor = .white
        
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    func getScheduleHTML() {
        let scheduleURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Classes.aspx")
        do {
            self.scheduleHTML = try String(contentsOf: scheduleURL!, encoding: .ascii)
            UserDefaults.standard.set(self.scheduleHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)schedule")
        }
        catch {
            
        }
    }
    func getWeekViewHTML() {
        let weekViewURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Home/WeekView")
        
        do {
            self.weekViewHTML = try String(contentsOf: weekViewURL!, encoding: .ascii)
            UserDefaults.standard.set(self.weekViewHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)weekview")
        }
        catch {
            
        }
    }
    
    func getCurrentGradesHTML() {
    
        let currentGradesURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Assignments.aspx")
        do {
            self.currentGradesHTML = try String(contentsOf: currentGradesURL!, encoding: .ascii)
            print(currentGradesHTML)
            UserDefaults.standard.set(self.currentGradesHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)currentGrades")
        }
        catch {
            
        }
    }
    func getDemographicsHTML() {
    
        let demographicURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Registration.aspx")
        do {
            self.DemographicsHTML = try String(contentsOf: demographicURL!, encoding: .ascii)
            UserDefaults.standard.set(self.DemographicsHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)demographics")
        }
        catch {
            
        }
    }
    func getProgressReportHTML() {
        /*
        let file = "Users/aravindsridhar/gradus/HacHtmls/ProgressReport.txt"
        let path=URL(fileURLWithPath: file)
        self.progressReportHTML = try! String(contentsOf: path)
        let char: Set<Character> = ["\\"]
        progressReportHTML.removeAll(where: { char.contains($0) })
         */
        
        let PRURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/InterimProgress.aspx")
        do {
            self.progressReportHTML = try String(contentsOf: PRURL!, encoding: .ascii)
            UserDefaults.standard.set(self.progressReportHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)ProgressReport")
        }
        catch {
            
        }
         
          
    }
    func getTranscriptHTML() {
        let transcriptURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Transcript.aspx")
        do {
            self.transcriptHTML = try String(contentsOf: transcriptURL!, encoding: .ascii)
            UserDefaults.standard.set(self.transcriptHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)transcript")
        }
        catch {
            
        }
    }
    
    
    func getReportCardHTML() {
        /*
        let file = "Users/aravindsridhar/gradus/HacHtmls/Report Card MP4.txt"
        let path=URL(fileURLWithPath: file)
        self.reportCardHTML = try! String(contentsOf: path)
        let char: Set<Character> = ["\\"]
        reportCardHTML.removeAll(where: { char.contains($0) })
        */
        
        let RCURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/ReportCards.aspx")
        do {
            self.reportCardHTML = try String(contentsOf: RCURL!, encoding: .ascii)
            UserDefaults.standard.set(self.reportCardHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)RC")
        }
        catch {
            
        }
        
         
        
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
                        UserDefaults.standard.set(DemograhpicsHTML, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)demographics")
                        completion(false)
                    }
                }
                catch {
                    
                }
            }
}
public class LoadingOverlay{

var overlayView = UIView()
var activityIndicator = UIActivityIndicatorView()

class var shared: LoadingOverlay {
    struct Static {
        static let instance: LoadingOverlay = LoadingOverlay()
    }
    return Static.instance
}

    public func showOverlay(view: UIView) {

        overlayView.frame = CGRect(x: 0, y: 0, width:view.frame.width, height: view.frame.height)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.backgroundColor = .white
        
        let catImage = UIImage(named: "Gradus-1")
        let myImageView:UIImageView = UIImageView()
        myImageView.contentMode = UIView.ContentMode.scaleAspectFit
        myImageView.frame.size.width = 360
        myImageView.frame.size.height = 360
        myImageView.center = view.center
        myImageView.image = catImage
        overlayView.addSubview(myImageView)
        /*
        activityIndicator.backgroundColor = .white
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)

        overlayView.addSubview(activityIndicator)
         */
        view.addSubview(overlayView)

        activityIndicator.startAnimating()
    }

    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}


