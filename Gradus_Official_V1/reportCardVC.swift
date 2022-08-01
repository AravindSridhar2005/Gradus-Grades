//
//  reportCardVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/29/22.
//

import UIKit
import SwiftSoup
import DropDown
import EFAutoScrollLabel
class reportCardVC: UIViewController {
    
    @IBOutlet weak var selectedMPButton: UIBarButtonItem!
    var arrayOfLabels = [UILabel]()
    var currentMP = ""
    var username = "247070"
    var menu: DropDown {
        let menu = DropDown()
        menu.dataSource = ["1","2","3","4"]
        menu.anchorView = selectedMPButton
        menu.selectionAction = { index, title in
            self.selectedMPButton.title = title
            for button in self.arrayOfInvsisibleButtons {
                button.removeFromSuperview()
            }
            self.arrayOfInvsisibleButtons.removeAll()
            for label in self.arrayOfLabels {
                label.removeFromSuperview()
            }
            self.arrayOfLabels.removeAll()
            self.arrayOfReportCardClasses.removeAll()
            var temp = self.getNewHTMl(mp: title, isRefresh: false)
            self.ypos = 30.0
            self.setUp(HTML: temp)
            self.contentViewSize.height = self.getScrollHeight() + 50
            self.scrollView.contentSize = self.contentViewSize
            self.containerView.frame.size = self.contentViewSize
            self.readyLabels()
        }
        return menu
    }
    
    
    @IBAction func didTapNavButton(_ sender: Any) {
        menu.show()
    }
    
    var ypos = 30.0
    //var username = UserDefaults.standard.object(forKey: "currentusername")
    var reportCardHTML = UserDefaults.standard.object(forKey: "247070RC") as? String
    var arrayOfInvsisibleButtons = [UIButton]()
    var arrayOfReportCardClasses = [ReportCardObject]()
    lazy var contentViewSize = CGSize(width: self.view.frame.width + 100, height: getScrollHeight() + 50)
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
    func getScrollHeight() -> CGFloat{
        var height = view.frame.height
        do {
            let docRC = try SwiftSoup.parse(reportCardHTML as! String)
            let rand = try docRC.select("tr.sg-asp-table-data-row")
            height = CGFloat(ypos + (50.0 * Double(rand.count)))
        }
        catch {
            
        }
        return height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(containerView)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        do {
            let docRC = try SwiftSoup.parse(reportCardHTML as! String)
            let mpElements = try docRC.select("div.sg-content-grid-container").select("#plnMain_ddlRCRuns").select("option")

            for element in mpElements{
                if element.hasAttr("selected") {
                    currentMP = try element.text()
                    selectedMPButton.title = "4"
                }
            }
        }
        catch {
            
        }
        var courseLabel = UILabel(frame: CGRect(x: 0, y: 30, width: ((view.frame.width+100) * 0.35), height: 49))
        courseLabel.center.y = 30.0
        courseLabel.textAlignment = .center
        courseLabel.text = "Course Name"
        var q1Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.35, y: 30, width: (view.frame.width+100) * 0.1, height: 49))
        q1Label.center.y = 30.0
        q1Label.textAlignment = .center
        q1Label.text = "Q1"
        var q2Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.45, y: 30, width: (view.frame.width+100) * 0.1, height: 49))
        q2Label.center.y = 30.0
        q2Label.textAlignment = .center
        q2Label.text = "Q2"
        var sem1Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.55, y: 30, width: (view.frame.width+100) * 0.1, height: 49))
        sem1Label.center.y = 30.0
        sem1Label.textAlignment = .center
        sem1Label.text = "Sem1"
        var q3Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.65, y: 30, width: (view.frame.width+100) * 0.1, height: 49))
        q3Label.center.y = 30.0
        q3Label.textAlignment = .center
        q3Label.text = "Q3"
        var q4Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.75, y: 30, width: (view.frame.width+100) * 0.1, height: 49))
        q4Label.center.y = 30.0
        q4Label.textAlignment = .center
        q4Label.text = "Q4"
        var sem2Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.85, y: 30, width: (view.frame.width+100) * 0.15, height: 49))
        sem2Label.center.y = 30.0
        sem2Label.textAlignment = .center
        sem2Label.text = "Sem2"
        containerView.addSubview(courseLabel)
        containerView.addSubview(q1Label)
        containerView.addSubview(q2Label)
        containerView.addSubview(sem1Label)
        containerView.addSubview(q3Label)
        containerView.addSubview(q4Label)
        containerView.addSubview(sem2Label)
        setUp(HTML: reportCardHTML ?? "")
        readyLabels()
    }
    func readyLabels() {
        for i in 0..<arrayOfReportCardClasses.count {
            ypos+=50.0
            var button = UIButton(frame: CGRect(x: 0, y: 30, width: ((view.frame.width+100)), height: 49))
            button.center.y = ypos
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            //button.setValue(arrayOfReportCardClasses[i], forKey: "need")
            arrayOfInvsisibleButtons.append(button)
            var courseLabel = UILabel(frame: CGRect(x: 0, y: 30, width: ((view.frame.width+100) * 0.35), height: 49))
            courseLabel.center.y = ypos
            courseLabel.textAlignment = .center
            courseLabel.text = arrayOfReportCardClasses[i].Description
            courseLabel.textColor = .black
            var q1Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.35, y: 30, width: (view.frame.width+100) * 0.1, height: 49))
            q1Label.center.y = ypos
            q1Label.textAlignment = .center
            q1Label.text = arrayOfReportCardClasses[i].q1
            var q2Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.45, y: 30, width: (view.frame.width+100) * 0.1, height: 49))
            q2Label.center.y = ypos
            q2Label.textAlignment = .center
            q2Label.text = arrayOfReportCardClasses[i].q2
            var sem1Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.55, y: 30, width: (view.frame.width+100) * 0.1, height: 49))
            sem1Label.center.y = ypos
            sem1Label.textAlignment = .center
            sem1Label.text = arrayOfReportCardClasses[i].sem1
            var q3Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.65, y: 30, width: (view.frame.width+100) * 0.1, height: 49))
            q3Label.center.y = ypos
            q3Label.textAlignment = .center
            q3Label.text = arrayOfReportCardClasses[i].q3
            var q4Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.75, y: 30, width: (view.frame.width+100) * 0.1, height: 49))
            q4Label.center.y = ypos
            q4Label.textAlignment = .center
            q4Label.text = arrayOfReportCardClasses[i].q4
            var sem2Label = UILabel(frame: CGRect(x: (view.frame.width+100) * 0.85, y: 30, width: (view.frame.width+100) * 0.15, height: 49))
            sem2Label.center.y = ypos
            sem2Label.textAlignment = .center
            sem2Label.text = arrayOfReportCardClasses[i].sem2
            containerView.addSubview(courseLabel)
            containerView.addSubview(q1Label)
            containerView.addSubview(q2Label)
            containerView.addSubview(sem1Label)
            containerView.addSubview(q3Label)
            containerView.addSubview(q4Label)
            containerView.addSubview(sem2Label)
            containerView.addSubview(button)
            arrayOfLabels.append(contentsOf: [courseLabel, q1Label, q2Label, sem1Label, q3Label, q4Label, sem2Label])
        }
    }
    @objc func buttonAction(sender:UIButton!) {
        //let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        /*
        
         */
        if arrayOfInvsisibleButtons.contains(sender) {
            var i = arrayOfInvsisibleButtons.firstIndex(of: sender)!
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RCpopover") as! reportCardPopOverVC
            popOverVC.RCO = arrayOfReportCardClasses[i]
            self.addChild(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParent: self)
            
        }
        //print(sender.value(forKey: "need"))
      }
    func setUp(HTML: String) {
        do {
           
            let docRC = try SwiftSoup.parse(HTML as! String)
            let rand = try docRC.select("tr.sg-asp-table-data-row")
            //print(rand.count)
            let mpElements = try docRC.select("div.sg-content-grid-container").select("#plnMain_ddlRCRuns").select("option")
            var mp = ""
            for element in mpElements{
                if element.hasAttr("selected") {
                    mp = try element.text()
                    print(mp)
                }
            }
            
            for element in rand {
                
                let indElements = try element.select("td")
                var course = try indElements[0].text()
                var Description = try indElements[1].text()
                var period =  try indElements[2].text()
                var teacher = try indElements[3].text()
                var room = try indElements[4].text()
                var attCredit = try indElements[5].text()
                var ernCredit = try indElements[6].text()
                var q1 = ""
                var q2 = ""
                var sem1 = ""
                var q3 = ""
                var q4 = ""
                var sem2 = ""
                var absences = ""
                var tardies = ""
                var YTDA = ""
                var YTDY = ""
               
                if indElements.count >= 14 {
                    q1 = try indElements[7].text()
                    
                }
                if indElements.count >= 16 {
                    q2 = try indElements[8].text()
                    sem1 = try indElements[9].text()
                }
                if indElements.count >= 17 {
                    q3 = try indElements[10].text()
                }
                if indElements.count >= 19 {
                    q4 = try indElements[11].text()
                    sem2 = try indElements[12].text()
                    YTDY = try indElements[indElements.count-1].text()
                    YTDA = try indElements[indElements.count-2].text()
                }
                else {
                    absences = try indElements[indElements.count-4].text()
                    YTDA = try indElements[indElements.count-2].text()
                    tardies = try indElements[indElements.count-3].text()
                    YTDY = try indElements[indElements.count-1].text()
                    
                }
                var rco = ReportCardObject(mp: mp, course: course, Description: Description, period: period, teacher: teacher, room: room, attCredit: attCredit, ernCredit: ernCredit, q1: q1, q2: q2, sem1: sem1, q3: q3, q4: q4, sem2: sem2, absences: absences, tardies: tardies, YTDA: YTDA, YTDY: YTDY)
                self.arrayOfReportCardClasses.append(rco)
                
                 
            }
        }
        catch {
            
        }
        
    }
    func getFiles(mp: String) -> String {
        let file = "Users/aravindsridhar/gradus/HacHtmls/Report Card MP\(mp).txt"
        let path=URL(fileURLWithPath: file)
        var temp = try! String(contentsOf: path)
        let char: Set<Character> = ["\\"]
        temp.removeAll(where: { char.contains($0) })
        return temp
    }
    func getNewHTMl(mp: String, isRefresh: Bool) -> String {
        if isRefresh == true {
            UserDefaults.standard.set(getFiles(mp: mp), forKey: "\(username)RC:\(mp)")
            return getFiles(mp: mp)
        }
        if mp == currentMP {
            return reportCardHTML!
        }
        else if UserDefaults.standard.object(forKey: "\(username)RC:\(mp)") != nil {
          return UserDefaults.standard.object(forKey: "\(username)RC:\(mp)") as! String
        }
        else {
            UserDefaults.standard.set(getFiles(mp: mp), forKey: "\(username)RC:\(mp)")
            return getFiles(mp: mp)
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
            let mp = selectedMPButton.title
            var tempHTML = getNewHTMl(mp: mp!, isRefresh: true)
            for button in self.arrayOfInvsisibleButtons {
                button.removeFromSuperview()
            }
            self.arrayOfInvsisibleButtons.removeAll()
            for label in self.arrayOfLabels {
                label.removeFromSuperview()
            }
            self.arrayOfLabels.removeAll()
            self.arrayOfReportCardClasses.removeAll()
            ypos = 30.0
            //need to make request to HAC Here
            self.setUp(HTML: tempHTML)
            readyLabels()
            
            // Code to refresh table view
            refreshControl.endRefreshing()

        }

}
