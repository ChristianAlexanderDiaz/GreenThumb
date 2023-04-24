//
//  UtilityFunctions.swift
//  Videos
//
//  Created by Christian Alexander Diaz on 3/24/23.
//  Copyright © 2023 Christian Alexander Diaz. All rights reserved.
//
//  Tutorial by Osman Balci on 3/20/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

import Foundation
import SwiftUI

// Global constant
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

/**
 Decodes a JSON file into an array of structs of the specified type.
 
 - Parameters:
   - fullFilename: The name of the JSON file to decode.
   - fileLocation: The location of the JSON file ("Main Bundle" or "Document Directory").
   - type: The type of the structs to decode the JSON file into. Defaults to `T.self`.
 
 - Returns: An array of structs of the specified type, decoded from the JSON file.
 */
public func decodeJsonFileIntoArrayOfStructs<T: Decodable>(fullFilename: String, fileLocation: String, as type: T.Type = T.self) -> T {
    var jsonFileData: Data?
    var jsonFileUrl: URL?
    var arrayOfStructs: T?
    
    if fileLocation == "Main Bundle" {
        // Obtain URL of the JSON file in main bundle
        let urlOfJsonFileInMainBundle: URL? = Bundle.main.url(forResource: fullFilename, withExtension: nil)
        
        if let mainBundleUrl = urlOfJsonFileInMainBundle {
            jsonFileUrl = mainBundleUrl
        } else {
            print("JSON file \(fullFilename) does not exist in main bundle!")
        }
    } else {
        // Obtain URL of the JSON file in document directory on user's device
        let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent(fullFilename)
        
        if let docDirectoryUrl = urlOfJsonFileInDocumentDirectory {
            jsonFileUrl = docDirectoryUrl
        } else {
            print("JSON file \(fullFilename) does not exist in document directory!")
        }
    }
    
    do {
        jsonFileData = try Data(contentsOf: jsonFileUrl!)
    } catch {
        print("Unable to obtain JSON file \(fullFilename) content!")
    }
    
    do {
        // Instantiate an object from the JSONDecoder class
        let decoder = JSONDecoder()
        
        // Use the decoder object to decode JSON objects into an array of structs of type T
        arrayOfStructs = try decoder.decode(T.self, from: jsonFileData!)
    } catch {
        print("Unable to decode JSON file \(fullFilename)!")
    }
    
    // Return the array of structs of type T
    return arrayOfStructs!
}

/**
 Decodes a JSON file into an array of structs of the specified type.
 
 - Parameters:
   - fullFilename: The name of the JSON file to decode.
   - fileLocation: The location of the JSON file ("Main Bundle" or "Document Directory").
   - type: The type of the structs to decode the JSON file into. Defaults to `T.self`.
 
 - Returns: An array of structs of the specified type, decoded from the JSON file.
 */
public func getImageFromUrl(url: String, defaultFilename: String) -> Image {

    var imageObtainedFromUrl = Image(defaultFilename)
 
    let headers = [
        "accept": "image/jpg, image/jpeg, image/png",
        "cache-control": "cache",
        "connection": "keep-alive",
    ]
 
    guard let imageUrl = URL(string: url) else {
        return Image(defaultFilename)
    }
 
    let request = NSMutableURLRequest(url: imageUrl,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 30.0)
 
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
 
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
 
        guard let imageDataFromUrl = data else {
            semaphore.signal()
            return
        }
 
        let uiImage = UIImage(data: imageDataFromUrl)
 
        if let imageObtained = uiImage {
            imageObtainedFromUrl = Image(uiImage: imageObtained)
        }
 
        semaphore.signal()
    }).resume()
 
    _ = semaphore.wait(timeout: .now() + 30)
 
    return imageObtainedFromUrl
}

/**
    Obtains a UIImage object from the specified URL.

    -   Parameters:
        -   `url`: The URL from which to obtain the UIImage object.
        -   `defaultFilename`: The name of the image file to use as a default in case obtaining the UIImage object from the URL fails.

    -   Returns: A UIImage object obtained from the specified URL. If obtaining the UIImage object from the URL fails, the default image specified by defaultFilename will be returned.
*/
public func getUIImageFromUrl(url: String, defaultFilename: String) -> UIImage {

    var uiImageObtainedFromUrl = UIImage(named: defaultFilename)!
 
    let headers = [
        "accept": "image/jpg, image/jpeg, image/png",
        "cache-control": "cache",
        "connection": "keep-alive",
    ]
 
    guard let imageUrl = URL(string: url) else {
        return uiImageObtainedFromUrl
    }
 
    let request = NSMutableURLRequest(url: imageUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
 
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
 
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
 
        guard let imageDataFromUrl = data else {
            semaphore.signal()
            return
        }
 
        if let uiImage = UIImage(data: imageDataFromUrl) {
            uiImageObtainedFromUrl = uiImage
        } else {
            return
        }
       
        semaphore.signal()
    }).resume()
 
    _ = semaphore.wait(timeout: .now() + 30)
 
    return uiImageObtainedFromUrl
}

/*
********************************
MARK: Get Image from Binary Data
********************************
*/
public func getImageFromBinaryData(binaryData: Data?, defaultFilename: String) -> Image {
    
    // Create a UIImage object from binaryData
    let uiImage = UIImage(data: binaryData!)
    
    // Unwrap uiImage to see if it has a value
    if let imageObtained = uiImage {
        
        // Image is successfully obtained
        return Image(uiImage: imageObtained)
        
    } else {
        /*
         Image file with name 'defaultFilename' is returned if the image cannot be obtained
         from binaryData given. Image file 'defaultFilename' must be given in Assets.xcassets
         */
        return Image(defaultFilename)
    }
}
