//
//  AddPlant.swift
//  GreenThumb
//
//  Created by Brian Wood on 4/23/23.
//  Copyright © 2023 Taylor Adeline Flieg, Christian Alexander Diaz, Brian Andrew Wood. All rights reserved.
//  Tutorial by Osman Balci.
//

//allows the user to add a new plant to their app

import SwiftUI

struct AddPlant: View {
    // Enable this view to be dismissed to go back to the previous view
    @Environment(\.dismiss) private var dismiss
    
    // ❎ Core Data managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // ❎ Core Data FetchRequest returning all Video entities from the database
    @FetchRequest(fetchRequest: Plant.allPlantsFetchRequest()) var allPlants: FetchedResults<Plant>
    
    @State private var plantLocationList: [String] = [""]
    @State private var selectedLocationIndex = 0
    
    //-----------------
    // Plant Attributes
    //-----------------
    @State private var customName = ""
    @State private var commonName = ""
    @State private var watering = ""
    @State private var sunlight = ""
    @State private var location = ""
    @State private var lastWatered = Date()
   
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long     // e.g., August 14, 2020
        return formatter
    }
   
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 40 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -40, to: Date())!
       
        // Set maximum date to 10 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        return minDate...maxDate
    }
    
    @State private var selectedNumber = 1
    @State private var selectedTimeUnit = TimeUnit.day

    enum TimeUnit: String, CaseIterable {
        case day = "Days"
        case week = "Weeks"
        case month = "Months"
        
        var days: Int {
            switch self {
            case .day:
                return 1
            case .week:
                return 7
            case .month:
                return 30
            }
        }
    }
    
    //------------------------------------
    // Image Picker from Camera or Library
    //------------------------------------
    @State private var showImagePicker = false
    @State private var pickedUIImage: UIImage?
    @State private var pickedImage: Image?
    
    @State private var useCamera = false
    @State private var usePhotoLibrary = true
    @State private var photoAdded = false
    
    //---------------
    // Alert Messages
    //---------------
    @State private var showAlertMessage = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    
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
        Form {
            Group {
                Section(header: Text("Plant Nickname")) {
                    TextField("Plant Custom Name", text: $customName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                }
                Section(header: Text("Plant Name")) {
                    TextField("Plant Common Name", text: $commonName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Watering Requirement")) {
                    HStack {
                        Picker("Every", selection: $selectedNumber) {
                            ForEach(1...10, id: \.self) { number in
                                Text("\(number)")
                            }
                        }
                        .frame(width: 100) // Set the width to fit the content
                                
                        Picker("Time Unit", selection: $selectedTimeUnit) {
                            ForEach(TimeUnit.allCases, id: \.self) { unit in
                                Text("\(unit.rawValue)")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    Text("Total Days: \(totalDays())")
                }
                
                Section(header: Text("Sunlight Requirement")) {
                    TextField("Full Sun, Partial Shade, etc", text: $sunlight)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Plant Location")) {
                    Picker("", selection: $selectedLocationIndex) {
                        ForEach(0 ..< plantLocationList.count, id: \.self) {
                            Text(plantLocationList[$0])
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    
                    if plantLocationList[selectedLocationIndex] == "Add New Location"{
                        TextField("Enter New Plant Location Name", text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
                    }
                }
                
                Section(header: Text("Last Watered Date")) {
                    DatePicker(
                        selection: $lastWatered,
                        in: dateClosedRange,
                        displayedComponents: .date // Sets DatePicker to pick a date
                    ){
                        Text("")
                    }
                }
                Section(header: Text("Take or Pick Plant Photo")) {
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
                if pickedImage != nil {
                    Section(header: Text("Plant photo")) {
                        pickedImage?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100.0, height: 100.0)
                    }
                }
            }
            
        }   // End of Form
        .onAppear {
            plantLocationList = generateLocationsList()
        }
        .navigationBarTitle(Text("Add New Plant"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                if inputDataValidated() {
                    saveNewPlant()
                    
                    showAlertMessage = true
                    alertTitle = "New Plant Added!"
                    alertMessage = "New plant is successfully added to your plants list."
                } else {
                    showAlertMessage = true
                    alertTitle = "Missing Input Data!"
                    alertMessage = "All fields must be filled in to add new plant."
                }
            }) {
                Text("Save")
        })
        .onChange(of: pickedUIImage) { _ in
            guard let uiImagePicked = pickedUIImage else { return }
            photoAdded = true
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
        .font(.system(size: 14))
        .alert(alertTitle, isPresented: $showAlertMessage, actions: {
            Button("OK") {
                if alertTitle == "New Plant Added!" {
                    // Dismiss this view and go back to the previous view
                    dismiss()
                }
            }
        }, message: {
            Text(alertMessage)
        })
    }
    
    /*
     ---------------------------
     MARK: Generate plant location list
     ---------------------------
     */
    func generateLocationsList() -> [String]{
        var locs = ["Add New Location", "Outdoors"]
        
        for aPlant in allPlants {
            let plantLoc = aPlant.location ?? ""
            
            if plantLoc != "" { // If plant has a location
                var newLoc = true // Start flagged as new location until duplicate found
                for loc in locs { // Search all saved locations to find duplicate
                    if loc == plantLoc {
                        newLoc = false // If plant location is duplicate than dont add
                    }
                }
                
                if newLoc && plantLoc != "" {
                    locs.append(plantLoc)
                }
            }
        }
        
        return locs
    }
    
    func totalDays() -> Int {
        return selectedNumber * selectedTimeUnit.days
    }
    
    /*
     ---------------------------
     MARK: Input Data Validation
     ---------------------------
     */
    func inputDataValidated() -> Bool {
        // If Plant name is not filled in
        if customName.isEmpty {
            return false
        }
        return true
    }
    
    /*
    -----------------------------
    MARK: Save New Plant
    -----------------------------
    */
    func saveNewPlant() {
        //---------------------------------------------------------------
        // Create a new instance of the Plant struct
        //---------------------------------------------------------------
        // 1️⃣ Create an instance of the Video entity in managedObjectContext
        let plantEntity = Plant(context: managedObjectContext)
        
        
        //--------------------------------------------------
        // Store Taken or Picked photo to Document Directory
        //--------------------------------------------------
        if photoAdded {
            // Convert pickedUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            if let photoData = pickedUIImage?.jpegData(compressionQuality: 1.0) {
                
                // Assign photoData to Core Data entity attribute of type Data (Binary Data)
                plantEntity.primaryImage = photoData
                
            } else {
                // Obtain image 'ImageUnavailable' from Assets.xcassets as UIImage
                let photoUIImage = UIImage(named: "ImageUnavailable")
                
                // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
                let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
                
                // Assign photoData to Core Data entity attribute of type Data (Binary Data)
                plantEntity.primaryImage = photoData!
            }
        }
        
        // 2️⃣ Dress it up by specifying its attributes
        plantEntity.nickname = customName
        plantEntity.common_name = commonName
        plantEntity.sunlight = [sunlight]
        plantEntity.watering = String(totalDays())
        plantEntity.id = (allPlants.count + 1) as NSNumber
        plantEntity.lastWateringDate = lastWatered
        plantEntity.diseased = false
        plantEntity.starred = false
        
        if plantLocationList[selectedLocationIndex] == "Add New Location" { // If new location is added use loc field as value
            plantEntity.location = location
        } else { // Otherwise use value from plant location list
            plantEntity.location = plantLocationList[selectedLocationIndex]
        }
        
        //create photo gallery entry
        let photoEntity = Photo(context: managedObjectContext)
        photoEntity.image = plantEntity.primaryImage
        photoEntity.title = "First photo."
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: Date())
        photoEntity.date = dateString
        
        photoEntity.plant = plantEntity
        
        // 3️⃣ It has no relationship to another Entity
        PersistenceController.shared.saveContext()
    
        
        // Initialize @State variables
        showImagePicker = false
        pickedUIImage = nil
    }   // End of function
}

struct AddPlant_Previews: PreviewProvider {
    static var previews: some View {
        AddPlant()
    }
}
