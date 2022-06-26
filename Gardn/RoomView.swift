//
//  RoomView.swift
//  Gardn
//
//  Created by Harleen Kaur on 4/30/22.
//

import Foundation
import SwiftUI

struct RoomView: View {
    @EnvironmentObject private var plantList: PlantList
    
    var body: some View {
        VStack{
            Text("Rooms").font(.system(.title))
            NavigationView{
                ScrollView{
                    VStack{
                        ForEach(Rooms.allCases) { room in
                            NavigationLink(destination: ShowPlantsRoomView(room: room.rawValue)) {
                                Text(room.rawValue.capitalized).font(.system(size: 15.0)).padding().multilineTextAlignment(.center)
                                Spacer()
                            }.simultaneousGesture(TapGesture().onEnded({
                                
                            }))
                        }
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(red: 156 / 255, green: 200 / 255, blue: 150 / 255))
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(red: 156 / 255, green: 200 / 255, blue: 150 / 255))
    }
}

