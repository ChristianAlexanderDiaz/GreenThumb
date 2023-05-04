//
//  Home.swift
//  GreenThumb
//
//  Created by Taylor Adeline Flieg on 4/24/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//
//  Tutorial by Osman Balci on 3/10/23.
//  Copyright © 2023 Osman Balci. All rights reserved.
//

/*
 
 */

import SwiftUI
import CoreData

struct Home: View {
    
    // ❎ Core Data managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ Core Data FetchRequest returning all Recipe entities from the database
    //to get images from database recipes
    @FetchRequest(fetchRequest: Plant.allPlantsFetchRequest()) var allPlants: FetchedResults<Plant>
    
    @FetchRequest(fetchRequest: Plant.wateringNeedsFetchRequest()) var WateringPlantCareList: FetchedResults<Plant>
    
    @State private var index = 0
    
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            
        ScrollView(.vertical, showsIndicators: false) {
            //welcome image
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
                
                HStack{
                    Text("\(WateringPlantCareList.count)")
                      .padding()
                      .background(.green)
                      .clipShape(Circle())
                    if WateringPlantCareList.count == 1 {
                        Text(" plant needs watering today")
                    } else {
                        Text(" plants need watering today")
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
        .onAppear() {
            startTimer()
        }
        .onDisappear() {
            stopTimer()
        }

        }   // End of ZStack
    }   // End of var
    
    //timer management functions
    func startTimer() {
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
