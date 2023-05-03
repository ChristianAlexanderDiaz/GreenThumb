//
//  AddPhotoView.swift
//  GreenThumb
//
//  Created by Brian Wood on 5/2/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//

import SwiftUI

struct AddPhotoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var pickedImage: Image?
    @State private var photoTitle = ""
    
    let plant: Plant
    
    init(plant: Plant) {
        self.plant = plant
    }
    
    var body: some View {
        let camera = Binding(
            get: { useCamera },
            set: {
                useCamera = $0
                if $0 == true {
                    usePhotoLibrary = false
                }
            }
        )
        let photoLibrary = Binding(
            get: { usePhotoLibrary },
            set: {
                usePhotoLibrary = $0
                if $0 == true {
                    useCamera = false
                }
            }
        )
        NavigationView {
            VStack {
                if pickedImage != nil {
                    pickedImage?
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Text("No photo selected.")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Section() {
                    VStack {
                        Toggle("Use Camera", isOn: camera)
                        Toggle("Use Photo Library", isOn: photoLibrary)
                        
                        Button("Get Photo") {
                            showImagePicker = true
                        }
                        .tint(.blue)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                    }
                }
                .tint(.green)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .padding()
                
                TextField("Photo Title", text: $photoTitle)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Button("Save Photo") {
                    savePhoto()
                    dismiss()
                }
                .tint(.green)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .padding()
                
            }
            .navigationBarTitle(Text("Add Photo"), displayMode: .inline)
            .onChange(of: pickedUIImage) { _ in
                guard let uiImagePicked = pickedUIImage else { return }
                // Convert UIImage to SwiftUI Image
                pickedImage = Image(uiImage: uiImagePicked)
            }
            .sheet(isPresented: $showImagePicker) {
                /*
                 For storage and performance efficiency reasons, scale down the plant image selected from the
                 photo library or taken by the camera to a smaller size with imageWidth and imageHeight
                 */
                ImagePicker(uiImage: $pickedUIImage, sourceType: useCamera ? .camera : .photoLibrary, imageWidth: 200.0, imageHeight: 200.0)
            }
        }
    }
    
    func savePhoto() {
        if let photoData = pickedUIImage?.jpegData(compressionQuality: 1.0) {
            let photo = Photo(context: viewContext)
            photo.image = photoData
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: Date())
            photo.date = dateString

            photo.title = photoTitle.isEmpty ? "Untitled" : photoTitle
            photo.plant = plant
            
            PersistenceController.shared.saveContext()
            
            pickedImage = Image(uiImage: UIImage(data: photoData)!)
        }
    }
    
    @State private var useCamera = false
    @State private var usePhotoLibrary = true
    
    var cameraBinding: Binding<Bool> {
        Binding(
            get: { useCamera },
            set: {
                useCamera = $0
                usePhotoLibrary = !$0
            }
        )
    }
    
    var photoLibraryBinding: Binding<Bool> {
        Binding(
            get: { usePhotoLibrary },
            set: {
                usePhotoLibrary = $0
                useCamera = !$0
            }
        )
    }
}

