//
//  ViewController.swift
//  J.SocialLogin
//
//  Created by JinYoung Lee on 13/06/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import UIKit
import GoogleSignIn
import KakaoOpenSDK

class ViewController: UIViewController {

    let kakaoSession = KOSession.shared()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        signOutAll()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func loginWithKakaoTalk(_ sender: Any) {
        signOutAll()
        kakaoSession.open(completionHandler: { (error) in
            if self.kakaoSession.isOpen() {
                print("login success")
                print(self.kakaoSession.token)
                KOSessionTask.userMeTask(withPropertyKeys: ["account_email", "properties.nickname"], completion: { (error, user) in
                    self.kakaoSession.updateScopes(["account_email, properties.nickname"], completionHandler: { (error) in
                        KOSessionTask.userMeTask(completion: { (error, user) in
                            print(user?.account?.dictionary())
                        })
                    })
                })
            } else {
                print("login fail")
            }
        })
    }
    
    @IBAction func loginWithTwitter(_ sender: Any) {
        
    }
    
    @IBAction func loginWithNaver(_ sender: Any) {
        
    }
    
    private func signOutAll() {
        kakaoSession.close()
        GIDSignIn.sharedInstance()?.signOut()
    }
}

extension ViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            return
        }
        
        let userId = user.userID
        let idToken = user.authentication.idToken
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        print("userID: \(userId), idToken: \(idToken), fullName: \(fullName), givenName: \(givenName), familyName: \(familyName), email: \(email)")
    }
}

extension ViewController: GIDSignInUIDelegate {
    
}


