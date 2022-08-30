//
//  ContactTeachersVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/29/22.
//

import UIKit
import SwiftSoup
import Alamofire
class ContactTeachersVC: UIViewController {
    var weekViewHTML = UserDefaults.standard.object(forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)weekview") as! String
    var Teachers = [Teacher]()
    var yPos = 30.0
    var arrayOfButtons = [UIButton]()
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: yPos + (86 * getHeight(HTML: weekViewHTML)) + 10.0)
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
        setUp(HTML: weekViewHTML)
        readyLabels()
    }
    func getHeight(HTML: String) -> CGFloat{
        var height = 0.0
        do {
            let docWV = try SwiftSoup.parse(HTML)
            let namesAndEmails = try docWV.select("table.sg-asp-table").select("tr").select("#staffName")
            height = CGFloat(namesAndEmails.count)
        }
        catch {
            
        }
        return height
    }
    func setUp(HTML: String) {
        do{
            let docWV = try SwiftSoup.parse(HTML)
            let namesAndEmails = try docWV.select("table.sg-asp-table").select("tr").select("#staffName")
            let courses = try docWV.select("table.sg-asp-table").select("tr").select("#courseName")
            var loopIndex = 0
            
            for elements in namesAndEmails{
                let index = try elements.attr("href").index(try elements.attr("href").startIndex, offsetBy: 7)
                let name = try elements.text()
                let email = try elements.attr("href").substring(from: index)
                let course = try courses[loopIndex].text()
                let teacher = Teacher(course: course, name: name, email: email)
                Teachers.append(teacher)
                loopIndex+=1
            }
            
            
        }
        catch{
            
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
            
            
            getWeekViewHTML(){
                response in
                UserDefaults.standard.set(response, forKey: "\(UserDefaults.standard.object(forKey: "username") as! String)weekview")
                for button in self.arrayOfButtons {
                    button.setTitle("", for: .normal)
                }
                for button in self.arrayOfButtons {
                    button.removeFromSuperview()
                }
                self.arrayOfButtons.removeAll()
                self.Teachers.removeAll()
                self.yPos = 30.0
                self.contentViewSize.height = self.yPos + (86 * self.getHeight(HTML: response)) + 10.0
                self.scrollView.contentSize = self.contentViewSize
                self.containerView.frame.size = self.contentViewSize
                
                self.setUp(HTML: response)
                self.readyLabels()
                self.refreshControl.endRefreshing()
            }
            
            

        }
    func readyLabels() {
        for i in 0..<Teachers.count {
            var button = UIButton(frame: CGRect(x: 0.0, y: CGFloat(yPos), width: view.frame.width * 0.75, height: 65.0))
            button.center.x = view.center.x
            let text = """
                \(Teachers[i].name)
                \(Teachers[i].email)
                """
            button.setTitle(text, for: .normal)
            button.contentHorizontalAlignment = .center
            button.backgroundColor = .link
            button.titleLabel?.numberOfLines = 2
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 20
            arrayOfButtons.append(button)
            yPos+=86
            containerView.addSubview(button)
        }
        
    }
    
    func getWeekViewHTML(completion: @escaping (String) -> Void) {
        let Demographics = URL(string: "https://hac.friscoisd.org/HomeAccess/Content/Student/Registration.aspx")
        var DemograhpicsHTML:String = ""
        let weekViewURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Home/WeekView")
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
                        completion(try String(contentsOf: weekViewURL!, encoding: .ascii))
                        print("HAD TO LOGIN")
                    }
                    catch{
                        
                    }
                }
            }
            else {
                completion(try String(contentsOf: weekViewURL!, encoding: .ascii))
                print("NO LOGIN REQUIRED")
            }
        }
        catch {
            
        }
    }
    

}
