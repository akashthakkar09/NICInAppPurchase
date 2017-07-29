//
//  InAppPurchase.swift
//  Swift_InApp_Purchase_Demo
//
//  Created by indianic on 08/07/17.
//  Copyright © 2017 indianic. All rights reserved.
//

import UIKit
import StoreKit


public enum paymentStatus : String {
    
    case purchasing = "purchasing" // Transaction is being added to the server queue.
    
    case purchased = "purchased" // Transaction is in queue, user has been charged.  Client should complete the transaction.
    
    case failed = "failed" // Transaction was cancelled or failed before being added to the server queue.
    
    case restored = "restored"// Transaction was restored from user's purchase history.  Client should complete the transaction.
    
    @available(iOS 8.0, *)
    case deferred  = "deferred" // The transaction is in the queue, but its final status is pending external action.
}

public typealias InAppCompletionHander = (_ inAppState: paymentStatus, _ productId: String?)->Void

public class NICInAppPurchase: NSObject,SKProductsRequestDelegate,SKPaymentTransactionObserver {
    
    public static let sharedInstance = NICInAppPurchase()
    var aStrProcessProductID : String = ""
    var viewController = UIViewController()
    var objInAppCompletionHander : InAppCompletionHander?
    
    
    public func RequestInappPaymentQueue(_ aProductID : String,inAppCompletion:@escaping InAppCompletionHander) -> Void {
    
        objInAppCompletionHander = inAppCompletion
        
        SKPaymentQueue.default().add(self)
        
        if (SKPaymentQueue.canMakePayments())
        {
            let productID:NSSet = NSSet(object: aProductID);
            aStrProcessProductID = aProductID
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
            productsRequest.delegate = self;
            productsRequest.start();
        
            print("Fetching Products");
            
        }else{
            print("can't make purchases");
        }
    }
    
    public func restoreInAppPurchase(inAppCompletion:@escaping InAppCompletionHander) -> Void{
        objInAppCompletionHander = inAppCompletion
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    @available(iOS 3.0, *)
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased");
                    
                    print("Process product id = \(String(describing: trans.transactionIdentifier))")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                   
                    if (objInAppCompletionHander != nil){
                        objInAppCompletionHander!(.purchased,trans.payment.productIdentifier)
                    }
                    
                    break;
                    
                case .failed:
                    print("Purchased Failed");
                    print("Process product id = \(String(describing: trans.transactionIdentifier))")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if (objInAppCompletionHander != nil){
                        objInAppCompletionHander!(.failed,trans.payment.productIdentifier)
                    }
                    break;
                    
                case .restored:
                    print("Already Purchased");
                    print("Process product id = \(String(describing: trans.transactionIdentifier))")
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    if (objInAppCompletionHander != nil){
                        objInAppCompletionHander!(.restored,trans.payment.productIdentifier)
                    }
                    break;
                    
                default:
                    break;
                }
            }
        }
    }
    
    public func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let count : Int = response.products.count
        if (count>0) {
            
            let validProducts = response.products
            print("list of products  = \(validProducts)")
            
            let validProduct: SKProduct = response.products[0] as SKProduct
            
            if (validProduct.productIdentifier == aStrProcessProductID) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(product: validProduct);
                
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
            if (objInAppCompletionHander != nil){
                objInAppCompletionHander!(.failed,nil)
            }
        }
    }
    
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error Fetching product information");
        if (objInAppCompletionHander != nil){
            objInAppCompletionHander!(.failed,nil)
        }
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if (objInAppCompletionHander != nil){
            objInAppCompletionHander!(.restored, nil)
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        if (objInAppCompletionHander != nil){
            objInAppCompletionHander!(.failed, nil)
        }
    }
    
    public func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment);
        
    }
    
}
