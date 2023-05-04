//
//  LoginView.swift
//  GreenThumb
//
//  Created by Osman Balci on 5/25/22.
//  Copyright © 2022 Osman Balci. All rights reserved.
//
//  Edited by Taylor Flieg on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

/*
 
 */

import SwiftUI


struct LoginView : View {
    
    // Binding input parameter, we can change this value (read/write ability)
    @Binding var canLogin: Bool
    
    // ❎ Core Data managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ Core Data FetchRequest returning all Recipe entities from the database
    //to get images from database recipes
    @FetchRequest(fetchRequest: Plant.allPlantsFetchRequest()) var allPlants: FetchedResults<Plant>
    
    @State private var index = 0
    
    // State variables
    @State private var enteredPassword = ""
    @State private var showInvalidPasswordAlert = false
    @State private var showNoBiometricCapabilityAlert = false
    
    //TODO - variables for getting plant pics (recipes)

    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)

            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Image("Welcome")
                        .padding()
                    
                    Text("Green Thumb")
                        .font(.headline)
                        .padding()
                    
                    getImageFromBinaryData(binaryData: allPlants[index].primaryImage!, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                        .padding(.horizontal)
                        .onReceive(timer) { _ in
                            index += 1
                            if index > allPlants.count - 1 {
                                index = 0
                            }
                        }
                    
                    if allPlants[index].nickname != "" {
                        Text(allPlants[index].nickname ?? "")
                            .font(.system(size: 14, weight: .light, design: .serif))
                            .padding(.bottom)
                        
                    } else {
                        Text(allPlants[index].common_name ?? "")
                            .font(.system(size: 14, weight: .light, design: .serif))
                            .padding(.bottom)
                        
                    }
                    
                    SecureField("Password", text: $enteredPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) //style chosen for this textbox
                        .frame(width: 300, height: 36)
                        .padding()
                    
                    HStack {
                        //login button when pressed will try to validate the password by accedding the password stored in the default database
                        Button("Login") {
                            /*
                             UserDefaults provides an interface to the user’s defaults database,
                             where you store key-value pairs persistently across launches of your app.
                             */
                            // Retrieve the password from the user’s defaults database under the key "Password"
                            let validPassword = UserDefaults.standard.string(forKey: "Password")
                            
                            /*
                             If the user has not yet set a password, validPassword = nil
                             In this case, allow the user to login.
                             */
                            if validPassword == nil || enteredPassword == validPassword {
                                canLogin = true
                            } else {
                                showInvalidPasswordAlert = true
                            }
                        }
                        //styling for the button
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .padding()
                        
                        //allows user to reset their password if they have set a security question and answer in the app's settings
                        if UserDefaults.standard.string(forKey: "SecurityQuestion") != nil {
                            NavigationLink(destination: ResetPassword()) {
                                Text("Forgot Password")
                            }
                            .tint(.blue)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .padding()
                        }
                    }   // End of HStack
                    
                    /*
                     *********************************************************
                     *   Biometric Authentication with Face ID or Touch ID   *
                     *********************************************************
                     */
                    //very useful!
                    
                    // Enable biometric authentication only if a password has already been set
                    if UserDefaults.standard.string(forKey: "Password") != nil {
                        Button("Use Face ID or Touch ID") {
                            // authenticateUser() is given in UserAuthentication
                            authenticateUser() { status in
                                switch (status) {
                                case .Success:
                                    canLogin = true
                                    print("case .Success")
                                case .Failure:
                                    canLogin = false
                                    print("case .Failure")
                                case .Unavailable:
                                    canLogin = false
                                    showNoBiometricCapabilityAlert = true
                                    print("case .Unavailable")
                                }
                            }
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        //icons to represent face/touch id ability
                        HStack {
                            Image(systemName: "faceid")
                                .font(.system(size: 40))
                                .padding()
                            Image(systemName: "touchid")
                                .font(.system(size: 40))
                                .padding()
                        }
                    }
                    
                    Text("Powered By")
                        .font(.system(size: 18, weight: .light, design: .serif))
                        .italic()
                        .padding()
                    
                    // Show iTunes Search API website in default web browser
                    Link(destination: URL(string: "https://perenual.com/docs/api")!) {
                        HStack {
                            Image("PrenualApiLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                            Text("Pernual Plant API")
                        }
                    }
                    .padding(.bottom, 50)
                }   // End of VStack
                
            }   // End of ScrollView
            //similar to other tutorials to start/stop the timer controlling the slideshow
            .onAppear() {
                startTimer()
            }
            .onDisappear() {
                stopTimer()
            }
                
            }   // End of ZStack
            .alert(isPresented: $showInvalidPasswordAlert, content: { invalidPasswordAlert })
            .navigationBarHidden(true)
            
        }   // End of NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showNoBiometricCapabilityAlert, content: { noBiometricCapabilityAlert })
        
    }   // End of body var
    
    func startTimer() {
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
    //-----------------------
    // Invalid Password Alert
    //-----------------------
    var invalidPasswordAlert: Alert {
        Alert(title: Text("Invalid Password!"),
              message: Text("Please enter a valid password to unlock the app!"),
              dismissButton: .default(Text("OK")) )
        // Tapping OK resets showInvalidPasswordAlert to false
    }
    
     //------------------------------
     // No Biometric Capability Alert
     //------------------------------
    var noBiometricCapabilityAlert: Alert{
        Alert(title: Text("Unable to Use Biometric Authentication!"),
              message: Text("Your device does not support biometric authentication!"),
              dismissButton: .default(Text("OK")) )
        // Tapping OK resets showNoBiometricCapabilityAlert to false
    }
    
}
