//
//  Network.swift
//  JETHome
//
//  Created by Mohamed, Saajidah on 30/03/2025.
//
import Foundation
//https://www.linkedin.com/pulse/using-asyncawait-restful-apis-swift-swiftui-wagner-assis-fzclf
/** I downloaded RapidAPI and used the url to get the correct information. After the success '200' status code, there should be code below the url parameters section, switch to "Swift NSURLSession" and the code is there. I used the following video to implement this solution and made adaptations to the code to allow postcode as an input
 * Advent, B. (2020) iOS Swift Tutorial: Use APIs with Swift UI & Build a Book Barcode Scanner. Link available at: https://www.youtube.com/watch?v=44APgBnapag&ab_channel=BrianAdvent
 * Source code: https://www.patreon.com/posts/42828807
 *
 */

class justEatAPIInteraction {
    //func getRestaurantInfo(postcode: String, completion: @escaping ([Restaurant]) -> Void) {
    func getRestaurantInfo(postcode: String) async throws -> [Restaurant] {
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
        
        guard let URL = URL(string: "https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/\(postcode)") else { throw URLError(.badURL)}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        request.addValue("_cfuvid=jznbZj1.f4kGI_lmSBchK9nPhBqr3RbSeTKTDVTpE0Q-1743007674892-0.0.1.1-604800000", forHTTPHeaderField: "Cookie")
        
    let (data, response) = try await session.data(for: request)
          guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else
          {
              throw URLError(.badServerResponse)
          }
          let restaurantResponse = try JSONDecoder().decode(RestaurantResponse.self, from: data)
          return restaurantResponse.restaurants
    
        /* Start a new Task */
        /** let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
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
        session.finishTasksAndInvalidate() */
    }
}

