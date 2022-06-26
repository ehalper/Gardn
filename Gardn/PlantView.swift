import SwiftUI
import UIKit

struct PlantView: View {
    
    @EnvironmentObject private var plantList: PlantList
    
    var body: some View {
        
        let plantSelectedIndex = plantList.retSelect()
        

        
            let plantSelected = plantList.retPlants()[plantSelectedIndex]
        
 
            let image = UIImage(data: plantSelected.image) //convert image as Data to image as UIImage
            
                
        
        
            let lastWateredString = plantSelected.timeToString(time: plantSelected.lastWatered)
        
      
        
        
        
        ScrollView {
            VStack {
                Group{
                    Text("Name: " + plantSelected.name)
                    Text("Type: " + plantSelected.type)
                    Text("Notes: " + plantSelected.notes)
                }.padding()
                
                
                Image(uiImage: image!).resizable().aspectRatio(contentMode: .fit).padding()
                
                
                Text("Water Reminder Schedule Set for Every: " ).padding()
                
                HStack {
                    if (plantSelected.waterDay != 0) {
                        Text(String(plantSelected.waterDay) + " days").padding()
                    }
                    if (plantSelected.waterHour != 0) {
                        Text(String(plantSelected.waterHour) + " hours").padding()
                    }
                    if (plantSelected.waterMin != 0) {
                        Text(String(plantSelected.waterMin) + " minutes").padding()
                    }
                    
                }
                Spacer()
                
                
                Button("Just watered") {
                    
                    //remove current notification requests that were lined up for the plant because it just got watered, so they should reset as such
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ([plantSelected.notifID1]))
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ([plantSelected.notifID2]))
                    
                    let date = Date()
                    plantList.updateLastWater(plantName: plantSelected.name, lastWater: date)
                    
                    
                    //outside app notifications
                    //first (main) notification
                    let content = UNMutableNotificationContent()
                    content.title = plantSelected.name + " needs some care."
                    content.subtitle = "Water plant!"
                    content.sound = UNNotificationSound.default
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: plantSelected.reminderInSecs, repeats: false) //uses reminder time
                    let id = UUID().uuidString
                    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                    
                    
                    //second (follow-up) notification
                    let content2 = UNMutableNotificationContent()
                    content2.title = "Reminder to water " + plantSelected.name
                    content2.subtitle = "Water plant!"
                    content2.sound = UNNotificationSound.default
                    let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: plantSelected.reminderInSecs + 3600, repeats: false) //uses reminder time + 1 hour
                    let id2 = UUID().uuidString
                    let request2 = UNNotificationRequest(identifier: id2, content: content2, trigger: trigger2)
                    
                    
                    //does follow-up notification if plant has not been watered within the amount that the user specified + an hour of buffer
                    //using 1 hour buffer before follow-up reminder gets sent
                    UNUserNotificationCenter.current().add(request2)
                    let lastWatered = date
                    
                    plantList.setSelectFromPlant(p: plantSelected)
                    
                    
                    
                    
                    
                }.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(red: 156 / 255, green: 220 / 255, blue: 162 / 255))
                    
                
                
                Text("Last Watered: " + plantSelected.timeToString(time: plantSelected.lastWatered))
                
                Spacer()
                Text("Date Added: " + plantSelected.dateAdded)
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(red: 156 / 255, green: 220 / 255, blue: 162 / 255))
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(red: 156 / 255, green: 220 / 255, blue: 162 / 255))
        
    }
    
}


