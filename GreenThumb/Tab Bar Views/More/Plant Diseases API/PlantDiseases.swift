//
//  PlantDiseases.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct PlantDiseases: View {
    //values for searching
    @State private var searchValue = ""
    @State private var searchCompleted = false
    
    //alert messages
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    //new features
    
    //api status
    @State private var apiStatus: APIStatus = .unknown
    
    //slider value
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
                Section(header: Text("Number of Results"), footer: Text("Selected Number: \(Int(maxResults))").italic()) {
                    HStack {
                        Text("1")
                        Slider(value: $maxResults, in: 1...10, step: 1)
                        Text("10")
                    }
                }
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
                } //end of Section 1
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
                } //end of Section 2
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
        if foundDiseaseDetails.isEmpty {
            return AnyView(
                NotFound(message: "The Perenual API did not return any plant for the query entered.")
            )
        }

        return AnyView(DiseaseApiResultsList(diseaseAPIStructDetails: foundDiseaseDetails))
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

        getFoundDiseasesFromApi(query: termWithNoSpace, maxResults: Int(maxResults))
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
