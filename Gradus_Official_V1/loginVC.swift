//
//  loginVC.swift
//  Gradus_Official_V1
//
//  Created by Aravind Sridhar on 7/30/22.
//

import UIKit
import Alamofire
import SwiftSoup
class loginVC: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    
    
    
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
     
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    
        //print(UserDefaults.standard.object(forKey: "username") as? String)
        //print(UserDefaults.standard.object(forKey: "password") as? String)
    }
    @IBOutlet weak var submitButton: UIButton!
    
    
    @IBAction func submitPressed(_ sender: Any) {
        print("Hello")
        submitButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "submitPressed"))
        //print(UserDefaults.standard.object(forKey: "username") as? String)
        //when submit button is pressed
        view.endEditing(true)
        let username = usernameTF.text!
        let password = passwordTF.text!
        verify(username: username, password: password) {
            response in
            if response == true {
                UserDefaults.standard.set(true, forKey: "ISLOGGEDIN")
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(password, forKey: "password")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                
                    
                    // This is to get the SceneDelegate object from your view controller
                    // then call the change root view controller function to change to main tab bar
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)

            }
            else if response == false {
                
            }
        }
    }
    func verify(username: String, password: String, completion: @escaping (Bool) -> Void){
        let url = URL(string: "https://hac.friscoisd.org/HomeAccess/Account/LogOffComplete?loginUrl=https%3A%2F%2Fhac.friscoisd.org%2FHomeAccess%2F")
        AF.request("https://hac.friscoisd.org/HomeAccess/Account/LogOffComplete?loginUrl=https%3A%2F%2Fhac.friscoisd.org%2FHomeAccess%2F", method: .get, encoding: URLEncoding()).response {
            response in
            let data = String(data: response.data!, encoding: .utf8)
            //print(data)
            let logonURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Account/LogOn?")
            var logonHTML:String = ""
            do {
                
                logonHTML = try String(contentsOf: logonURL!, encoding: .ascii)
                //print(logonHTML)
                let logonDoc = try SwiftSoup.parse(logonHTML)
                let token = try logonDoc.select("[name=__RequestVerificationToken]").val()
                let parametersForLogon = ["LogOnDetails.UserName": username, "LogOnDetails.Password": password, "SCKTY00328510CustomEnabled":"false","SCKTY00436568CustomEnabled":"false","__RequestVerificationToken":token, "Database":"10", "tempUN":"", "tempPW": "", "VerificationOption": "UsernamePassword"]
                AF.request("https://hac.friscoisd.org/HomeAccess/Account/LogOn?", method: .post, parameters: parametersForLogon, encoding: URLEncoding()).response { response in
                    let data = String(data: response.data!, encoding: .utf8)
                    do {
                        //print(data)
                        let verification_doc = try SwiftSoup.parse(data!)
                        //if test has this div class, then login is unsucsessful
                        let test = try verification_doc.select("[name=__RequestVerificationToken]")
                        
                        print(test.count)
                        if test.count == 1 {
                            
                            completion(false)
                            var dialogMessage = UIAlertController(title: "Wrong Credentials", message: "Please Enter your correct Username and Password", preferredStyle: .alert)
                             
                             // Create OK button with action handler
                             let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                                 print("Ok button tapped")
                              })
                             
                             //Add OK button to a dialog message
                             dialogMessage.addAction(ok)
                             // Present Alert to
                             self.present(dialogMessage, animated: true, completion: nil)
                        }
                        else {
                            completion(true)
                            
                        }
                        
                    }
                    catch{
                        
                    }
                }
            }
            catch {
                
            }
            
        }
        
    }
    
    @IBAction func GoPressed(_ sender: UITextField) {
        self.view.endEditing(true)
        submitPressed(sender)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
   


}

