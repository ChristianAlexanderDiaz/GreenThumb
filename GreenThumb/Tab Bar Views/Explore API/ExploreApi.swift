//
//  ExploreApi.swift
//  GreenThumb
//
//  Created by Christian Alexander Diaz on 4/11/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct ExploreApi: View {
    @State private var searchValue = ""
    @State private var searchCompleted = false
    @State private var isLoading = false
    
    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
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
                if isLoading {
                Section(header: Text("Loading")) {
                        ProgressView()
                    }
                }
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
            } //end of Form
        } //end of NavigationView
    } //end of some view
    
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

        getFoundPlantsFromApi(query: termWithNoSpace)
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
