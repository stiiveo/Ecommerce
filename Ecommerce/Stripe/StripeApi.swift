//
//  StripeApi.swift
//  Ecommerce
//
//  Created by Jason Ou on 2021/6/16.
//

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let data = [
            "apiVersion": apiVersion,
            "customer_id": UserService.user.stripeId
        ]
        
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { result, error in
            if let error = error {
                debugPrint(error)
                completion(nil, error)
                return
            }
            guard let key = result?.data as? [String: Any] else {
                completion(nil, nil)
                return
            }
            // New ephemeral key is retrieved.
            completion(key, nil)
        }
    }
}
