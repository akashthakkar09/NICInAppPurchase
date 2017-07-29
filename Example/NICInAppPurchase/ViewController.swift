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
        
        NICInAppPurchase.sharedInstance.RequestInappPaymentQueue(sticker_pack1) { (paymentStatus, ProductID) in
            
            if (paymentStatus == .purchased){
                
            }else if (paymentStatus == .failed){
                
            }else if (paymentStatus == .restored){
                
            }
        }
        
    }
    
    @IBAction func btnRestoreInappPurchaseAction(_ sender: Any) {
        
        NICInAppPurchase.sharedInstance.restoreInAppPurchase { (paymentStatus, ProductID) in
            
            if (paymentStatus == .purchased){
                
            }else if (paymentStatus == .failed){
                
            }else if (paymentStatus == .restored){
                
            }
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

