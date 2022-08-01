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
        UserDefaults.standard.set(true, forKey: "ISLOGGEDIN")
        
        //print(UserDefaults.standard.object(forKey: "username") as? String)
        //print(UserDefaults.standard.object(forKey: "password") as? String)
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        //print(UserDefaults.standard.object(forKey: "username") as? String)
        //when submit button is pressed
        let username = usernameTF.text!
        let password = passwordTF.text!
        verify(username: username, password: password) {
            response in
            if response == true {
                UserDefaults.standard.set(true, forKey: "ISLOGGEDIN")
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(password, forKey: "password")
                UserDefaults.standard.synchronize()
                //print(UserDefaults.standard.object(forKey: "username") as? String)

            }
            else if response == false {
                
            }
        }
    }
    func verify(username: String, password: String, completion: @escaping (Bool) -> Void){
        let logonURL = URL(string: "https://hac.friscoisd.org/HomeAccess/Account/LogOn?")
        
        var logonHTML:String = ""
        do {
            
            logonHTML = try String(contentsOf: logonURL!, encoding: .ascii)
            let logonDoc = try SwiftSoup.parse(logonHTML)
            let token = try logonDoc.select("[name=__RequestVerificationToken]").val()
            let parametersForLogon = ["LogOnDetails.UserName": username, "LogOnDetails.Password": password, "SCKTY00328510CustomEnabled":"false","SCKTY00436568CustomEnabled":"false","__RequestVerificationToken":token, "Database":"10", "tempUN":"", "tempPW": "", "VerificationOption": "UsernamePassword"]
            AF.request("https://hac.friscoisd.org/HomeAccess/Account/LogOn?", method: .post, parameters: parametersForLogon, encoding: URLEncoding()).response { response in
                let data = String(data: response.data!, encoding: .utf8)
                do {
                    let verification_doc = try SwiftSoup.parse(data!)
                    //if test has this div class, then login is unsucsessful
                    let test = try verification_doc.select("div.sg-login-container")
                    
                    if test.count == 0 {
                        completion(true)
                    }
                    else {
                        completion(false)
                        print("hellor")
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
