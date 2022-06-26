//
//  ShowPlantsRoomView.swift
//  Gardn
//
//  Created by Harleen Kaur on 4/30/22.
//

import SwiftUI

struct ShowPlantsRoomView: View {
    
    @EnvironmentObject private var plantList: PlantList
    @State private var plantName = ""
    @State var room:String
    
    var body: some View {
        VStack {
            let r = getRoomFromString(r: self.room)
            let size = plantList.retPlantsInRoom(room: r).count;
            let plants = plantList.retPlantsInRoom(room: r);
            
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
                        
                        
                        
                        
                    }
                  
                    
                    
                }
                
          
        
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(red: 156 / 255, green: 200 / 255, blue: 150 / 255))
        
        
            }
       
        }

    }
    
}



