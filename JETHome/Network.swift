//
//  Network.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
// Code Received from RapidAPI
import Foundation

class justEatAPIInteraction {
    
    func getRestaurantInfo(completion: @escaping ([Restaurant]) -> Void) {
        /* Configure session, choose between:
           * defaultSessionConfiguration
           * ephemeralSessionConfiguration
           * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default

        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        /* Create the Request:
           Request (9) (GET https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/EC4M7RF)
         */

        guard let URL = URL(string: "https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/EC4M7RF") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"

        // Headers

        request.addValue("_cfuvid=jznbZj1.f4kGI_lmSBchK9nPhBqr3RbSeTKTDVTpE0Q-1743007674892-0.0.1.1-604800000", forHTTPHeaderField: "Cookie")

        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                guard let jsonData = data else { return }
                
                do {
                    // print the JSON data
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("JSON: \(jsonString)")
                    }
                    
                    let restaurantResponse = try JSONDecoder().decode(RestaurantResponse.self, from: jsonData)
                    completion(restaurantResponse.restaurants)
                } catch {
                    print("Decoding JSON error: \(error)")
                
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

