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
    
    /// Invoke the function stored on the firebase cloud to retrieve the ephemeral key of the customer from Stripe.
    /// - Parameters:
    ///   - apiVersion: The Stripe API version used by the client device.
    ///   - completion: A callback to be run with a JSON response.
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
