//
//  ViewController.swift
//  NICInAppPurchase
//
//  Created by akashthakkar09 on 07/08/2017.
//  Copyright (c) 2017 akashthakkar09. All rights reserved.
//

import UIKit
import NICInAppPurchase


class ViewController: UIViewController {

    let sticker_pack1 = "com.test"
    let sticker_pack2 = "com.test"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func btnInappPurchaseAction(_ sender: UIButton) {

        // Start the progress hud here..
        
        NICInAppPurchase.sharedInstance.RequestInappPaymentQueue(sticker_pack1) { (aPurchaseStatus:String) in
            
            print("objSKPaymentTransactionState = \(aPurchaseStatus)")
            
            
            // Hide the progress hud here..
            
            if (aPurchaseStatus == paymentStatus.purchased.rawValue){
                
            }else if (aPurchaseStatus == paymentStatus.failed.rawValue){
                
            }else if (aPurchaseStatus == paymentStatus.restored.rawValue){
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

