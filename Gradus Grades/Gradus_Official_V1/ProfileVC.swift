//
//  ProfileVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/30/22.
//

import UIKit
import SwiftSoup
import Alamofire
class ProfileVC: UIViewController {
        var profile = Profile(studentID: "", studentName: "", studentBirthDay: "", counselor: "", building: "", grade: "", language: "")
    var logoutButton = UIButton()
    var arrayOfLabels = [UILabel]()
    var DemographicsHTML  = UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)demographics") as? String ?? ""
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: 350)
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
        view.addSubview(containerView)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = .link
        logoutButton.layer.cornerRadius = 5
        logoutButton.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
        
        var rightNavBarButton = UIBarButtonItem(customView:logoutButton)
         self.navigationItem.rightBarButtonItem = rightNavBarButton
        setUp(HTML: DemographicsHTML)
        readyLabels()
    }
    func readyLabels() {
        var yPos = 30.0
        var studentIDLabel = UILabel(frame: CGRect(x: self.view.frame.width * 0.15, y: yPos, width: self.view.frame.width * 0.7, height: 20))
        studentIDLabel.text = "Student ID: \(profile.studentID)"
        
        studentIDLabel.textAlignment = .center
        studentIDLabel .textColor = .black
        containerView.addSubview(studentIDLabel)
        var studentName = UILabel(frame: CGRect(x: self.view.frame.width * 0.15, y: 80, width: self.view.frame.width * 0.7, height: 20))
        studentName.text = "Student Name: \(profile.studentName)"
        studentName.textAlignment = .center
        studentName .textColor = .black
        containerView.addSubview(studentName)
        var studentBirthDay = UILabel(frame: CGRect(x: self.view.frame.width * 0.15, y: 130, width: self.view.frame.width * 0.7, height: 20))
        studentBirthDay.text = "Student BirthDay: \(profile.studentBirthDay)"
        studentBirthDay.textAlignment = .center
        studentBirthDay .textColor = .black
        containerView.addSubview(studentBirthDay)
        
        var Counselor = UILabel(frame: CGRect(x: self.view.frame.width * 0.15, y: 180, width: self.view.frame.width * 0.7, height: 20))
        Counselor.text = "Counselor: \(profile.counselor)"
        Counselor.textAlignment = .center
        Counselor .textColor = .black
        containerView.addSubview(Counselor)
        
        var building = UILabel(frame: CGRect(x: self.view.frame.width * 0.15, y: 230, width: self.view.frame.width * 0.7, height: 20))
        building.text = "Building: \(profile.building)"
        building.textAlignment = .center
        building .textColor = .black
        containerView.addSubview(building)
        
        var Grade = UILabel(frame: CGRect(x: self.view.frame.width * 0.15, y: 280, width: self.view.frame.width * 0.7, height: 20))
        Grade.text = "Grade: \(profile.grade)"
        Grade.textAlignment = .center
        Grade .textColor = .black
        containerView.addSubview(Grade)
        
        var language = UILabel(frame: CGRect(x: self.view.frame.width * 0.15, y: 330, width: self.view.frame.width * 0.7, height: 20))
        language.text = "Language: \(profile.language)"
        language.textAlignment = .center
        language .textColor = .black
        containerView.addSubview(language)
        
        arrayOfLabels.append(contentsOf: [studentBirthDay, language, Grade, building, Counselor, studentName, studentIDLabel])
    }
    
    func setUp(HTML: String) {
        do {
            let doc = try SwiftSoup.parse(DemographicsHTML)
            
            let studentID = try doc.select("#plnMain_lblRegStudentID").text()
            let studentName = try doc.select("#plnMain_lblRegStudentName").text()
            let studentBirthDay = try doc.select("#plnMain_lblBirthDate").text()
            let Counselor = try doc.select("#plnMain_lblCounselor").text()
            let building = try doc.select("#plnMain_lblBuildingName").text()
            let Grade = try doc.select("#plnMain_lblGrade").text()
            let language = try doc.select("#plnMain_lblLanguage").text()
            profile = Profile(studentID: studentID, studentName: studentName, studentBirthDay: studentBirthDay, counselor: Counselor, building: building, grade: Grade, language: language)
        }
        catch {
            
        }
    }
   
    
    //LOGOUT BUTTON
    @objc func buttonAction(sender:UIButton!) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let Homevc : loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! loginVC
        Homevc.modalPresentationStyle = .fullScreen
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        UserDefaults.standard.set(false, forKey: "ISLOGGEDIN")
        let cstorage = HTTPCookieStorage.shared
        let url = URL(string: "https://hac.friscoisd.org/HomeAccess/Account/LogOffComplete?loginUrl=https%3A%2F%2Fhac.friscoisd.org%2FHomeAccess%2F")
        AF.request("https://hac.friscoisd.org/HomeAccess/Account/LogOffComplete?loginUrl=https%3A%2F%2Fhac.friscoisd.org%2FHomeAccess%2F", method: .get, encoding: URLEncoding()).response {
            response in
            let data = String(data: response.data!, encoding: .utf8)
            print(data)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        
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
            
            getProfileHTML() {
                response in
                self.setUp(HTML: response)
                self.readyLabels()
                UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)demographics")
                print(response)
            }
            
            
            refreshControl.endRefreshing()

        }

    func getProfileHTML(completion: @escaping (String) -> Void) {
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
                        completion(try String(contentsOf: Demographics!, encoding: .ascii))
                    }
                    catch{
                        
                    }
                }
            }
            else {
                completion(try String(contentsOf: Demographics!, encoding: .ascii))
            }
        }
        catch {
            
        }
    }
}
struct Profile {
    var studentID:String
    var studentName:String
    var studentBirthDay:String
    var counselor:String
    var building:String
    var grade:String
    var language:String
}
