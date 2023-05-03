//
//  ApiKeyManager.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 5/3/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import Foundation

/**
    A class called ApiKeyManager that allows `Settings.swift` and `PerenualApiData.swift`
    the ability to run a getter and a setter for the API key because both these files needs this.
 */
class ApiKeyManager {
    // Create a singleton instance of the ApiKeyManager class.
    static let shared = ApiKeyManager()
    
    // Set a default API key value to be used if none is provided.
    private let defaultApiKey = "sk-LAYB6435bb62d3145488"

    // Create a private initializer for the ApiKeyManager class.
    // This initializer sets the default API key value if no API key has been set yet.
    private init() {
        if perenualApiKey == nil {
            perenualApiKey = defaultApiKey
        }
    }
    
    // This computed property with the API value allows other parts of the application to get or set the API key.
    var perenualApiKey: String? {
        get {
            // Retrieve the API key value from UserDefaults.
            return UserDefaults.standard.string(forKey: "key")
        }
        set {
            // Save a new API key value to UserDefaults.
            UserDefaults.standard.set(newValue, forKey: "key")
        }
    }
}
