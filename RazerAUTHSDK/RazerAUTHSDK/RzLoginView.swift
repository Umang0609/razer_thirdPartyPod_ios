//
//  RzLoginView.swift
//  RazerAUTHSDK
//
//  Created by Umang Davessar on 27/2/18.
//  Copyright © 2018 Umang Davessar. All rights reserved.
//

import Foundation
import Alamofire


extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}



public struct RZError {
    
    public let error: Error?
    public let errorMessage: String?
    public var errorCode : Int? = 0
    // We may add more custom properties in future, like error code etc...
    
    init(error:Error? , customeMessage: String?) {
        if let theError = error as NSError? {
            self.errorCode = theError.code
        }
        
        self.error = error
        
        if customeMessage == nil || customeMessage?.count == 0 {
            self.errorMessage = error?.localizedDescription
        }
        else {
            self.errorMessage = customeMessage
        }
    }
}

public class RzLoginView {
    private var presenterVc : UIViewController? = nil

    //1.
    private var isDebug: Bool!
    
    //2.
    public init() {
        self.isDebug = false
    }
    
    //3.
    public func setup(isDebug: Bool) {
        self.isDebug = isDebug
        print("Project is in Debug mode: \(isDebug)")
    }
    
    //4.
    public func YPrint<T>(value: T) {
        if self.isDebug == true {
            print(value)
        } else {
            //Do any stuff for production mode
        }
    }
    
  
    
    private func presentVC( viewController: UIViewController, animated: Bool, _ completion: @escaping () -> Void){
        
        DispatchQueue.main.async {
            
            
            if let topVC = UIApplication.topViewController(){
                
                UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: animated, completion: {
                    
                    self.presenterVc = topVC
                    
                    
                    completion()
                    
                })
                
            }
                
            else{
                
                completion()
                
            }
            
        }
        
    }
    
    public func loginRazerID(urlScheme:String?,clientID:String?,clientSecret:String?,scope:String?,_ success: @escaping (_ accessToken:String?) -> Void,_ dismissCompletion: @escaping () -> Void, _ failure: @escaping (_ error: RZError?) -> Void)
    {
        //Tested with "https://oauth2.razer.com/clientinfo?client_id=e8a995fd9a0c54e9003530379204f90e8bf6f7e6&client_secret=bb403a03ecc3eb594fe619c6baaf7352bbb58ac4&scope=openid+profile&locale=en"
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.synchronize()
        let urlString = String(format:"https://oauth2.razer.com/clientinfo?client_id=%@&client_secret=%@&scope=%@&locale=en",clientID!,clientSecret!,scope!)
        print(urlString)
        
        Alamofire.request(urlString, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            if(response.result != nil) {
            //case .success(_):
                if let data = response.result.value {
                    
                    let dict = data as! NSDictionary
                    print(dict)
                    
                    
                    let webViewController = WebViewController.initializeViewController(clientidweb: clientID, clientsecretweb: clientSecret, scopeweb: scope, dismissCompletion: dismissCompletion)
                                  
                                  webViewController.goBackSelectorBlock = { () -> Void in
                                      print("come to suucceess Block")
                                          dismissCompletion()
                                      
                                      
                                          UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
                                              print("access::%@",UserDefaults.standard.value(forKey: "token") as? String as Any)
                                              
                                              if(UserDefaults.standard.value(forKey: "token") as? String == nil || UserDefaults.standard.value(forKey: "token") as? String == "")
                                              {
                                                  
                                              }
                                              else
                                              {
                                                  success(UserDefaults.standard.value(forKey: "token") as? String)
                                              }

                                              
                                          })
                                      
                                      
                                  }
                                  let navigationController = UINavigationController(rootViewController: webViewController)
                                  navigationController.navigationBar.barTintColor = UIColor.black
                                  navigationController.view.backgroundColor = UIColor.black
                                  navigationController.modalPresentationStyle  = .overCurrentContext
                                  self.presentVC(viewController: navigationController, animated: true) {
                                      //showCompletion()
                                  }
                    
                    
                    
                    
                  /*  if let val = dict["error_description"] {
                         print("error in returing the client info")
                        
                    }
                    else
                    {
                        let Urlstring = String(format:"%@?clientid=%@&clientname=%@&clientlogo=%@&scope=%@",urlScheme!,dict["client_id"] as! String,dict["client_name"] as! String,dict["client_logo"] as! String, "Profile")
                        
                        
                        let appURLScheme = Urlstring .removingWhitespaces()
                        
                        //dict["scope"]as! [String : AnyObject]
                        
                        
                        guard let appURL = URL(string: appURLScheme) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(appURL) {
                            
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(appURL)
                            }
                            else {
                                UIApplication.shared.openURL(appURL)
                            }
                        }
                        else {
                            
                            let webViewController = WebViewController.initializeViewController(clientidweb: clientID, clientsecretweb: clientSecret, scopeweb: scope, dismissCompletion: dismissCompletion)
                            
                            webViewController.goBackSelectorBlock = { () -> Void in
                                print("come to suucceess Block")
                                    dismissCompletion()
                                
                                
                                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: {
                                        print("access::%@",UserDefaults.standard.value(forKey: "token") as? String as Any)
                                        
                                        if(UserDefaults.standard.value(forKey: "token") as? String == nil || UserDefaults.standard.value(forKey: "token") as? String == "")
                                        {
                                            
                                        }
                                        else
                                        {
                                            success(UserDefaults.standard.value(forKey: "token") as? String)
                                        }

                                        
                                    })
                                
                                
                            }
                            let navigationController = UINavigationController(rootViewController: webViewController)
                            navigationController.navigationBar.barTintColor = UIColor.black
                            navigationController.view.backgroundColor = UIColor.black
                            navigationController.modalPresentationStyle  = .overCurrentContext
                            self.presentVC(viewController: navigationController, animated: true) {
                                //showCompletion()
                            }
                           
                        }

                    }
                    
                */
                    
                }
                
                else
                {
                    print(response.result.error)
                    UserDefaults.standard.set("", forKey: "token")
                    UserDefaults.standard.synchronize()
                    failure(response.result.error as? RZError)
                }
                
                //break
                
            //case .failure(_):
                
                //break
                
            }
            
        
        }

       
    }

    
    public func application(url: URL,_ success: @escaping (_ params: Dictionary<String, Any>?) -> Void, _ failure: @escaping (_ error: RZError?) -> Void)
    {
        
        /**
         After Deny authorization from other app, user will redirect to Main Login View.
         */
        if url.absoluteString == "tpdemo://"
        {
            print("Sorry ,Request Denied. Please sign in to login again. ")
            failure(RZError.init(error: nil, customeMessage: "Sorry ,Request Denied. Please sign in to login again. "))
            //vc.messageAppDeny = "Sorry ,Request Denied. Please sign in to login again. "
            
        }
        else
        {
            let params = NSMutableDictionary()
            let kvPairs : [String] = (url.query?.components(separatedBy: "&"))!
            for param in  kvPairs{
                let keyValuePair : Array = param.components(separatedBy: "=")
                if keyValuePair.count == 2{
                    params.setObject(keyValuePair.last!, forKey: keyValuePair.first! as NSCopying)
                }
            }
            
            /**
             After Authorize and receive the data from other app, user will redirect to Detail View Screen.
             */
            if (params["accesstoken"] != nil)
            {
                
                print(params as! Dictionary<String, Any>)
                // vc.paramValue = params as! Dictionary<String, Any>
                
            }
            print(params)
            success(params as? Dictionary<String, Any>)
            
        }
        
    }

 
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

