//
//  ViewController.swift
//  CloudServiceSetupVC
//
//  Created by hiraya.shingo on 2016/12/06.
//  Copyright © 2016年 hiraya.shingo. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {

    let cloudServiceController = SKCloudServiceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [1] ミュージックライブラリへのアクセス許可を要求する
        // https://developer.apple.com/library/content/qa/qa1929/_index.html
        SKCloudServiceController.requestAuthorization { (status) in
            if status != .authorized { return }
            
            // [2] 利用可能な機能を確認する
            // 以下を満たす場合、SKCloudServiceSetupViewController を使用できる
            //     .musicCatalogSubscriptionEligible が含まれている
            //     .musicCatalogPlayback が含まれていない
            self.cloudServiceController.requestCapabilities { (capability, error) in
                if capability.contains(.musicCatalogSubscriptionEligible) &&
                    !capability.contains(.musicCatalogPlayback) {
                    print("you can use SKCloudServiceSetupViewController")
                }
            }
        }
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        print(#function)
        let controller = SKCloudServiceSetupViewController()
        controller.delegate = self
        
        // ビューをロードする
        // options に action キーと値 subscribe を指定
        controller.load(options: [.action : SKCloudServiceSetupAction.subscribe],
                        completionHandler: { (result, error) in
                            print("loaded")
        })
        
//        // ビューをロードする
//        // action と iTunesItemIdentifier を指定
//        let options: [SKCloudServiceSetupOptionsKey : Any] =
//            [.action : SKCloudServiceSetupAction.subscribe,
//             .iTunesItemIdentifier : 1069277704 as NSNumber]
//        controller.load(options: options,
//                        completionHandler: { (result, error) in
//                            print("loaded:", result)
//                            if (error != nil) {
//                                print("error:", error!.localizedDescription)
//                            }
//        })
        
        present(controller,
                animated: true,
                completion: nil)
    }
}

extension ViewController: SKCloudServiceSetupViewControllerDelegate {
    func cloudServiceSetupViewControllerDidDismiss(_ cloudServiceSetupViewController: SKCloudServiceSetupViewController) {
        print(#function)
    }
}
