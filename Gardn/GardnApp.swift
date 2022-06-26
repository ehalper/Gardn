//
//  GardnApp.swift
//  Gardn
//
//


import SwiftUI

@main
struct GardnApp: App {
    
    
    @StateObject var plantList: PlantList = PlantList(url: try! FileManager.default.url(for: .documentDirectory,
                                                                                           in: .userDomainMask,
                                                                                           appropriateFor: nil,
                                                                                           create: false)
                                                        .appendingPathComponent("plants.json"))
    
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(plantList)
            
            
            
            
        }
        
    }
}
