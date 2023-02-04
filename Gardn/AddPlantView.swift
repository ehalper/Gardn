import SwiftUI
import UIKit

struct AddPlantView: View {
    
    @EnvironmentObject private var plantList: PlantList
    
    //@EnvironmentObject private var showAlertIA: Bool
        
    @State private var name: String = String()
    @State private var type: String = String()
    @State private var notes: String = String()
    
    @State private var days: Double = 0
    @State private var hours: Double = 0
    @State private var mins: Double = 0
    
    @State private var showPhotoLib = false
    @State private var showCamera = false
    @State private var presentActionSheet = false
    @State private var inputImage = UIImage(named: "plant")!
    
    @State private var showAlert = false
    
    @State private var selectedRoom:Rooms = .Living
    
    var body: some View {
        VStack {
            Text("Add New Plant Reminder")
            
            HStack {
                Text("New Plant: ")
                TextField("Name", text: $name) {}
                TextField("Type", text: $type ) {}
                
            }.padding()
            
            HStack {
                Text("Plant Image: ")
                Image(uiImage:self.inputImage).resizable().aspectRatio(contentMode: .fit).padding().onTapGesture {
                    self.presentActionSheet = true
                }
                
            }.padding()
            
            HStack {
                Text("Enter Notes: ")
                TextField("Notes", text: $notes) {}
            }.padding()
            
            HStack{
                Text("Pick the room in which the plant lives: ")
                Picker("Room", selection: $selectedRoom){
                    ForEach(Rooms.allCases) { room in
                            Text(room.rawValue.capitalized)
                        }
                }
            }.background(Color.init(red: 156 / 255, green: 200 / 255, blue: 162 / 255))
            
            Text("How often do you want to be reminded to water your new plant? Every...")
            
            HStack {
                Slider(value: $days, in: 0...31, step: 1)
                Text(String(Int(days)) + " days")
            }.padding()
            
            HStack {
                Slider(value: $hours, in: 0...23, step: 1)
                Text(String(Int(hours)) + " hours")
            }.padding()
            
            HStack {
                Slider(value: $mins, in: 0...59, step: 1)
                Text(String(Int(mins)) + " minutes")
            }.padding()
            
            
            Button("Add Plant!") {
                
                //doesn't add plant if another plant has same name or if any of fields are incomplete
                if (plantList.containsName(n: name)) {
                    print("Plant with same name, can't add it.")
                    
                } else if ((name == String() || type == String()) ||
                           (days == 0 && hours == 0 && mins == 0)) {
                    print("Plant needs name, type, and water time info.")
                    
                    
                } else {
                    //gets date for when plant gets added
                    let date = Date()
                    let df = DateFormatter()
                    df.dateFormat = "yyyy"
                    let y = df.string(from: date)
                    
                    df.dateFormat = "LLLL"
                    let m = df.string(from: date)
                    
                    df.dateFormat = "d"
                    let d = df.string(from: date)
                    
                    let dateString = (m + " " + d + ", " + y)
                    
                    
                    //converts time into seconds
                    var reminderInSecs = 0.0
                    if days != 0 {
                        reminderInSecs += days * 86400.0
                    }
                    if hours != 0 {
                        reminderInSecs += hours * 3600.0
                    }
                    if mins != 0 {
                        reminderInSecs += mins * 60.0
                    }
                    
                    
                    
                    //outside app notifications
                    //first (main) notification
                    let content = UNMutableNotificationContent()
                    content.title = name + " needs some care."
                    content.subtitle = "Water plant!"
                    content.sound = UNNotificationSound.default
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reminderInSecs, repeats: false) //uses reminder time
                    let id = UUID().uuidString
                    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                    
                    
                    
                    //outside app notifications
                    //second (follow-up) notification
                    let content2 = UNMutableNotificationContent()
                    content2.title = "Reminder to water " + name
                    content2.subtitle = "Water plant!"
                    content2.sound = UNNotificationSound.default
                    let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: reminderInSecs + 3600, repeats: false) //uses reminder time + 1 hour
                    let id2 = UUID().uuidString
                    let request2 = UNNotificationRequest(identifier: id2, content: content2, trigger: trigger2)
                    
                    
                    //does follow-up notification if plant has not been watered within the amount that the user specified + an hour of buffer
                    //using 1 hour buffer before follow-up reminder gets sent
                    let lastWatered = date
                    UNUserNotificationCenter.current().add(request2)
                    
                    
                    //adds a plant at index 0 as a placeholder for when a plant gets removed (avoids index out of bounds error from PlantView if only plant gets removed)
                    if plantList.retPlants().count == 0 {
                        let plant = Plant(img: self.inputImage, name: "", type: "", notes: "", waterDay: 0, waterHour: 0, waterMin: 0, dateAdded: "", notifID1: "", notifID2: "", reminderInSecs: 0.0, lastWatered: nil, inRoom:selectedRoom)
                        plantList.addPlant(plant: plant)
                    }
                    
                    
                    let p = Plant(img: self.inputImage, name: name, type: type, notes: notes, waterDay: Int(days), waterHour: Int(hours), waterMin: Int(mins), dateAdded: dateString, notifID1: id, notifID2: id2, reminderInSecs: reminderInSecs, lastWatered: nil,inRoom:selectedRoom)
                    
                    
                    //image: Image(uiImage: self.inputImage)
                    plantList.addPlant(plant: p)
                    plantList.setSelectFromPlant(p: p)
                    
                    
                    //resets entry fields after plant gets added
                    name = String()
                    type = String()
                    notes = String()
                    days = 0
                    hours = 0
                    mins = 0
                    inputImage = UIImage(named: "plant") ?? UIImage(named: "plant")!
                    selectedRoom = .Living
                    
                    
                }
                
                
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(red: 156 / 255, green: 200 / 255, blue: 162 / 255)).sheet(isPresented: $showPhotoLib){
            ImagePicker(sourceType: .photoLibrary, image: self.$inputImage)
        }.sheet(isPresented: $showCamera){
            ImagePicker(sourceType: .camera, image: self.$inputImage)
        }.actionSheet(isPresented: $presentActionSheet){
            ActionSheet(title: Text("Change Plant Image"),
                        message: Text("Please pick if you would like to use the camera to take the picture or upload picture from camera roll"),
                        buttons: [.cancel(),
                                  .default(Text("Camera Roll"), action: {self.showPhotoLib = true}),
                                  .default(Text("Camera"), action: {self.showCamera = true})])
            
        }
    }
    
    
}


