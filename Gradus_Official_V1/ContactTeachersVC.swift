//
//  ContactTeachersVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/29/22.
//

import UIKit
import SwiftSoup
class ContactTeachersVC: UIViewController {
    var weekViewHTML = UserDefaults.standard.object(forKey: "247070weekview") as! String
    var Teachers = [Teacher]()
    var yPos = 30.0
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: yPos + (86 * getHeight()) + 10.0)
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
        setUp()
    }
    func getHeight() -> CGFloat{
        var height = 0.0
        do {
            let docWV = try SwiftSoup.parse(weekViewHTML)
            let namesAndEmails = try docWV.select("table.sg-asp-table").select("tr").select("#staffName")
            height = CGFloat(namesAndEmails.count)
        }
        catch {
            
        }
        return height
    }
    func setUp() {
        do{
            let docWV = try SwiftSoup.parse(weekViewHTML)
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
            readyLabels()
            
        }
        catch{
            
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
            yPos+=86
            containerView.addSubview(button)
        }
        
    }

}
