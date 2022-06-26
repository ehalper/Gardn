import SwiftUI

struct ShowPlantsView: View {
    
    @EnvironmentObject private var plantList: PlantList
    @State private var plantName = ""
    
    
    var body: some View {
        VStack {
            
            let size = plantList.retPlants().count;
            let plants = plantList.retPlants();
            
            NavigationView {
      
            //prints current plants in list
            ScrollView {
                VStack {
                
                    
                    if size != 0 {
                        
                        ForEach(1..<size, id: \.self) { i in
                            
                            let p = plants[i]
                            
                            
                            NavigationLink(destination: PlantView()) {
                                HStack {
                                    Text((p.name)).font(.system(size: 15.0)).padding()
                                    Spacer()
                                    Text((p.type)).font(.system(size: 15.0)).padding()
                                    Spacer()
                                    
                                    let days = (p.waterDay)
                                    Spacer()
                                    let hours = (p.waterHour)
                                    Spacer()
                                    let minutes = (p.waterMin)
                                    
                                    Text(String(days) + " days").font(.system(size: 15.0)).padding()
                                    Text(String(hours) + " hours").font(.system(size: 15.0)).padding()
                                    Text(String(minutes) + " mins").font(.system(size: 15.0)).padding()
                                    
                                }
                            }.simultaneousGesture(TapGesture().onEnded{
                                print("tap!" + String(i))
                                plantList.setSelect(i: i)
                                
                            })
                            
                        }
                        
                        HStack {
                            Text("Enter Name of Plant to Remove: ")
                            TextField("Name", text: $plantName) {}
                            
                        }.padding()
                        
                        
                        Button("Remove Plant") {
                            if (plantList.containsName(n: plantName)) {
                                plantList.setSelect(i: 0)
                                
                                var plant = plantList.getPlantFromName(n: plantName)
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(plant?.notifID1)!])
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(plant?.notifID2)!])
                                plantList.save()
                                
                                /*
                                 let center = UNUserNotificationCenter.current()
                                 center.getPendingNotificationRequests(completionHandler: { requests in
                                 for request in requests {
                                 print(request)
                                 }
                                 })
                                 */
                                
                                plantList.deletePlant(plant: plantName)
                                
                                plantName = String()
                            } else {
                                print("Cannot be removed, no plant with that name.")
                            }
                        }
                    }
                  
                    
                    
                }
                
          
        
            }.navigationTitle("My Plants").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(red: 156 / 255, green: 200 / 255, blue: 150 / 255))
        
        
            }
       
        }

    }
    
}



