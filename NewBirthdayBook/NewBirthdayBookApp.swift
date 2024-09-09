//
/*
 リリース前確認
 ・Ad idの変更　（info, admobManager
 */
//

import SwiftUI
import GoogleMobileAds
import NotificationCenter
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        //Google広告の初期化
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //通知処理
        NotificationManager.instance.requestPermission()
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
}



@main
struct NewBirthdayBookApp: App {
    
    let migrator = Migrator()
    @StateObject private var purchaseManager = PurchaseManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    let SetPass = UserDefaults.standard.bool(forKey: "SetPass")
    
    var body: some Scene {
        WindowGroup {
            if SetPass{
                //Set済
                LockView()
            }else{
                //鍵なし
                //enviroはLockにも追加
                ContentView()
                    .environmentObject(passcodeCheck())
                    .environmentObject(CategorySet())
                    .environmentObject(NotificationModel())
                    //.environmentObject(IconChange())
                    .environmentObject(purchaseManager)
                    .environmentObject(AdmobInterstitialManager())
            }
        }
    }
}
