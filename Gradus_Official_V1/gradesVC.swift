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
    var username = "247070"
    
    var arrayOfButtons = [UIButton]()
    var arrayOfLabels = [UILabel]()
    var currentGradesHTML = ""
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
            
            setUpCurrentGradesHTML()
            let doc2 = try SwiftSoup.parse(currentGradesHTML)
            let currentMPHelper = try doc2.select("div.sg-content-grid-container").select("#plnMain_ddlReportCardRuns").select("option")
        
            var currentMPTemp:String = ""
            for element in currentMPHelper{
                if try element.text() != "(All Runs)" {
                    menu.dataSource.append(try element.text())
                }
            }
             
        }
        catch {
        
        }
        menu.anchorView = MPButton
        menu.selectionAction = { index, title in
            self.MPButton.title = title
            var mp = title
            self.getNewHTMl(mp: mp, isRefresh: false) {
                response in
                for button in self.arrayOfButtons {
                    button.setTitle("", for: .normal)
                }
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
                self.display(html: response, displayMultiplier: 1.0)
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
        let file = "Users/aravindsridhar/gradus/HacHtmls/Grades4.txt"
        let path=URL(fileURLWithPath: file)
        self.currentGradesHTML = try! String(contentsOf: path)
        let char: Set<Character> = ["\\"]
        currentGradesHTML.removeAll(where: { char.contains($0) })
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
        super.viewDidLoad()
       
        view.addSubview(containerView)
        
        print("Hello")
        
        do {
            let doc2 = try SwiftSoup.parse(currentGradesHTML)
            let currentMPHelper = try doc2.select("div.sg-content-grid-container").select("#plnMain_ddlReportCardRuns").select("option")
            
            var currentMPTemp:String = ""
            for element in currentMPHelper{
                if (element.hasAttr("selected")){
                    MPButton.title = try element.text()
                    currentMP = try element.text()
                }
            }
            view.addSubview(scrollView)
            scrollView.addSubview(containerView)
            //scrollView.addSubview(GradeLabel)
            //scrollView.addSubview(MPButton)
            
            testLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 49))
            
            testLabel.center.x = self.containerView.center.x
            testLabel.center.y = 10
            testLabel.textAlignment = .center
            
            testLabel.font = testLabel.font.withSize(41)
            containerView.addSubview(testLabel)
            floatingButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
            
        }
        catch {
            
        }
        let height = view.frame.height
        if height >= 800 {
            displayMultiplier = 3.0
        }
        else if height >= 700 {
            displayMultiplier = 2.5
        }
        else {
            displayMultiplier = 2.0
        }
        
        display(html: currentGradesHTML, displayMultiplier: displayMultiplier)
   
    }
    func getScrollHeight(HTML: String) -> CGFloat {
        if HTML == "" {
            setUpCurrentGradesHTML()
            
            var height = 0.0
            do {
                let doc = try SwiftSoup.parse(currentGradesHTML)
                let arrayOfClassNamesTemp:Elements = try doc.select("a.sg-header-heading")
                height = 80.0 * Double(arrayOfClassNamesTemp.count)
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
            height = 80.0 * Double(arrayOfClassNamesTemp.count)
            print(arrayOfClassNamesTemp.count)
        }
        catch {
            
        }
        return height
    }
    func display(html: String, displayMultiplier: CGFloat) {
        setUp(html: html)
        for i in 0..<arrayOfClassNames.count {
            ypos += 80
            var nameLabel = UILabel(frame: CGRect(x: 0, y: ypos, width: view.frame.width * 0.75, height: 20))
            nameLabel.text = arrayOfClassNames[i]
            nameLabel.textColor = .black
            nameLabel.textAlignment = .left
            containerView.addSubview(nameLabel)
            var gradeLabel = UILabel(frame: CGRect(x: view.frame.width * 0.75, y: ypos, width: view.frame.width * 0.25, height: 20))
            gradeLabel.textColor = .black
            gradeLabel.text = arrayOfGrades[i]
            gradeLabel.textAlignment = .center
            containerView.addSubview(gradeLabel)
            let button = UIButton(frame: CGRect(x: 0, y: ypos, width: view.frame.width, height: 20))
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            containerView.addSubview(button)
            arrayOfButtons.append(button)
            arrayOfLabels.append(nameLabel)
            arrayOfLabels.append(gradeLabel)
            /*
            let nameButton = UIButton()
            nameButton.setTitle(arrayOfClassNames[i], for: .normal)
            nameButton.setTitleColor(.white, for: .normal)
            nameButton.contentHorizontalAlignment = .left
            nameButton.setTitleColor(.black, for: .normal)
            nameButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            containerView.addSubview(nameButton)
            let gradeLabel = UIButton()
            gradeLabel.setTitle(arrayOfGrades[i], for: .normal)
            gradeLabel.setTitleColor(.black, for: .normal)
            gradeLabel.contentHorizontalAlignment = .right
            containerView.addSubview(gradeLabel)
            if arrayOfButtons.count == 0{
                nameButton.translatesAutoresizingMaskIntoConstraints = false
                gradeLabel.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.75, constant: 0.0)
                let topConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .topMargin, relatedBy: .equal, toItem: testLabel, attribute: .bottomMargin, multiplier: 2, constant: 0.0)
            
                let leftConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .leftMargin, relatedBy: .equal, toItem: nameButton, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0.0)
                let topConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .topMargin, relatedBy: .equal, toItem: testLabel, attribute: .bottomMargin, multiplier: 2, constant: 0.0)
                view.addConstraints([leftConstraint1, rightConstraint1, leftConstraint2, rightConstraint2, topConstraint2, topConstraint1])
            }
            else if arrayOfButtons.count != 0 {
                nameButton.translatesAutoresizingMaskIntoConstraints = false
                gradeLabel.translatesAutoresizingMaskIntoConstraints = false
                let leftConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .leftMargin, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 0.75, constant: 0.0)
                let topConstraint1 = NSLayoutConstraint(item: nameButton, attribute: .topMargin, relatedBy: .equal, toItem: arrayOfButtons[arrayOfButtons.count - 2], attribute: .bottomMargin, multiplier: displayMultiplier, constant: 0.0)
            
                let leftConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .leftMargin, relatedBy: .equal, toItem: nameButton, attribute: .rightMargin, multiplier: 1.0, constant: 0.0)
                let rightConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .rightMargin, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0.0)
                let topConstraint2 = NSLayoutConstraint(item: gradeLabel, attribute: .topMargin, relatedBy: .equal, toItem: arrayOfButtons[arrayOfButtons.count - 1], attribute: .bottomMargin, multiplier: displayMultiplier, constant: 0.0)
                view.addConstraints([leftConstraint1, rightConstraint1, topConstraint1, leftConstraint2, rightConstraint2, topConstraint2])
            }
            arrayOfButtons.append(nameButton)
            arrayOfButtons.append(gradeLabel)
            //arrayOfLabels.append(gradeLabel)
             */
            
        }
    }
    
    @objc func buttonAction(sender:UIButton!) {/*
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let Homevc : gradesSpecficVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gradesSpecificVC") as! gradesSpecficVC
        Homevc.arrayOfAssignments = dict[sender.titleLabel!.text!]!
        self.present(Homevc, animated: true, completion: nil)
                                                 */
        if arrayOfButtons.contains(sender) {
            var i = arrayOfButtons.firstIndex(of: sender)!
            
            var className = arrayOfClassNames[i]
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let Homevc : gradesSpecficVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gradesSpecificVC") as! gradesSpecficVC
            Homevc.arrayOfAssignments = dict[className]!
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
            }
                //GET GRADES FROM MP HERE
            let file = "Users/aravindsridhar/gradus/HacHtmls/Grades\(mp).txt"
            let path=URL(fileURLWithPath: file)
            var temp = try! String(contentsOf: path)
            let char: Set<Character> = ["\\"]
            temp.removeAll(where: { char.contains($0) })
            completion(temp)
            
        }
        catch {
            
        }
        /*
        let file = "Users/aravindsridhar/gradus/HacHtmls/Grades\(mp).txt"
        let path=URL(fileURLWithPath: file)
        var temp = try! String(contentsOf: path)
        let char: Set<Character> = ["\\"]
        temp.removeAll(where: { char.contains($0) })
        return temp
         */
    }
    func getNewHTMl(mp: String, isRefresh: Bool, completion: @escaping (String) -> Void) {
        if isRefresh == true {
            getFiles(mp: mp) {
                response in
                UserDefaults.standard.set(response, forKey: "\(self.username)MP:\(mp)")
                completion(response)
            }
            
        }
        if mp == currentMP {
            completion(currentGradesHTML)
        }
        else if UserDefaults.standard.object(forKey: "\(username)MP:\(mp)") != nil {
          completion(UserDefaults.standard.object(forKey: "\(username)MP:\(mp)") as! String)
        }
            getFiles(mp: mp) {
                response in
                UserDefaults.standard.set(response, forKey: "\(self.username)MP:\(mp)")
                completion(response)
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
            let mp = MPButton.title!
            self.getNewHTMl(mp: mp, isRefresh: false) {
                response in
                for button in self.arrayOfButtons {
                    button.setTitle("", for: .normal)
                }
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
                self.display(html: response, displayMultiplier: 1.0)
            }
            
            // Code to refresh table view
            refreshControl.endRefreshing()

        }

}


