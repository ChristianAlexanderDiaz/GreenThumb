//
//  GetJsonDataFromApi.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//
//  Tutorial by Osman Balci on 3/20/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import Foundation

fileprivate var jsonDataFromApi = Data()

/**
 Fetches JSON data from the API specified by the provided URL and headers asynchronously, using the `GET` method.
 
 - Parameters:
     - `apiHeaders`: The headers of the API request.
     - `apiUrl`: The URL of the API request.
     - `timeout`: The time limit for the API request.
 
 - Returns: The JSON `Data` obtained from the API request if it is successful, otherwise returns `nil`.
 */
public func getJsonDataFromApi(apiHeaders: [String: String], apiUrl: String, timeout: Double) -> Data? {
    jsonDataFromApi = Data()

    var apiQueryUrlStruct: URL?
    if let urlStruct = URL(string: apiUrl) {
        apiQueryUrlStruct = urlStruct
    } else {
        return nil
    }
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: timeout)
   
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = apiHeaders

    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        guard error == nil else {
            semaphore.signal()
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
       
        guard let dataObtained = data else {
            semaphore.signal()
            return
        }
        
        jsonDataFromApi = dataObtained
        
        semaphore.signal()
    }).resume()
   
    _ = semaphore.wait(timeout: .now() + timeout)
    
    return jsonDataFromApi
}
