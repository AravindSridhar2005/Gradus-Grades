//
//  progressReportVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/29/22.
//

import UIKit
import DropDown
import SwiftSoup
class progressReportVC: UIViewController {
    var yPos = 0.0
    var currentDate = ""
    var progressReportHTML = UserDefaults.standard.object(forKey: "247070ProgressReport") as? String ?? ""
    var arrayOfIPRObjects = [iprObject]()
    var arrayOfButtons = [UIButton]()
    var menu: DropDown {
        let menu = DropDown()
        do {
            let docIPR = try SwiftSoup.parse(progressReportHTML)
            let rand = try docIPR.select("#plnMain_ddlIPRDates").text()
            
            menu.dataSource = rand.components(separatedBy: " ")
            
        }
        catch {
            
        }
        menu.anchorView = selectedButton
        menu.selectionAction = { index, title in
            self.selectedButton.title = title
           
        }
        return menu
    }
    
    @IBOutlet weak var selectedButton: UIBarButtonItem!
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: getScrollingHeight() + 20)
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
    func getScrollingHeight() -> CGFloat {
        var height = 0.0
        do {
            let docIPR = try SwiftSoup.parse(progressReportHTML)
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
        //print(progressReportHTML)
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
    
    func readyLabels() {
        
        for i in 0..<arrayOfIPRObjects.count {
            yPos+=50
            var button = UIButton(frame: CGRect(x: 0, y: yPos, width: view.frame.width, height: 30.0))
            button.layer.cornerRadius = 20
            button.backgroundColor = .link
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            arrayOfButtons.append(button)
            containerView.addSubview(button)
            var periodLabel = UILabel(frame: CGRect(x: 0, y: yPos, width: view.frame.width * 0.15, height: 30.0))
            periodLabel.text = arrayOfIPRObjects[i].period
            periodLabel.textAlignment = .center
            containerView.addSubview(periodLabel)
            var courseLabel = UILabel(frame: CGRect(x: view.frame.width * 0.2, y: yPos, width: view.frame.width * 0.6, height: 30.0))
            courseLabel.text = arrayOfIPRObjects[i].description
            courseLabel.textAlignment = .center
            containerView.addSubview(courseLabel)
            var gradeLabel = UILabel(frame: CGRect(x: view.frame.width * 0.85, y: yPos, width: view.frame.width * 0.15, height: 30.0))
            gradeLabel.text = arrayOfIPRObjects[i].score
            gradeLabel.textAlignment = .center
            containerView.addSubview(gradeLabel)
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
    
    
    
    
    @IBAction func didTapNavButton(_ sender: Any) {
        menu.show()
    }
    
}
