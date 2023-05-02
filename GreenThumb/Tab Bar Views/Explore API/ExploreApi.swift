//
//  ExploreApi.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct ExploreApi: View {
    //values for searching
    @State private var searchValue = ""
    @State private var searchCompleted = false
    
    //alert messages
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    //api status
    @State private var apiStatus: APIStatus = .unknown
    
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
        NavigationView {
            Form {
                Section(header: Text("Look up a Plant")) {
                    HStack {
                        TextField("Enter a Plant", text: $searchValue)
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
                } //end of Section 1
                Section(header: Text("Search Plant")) {
                    HStack {
                        Spacer()
                        Button(searchCompleted ? "Search Completed" : "Search") {
                            if inputDataValidated() {
                                searchApi()
                                searchCompleted = true
                            } else {
                                showAlertMessage = true
                                alertTitle = "Missing Plant Name!"
                                alertMessage = "A plant name is required!"
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        Spacer()
                    } //end of HStack
                } //end of Section 2
                if searchCompleted {
                    Section(header: Text("Plants Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Plants Found")
                                    .font(.system(size: 16))
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
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
            } //end of Form
            .onAppear(perform: {
                checkApiStatus()
            })
        } //end of NavigationView
    } //end of some view
    
    /**
        A function called `checkApiStatus` that gives me the correct enumeration for the status of the API search.
     */
    func checkApiStatus() {
        let urlString = "https://perenual.com/docs/api"
        guard let url = URL(string: urlString) else {
            self.apiStatus = .offline
            return
        }

        let task = URLSession.shared.dataTask(with: url) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.apiStatus = .offline
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.apiStatus = .online
                    } else {
                        self.apiStatus = .offline
                    }
                } else {
                    self.apiStatus = .offline
                }
            }
        }
        task.resume()
    }
    
    /*
     -------------------------
     MARK: Show Search Results
     -------------------------
     */
    var showSearchResults: some View {
        if foundPlantDetails.isEmpty {
            return AnyView(
                NotFound(message: "The Perenual API did not return any plant for the query entered.")
            )
        }

        return AnyView(ExploreApiResultsList(exploreApiResultPlants: foundPlantDetails))
    }
    
    /*
     ----------------
     MARK: Search API
     ----------------
     */
    func searchApi() {
        let termCleaned = searchValue.trimmingCharacters(in: .whitespacesAndNewlines)

        // Each space in the query should be converted to +
        let termWithNoSpace = termCleaned.replacingOccurrences(of: " ", with: "+")

        getFoundPlantsFromApi(query: termWithNoSpace, maxResults: 5)
        
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {

        let queryTrimmed = searchValue.trimmingCharacters(in: .whitespacesAndNewlines)

        if queryTrimmed.isEmpty {
            return false
        }
        return true
    }
}

struct ExploreApi_Previews: PreviewProvider {
    static var previews: some View {
        ExploreApi()
    }
}
