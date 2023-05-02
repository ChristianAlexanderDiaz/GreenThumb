//
//  PlantGrowthImages.swift
//  GreenThumb
//
//  Created by Brian Wood on 5/2/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct PlantGrowthImages: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Photo.entity(), sortDescriptors: [], predicate: nil) var photos: FetchedResults<Photo>
    
    let plant: Plant
    
    @State private var showPhotoInfoAlert = false
    @State private var selectedPhoto: Photo?
    @State private var showAddPhotoSheet = false
    
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 5)]
    
    init(plant: Plant) {
        self.plant = plant
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(photos.filter { $0.plant == plant }, id: \.self) { photo in
                    getImageFromBinaryData(binaryData: photo.image, defaultFilename: "ImageUnavailable")
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            showPhotoInfoAlert = true
                            selectedPhoto = photo
                        }
                        .id(photo.id)
                }
            }
            .padding()
        }
        .alert(isPresented: $showPhotoInfoAlert) {
            photoInfoAlert(photo: selectedPhoto ?? Photo())
        }
        .navigationBarItems(trailing:
            Button(action: {
                showAddPhotoSheet = true
            }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $showAddPhotoSheet) {
            AddPhotoView(plant: plant)
                .environment(\.managedObjectContext, viewContext)
        }
    }
    
    func photoInfoAlert(photo: Photo) -> Alert {
        let dateString = photo.date ?? "Unknown"
        return Alert(
            title: Text(photo.title ?? ""),
            message: Text("Photo taken on " + dateString),
            dismissButton: .default(Text("OK")))
    }
}
