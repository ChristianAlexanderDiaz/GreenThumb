//
//  ResetPassword.swift
//  GreenThumb
//
//  Created by Osman Balci on 5/25/22.
//  Copyright © 2022 Osman Balci. All rights reserved.
//

import SwiftUI

struct ResetPassword: View {
    
    @State private var showEnteredValues = false
    @State private var answerTextFieldValue = ""
    @State private var answerEntered = ""
    
    var body: some View {
        Form {
            //first section is a toggle to hide or show the security question answer, which controls whether its a text field or a secured field. state variable so that it can refresh the page to change the section field type upon change
            Section(header: Text("Show / Hide Entered Values")) {
                Toggle(isOn: $showEnteredValues) {
                    Text("Show Entered Values")
                }
            }
            //section showing the chosen security question
            Section(header: Text("Security Question")) {
                Text(UserDefaults.standard.string(forKey: "SecurityQuestion")!)
            }
            //section for entering the answer, which is either text or secured field as chosen by the user
            Section(header: Text("Enter Answer to the Security Question You Selected")) {
                HStack {
                    //answerTextFieldValue being a state variable allows user to even change the showEnteredValues value when text is entered here and have it remain in the text/secured field box
                    if showEnteredValues {
                        TextField("Enter Answer", text: $answerTextFieldValue,
                            onCommit: {
                                // Record entered value after Return key is pressed
                                answerEntered = answerTextFieldValue
                            }
                        )
                        //formatting to keep looking the same when changed to secure field
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 260, height: 36)
                    } else {
                        SecureField("Enter Answer", text: $answerTextFieldValue,
                            onCommit: {
                                // Record entered value after Return key is pressed
                                answerEntered = answerTextFieldValue
                            }
                        )
                        //formatting to keep looking the same when changed to text field
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 260, height: 36)
                    }
                    // Button to clear the text field
                    Button(action: {
                        answerTextFieldValue = ""
                        answerEntered = ""
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                    .padding()
                }
            }
            //if answer is correct, allows user to navigate to the settings page only to reset their passwork
            if answerEntered == UserDefaults.standard.string(forKey: "SecurityAnswer")! {
                Section(header: Text("Go to Settings to Reset Password")) {
                    NavigationLink(destination: Settings()) {
                        HStack {
                            Image(systemName: "gear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Settings")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.blue)
                        .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                    }
                }
            } else {
                //if answer is incorrect, will alert so with this new section
                if !answerEntered.isEmpty {
                    Section(header: Text("Incorrect Answer")) {
                        Text("Answer to the Security Question is Incorrect!")
                    }
                }
            }
            
        }   // End of Form
        // Set font and size for the whole Form content
        .font(.system(size: 14))
        .navigationBarTitle(Text("Password Reset"), displayMode: .inline)
        
    }   // End of body var
}

struct ResetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ResetPassword()
    }
}
