//
//  PlantDiseases.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

/**
    A struct called `PlantDiseases` that conforms to a View which is similar to ExploreApi,
    but is the exactly same UI, just for looking up `Disease`s that plants to be affected by.
 */
struct PlantDiseases: View {
    // Values for Searching
    @State private var searchValue = ""
    @State private var searchCompleted = false
    
    // Alert messages
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    //New features:
    
    // APIi status
    @State private var apiStatus: APIStatus = .unknown
    
    // Slider value
    @State private var maxResults: Double = 3
    
    /**
        An enumation called `APIStatus` that gives the cases for what the status of the website is.
     */
    enum APIStatus {
        case unknown, online, offline
    }
    
    /**
        A body that pertains the `some View` which contains all the `Form` items in there.
     */
    var body: some View {
            Form {
                // A section that has the API status UI
                Section(header: Text("API Status")) {
                    HStack {
                        if apiStatus == .online {
                            Text("API is online")
                                .foregroundColor(.green)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else if apiStatus == .offline {
                            Text("API is offline, Service Unavailable")
                                .foregroundColor(.red)
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        } else {
                            Text("Checking API...")
                                .foregroundColor(Color(red: 0.8, green: 0.6, blue: 0))
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(Color(red: 0.8, green: 0.6, blue: 0))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                // A Section with a UI slider with the number of results
                Section(header: Text("Number of Results"), footer: Text("Selected Number: \(Int(maxResults))").italic()) {
                    HStack {
                        Text("1")
                        Slider(value: $maxResults, in: 1...10, step: 1)
                        Text("10")
                    }
                }
                // A Section that you can look up a Disease
                Section(header: Text("Look up a Disease"), footer: Text("Powered by Perenual API").italic()) {
                    HStack {
                        TextField("Enter a Disease", text: $searchValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                        Button(action: {
                            searchValue = ""
                            showAlertMessage = false
                            searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        } //end of button extension
                    } //end of HStack
                }
                // A section that has a button to confirm your query
                Section(header: Text("Search Disease")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchApi()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Disease Name!"
                                alertMessage = "A disease name is required!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        Spacer()
                    } //end of HStack
                }
                if searchCompleted {
                    Section(header: Text("Diseases Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Diseases Found")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
            } //end of Form
            .onAppear(perform: {
                checkApiStatus()
            })
            .navigationBarTitle(Text("Plant Diseases API"), displayMode: .inline)
    } //end of some view
    
    /**
        A function called `checkApiStatus` that gives me the correct enumeration for the status of the API search.
     */
    func checkApiStatus() {
        // Define the URL for the API to be checked
        let urlString = "https://perenual.com/docs/api"
        
        // Try to create a URL object from the given string
        guard let url = URL(string: urlString) else {
            // If the URL is invalid, set the API status to offline and return
            self.apiStatus = .offline
            return
        }
        
        // Create a URLSession data task to make a request to the API URL
        let task = URLSession.shared.dataTask(with: url) { _, response, error in
            // Ensure the completion handler executes on the main thread
            DispatchQueue.main.async {
                // Check if there is an error returned from the API request
                if let error = error {
                    // If there is an error, set the API status to offline
                    print("Error: \(error.localizedDescription)")
                    self.apiStatus = .offline
                // Check if the response is an HTTPURLResponse
                } else if let httpResponse = response as? HTTPURLResponse {
                    // If the response status code is 200 (OK), set the API status to online
                    if httpResponse.statusCode == 200 {
                        self.apiStatus = .online
                    // If the response status code is not 200, set the API status to offline
                    } else {
                        self.apiStatus = .offline
                    }
                // If the response is not an HTTPURLResponse, set the API status to offline
                } else {
                    self.apiStatus = .offline
                }
            }
        }
        // Start the data task to make the API request
        task.resume()
    }
    
    /**
        A variable called `showSearchResults` that conforms to some View which if the foundPlant is empty, it shows a `NotFound` page, if it shows with results, it will show that List
     */
    var showSearchResults: some View {
        // Check if there are any found plant details to display
        if foundPlantDetails.isEmpty {
            // If there are no found plant details, return the NotFound view
            return AnyView(
                NotFound(message: "The Perenual API did not return any plant for the query entered.")
            )
        }

        // If there are found plant details, return the ExploreApiResultsList view
        return AnyView(ExploreApiResultsList(exploreApiResultPlants: foundPlantDetails))
    }

    /**
        A function called `searchApi` which takes the query and the max results value and searches for that value, the query also makes sure that it is able to be searched through the API by adding '+' for each space.
     */
    func searchApi() {
        // Clean the search value of any whitespace and newline characters
        let termCleaned = searchValue.trimmingCharacters(in: .whitespacesAndNewlines)

        // Replace each space in the query with a '+' to ensure it can be searched through the API
        let termWithNoSpace = termCleaned.replacingOccurrences(of: " ", with: "+")

        // Call the getFoundPlantsFromApi function to search for plants matching the given query and max results value
        getFoundPlantsFromApi(query: termWithNoSpace, maxResults: Int(maxResults))
    }

    /**
        A function called `inputDataValidated` which returns a `Boolean` value that the searchValue isn't empty.
     */
    func inputDataValidated() -> Bool {
        // Clean the search value of any whitespace and newline characters
        let queryTrimmed = searchValue.trimmingCharacters(in: .whitespacesAndNewlines)

        // Check if the cleaned search value is empty or not, and return a boolean value accordingly
        if queryTrimmed.isEmpty {
            return false
        }
        return true
    }
}
