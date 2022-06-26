//
//  ContentView.swift
//  Gardn
//
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Image("gardn")
                .resizable()
                .frame(width: 100.0, height: 220.0)
                .animation(Animation.easeInOut(duration: 1))
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(red: 156 / 255, green: 220 / 255, blue: 162 / 255))
    }
}


struct ContentView: View {
    @EnvironmentObject private var plantList: PlantList
    //@EnvironmentObject private var showAlertIA: Bool
    
    var body: some View {
        Text("").onAppear() {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Notifications allowed")
                } else if let error = error {
                    print("error")
                    print(error.localizedDescription)
                }
            }
            
            
        }
        VStack {
            TabView {      
                HomeView().tabItem {
                    Label("Home", systemImage: "house")
                }.foregroundColor(Color.green)
                AddPlantView().tabItem {
                    Label("Add Plants", systemImage: "plus")
                }
                ShowPlantsView().tabItem {
                    Label("My Plants", systemImage: "leaf.fill")
                }
                RoomView().tabItem{
                    Label("Rooms", systemImage: "bed.double.fill")
                }
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.init(red: 156 / 255, green: 220 / 255, blue: 162 / 255))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(PlantList(url: FileManager.default.temporaryDirectory.appendingPathComponent("e")))
        }
    }
}


