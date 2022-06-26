import Foundation
import SwiftUI

struct Plant: Codable {
    var name: String
    var type: String
    var notes: String
    var waterDay: Int
    var waterHour: Int
    var waterMin: Int
    var dateAdded: String
    var image: Data //Image not Codable, so storing as Data optional
    var notifID1: String
    var notifID2: String
    var reminderInSecs: Double
    var lastWatered: Date?
    var inRoom:Rooms
    
    init(img image: UIImage, name: String, type: String, notes: String, waterDay: Int, waterHour: Int, waterMin: Int,
         dateAdded: String, notifID1: String, notifID2: String, reminderInSecs: Double, lastWatered: Date?, inRoom:Rooms) {

        self.image = image.pngData()!
        self.name = name
        self.type = type
        self.notes = notes
        self.waterDay = waterDay
        self.waterHour = waterHour
        self.waterMin = waterMin
        self.dateAdded = dateAdded
        self.notifID1 = notifID1
        self.notifID2 = notifID2
        self.reminderInSecs = reminderInSecs
        self.lastWatered = lastWatered
        self.inRoom = inRoom
    }
    
    
    func timeToString(time: Date?) -> String {
        if time == nil {
            return "Has not been watered yet"
        } else {
            
            
            let df = DateFormatter()
            df.dateFormat = "yyyy"
            let y = df.string(from: time!)
            
            df.dateFormat = "MMM" //LLLL for full month
            let m = df.string(from: time!)
            
            df.dateFormat = "d"
            let d = df.string(from: time!)
            
            
            df.dateFormat = "hh:mm:ss a"
            let tim = df.string(from: time! as Date)
            
            
            let dateString = (tim + ", " + d + " " + m + " " + y)
            
            return dateString
        }
    }
    
    
}

class PlantList: ObservableObject {
    @Published private var plants: [Plant]
    @Published private var select: Int
    private var _url: URL
    
    init(url: URL) {
        plants = []
        select = 0
        _url = url
        let dec = JSONDecoder()
        if let d = try? Data(contentsOf: url) {
            if let plantData = try? dec.decode([Plant].self, from: d) {
                plants = plantData
            }
        }
        
    }
    
    func save() {
        DispatchQueue.global(qos: .background).async {
            let enc = JSONEncoder()
            if let d = try? enc.encode(self.plants) {
                try? d.write(to: self._url)
            }
        }
    }
    
    func updateLastWater(plantName: String, lastWater: Date) {
        var counter = 0
        for p in plants {
            if p.name == plantName {
                plants[counter].lastWatered = lastWater
                break
            }
            counter = counter + 1
        }
        
        save()
    }
    
    
    func addPlant(plant: Plant) {
        plants.append(plant)
        save()
    }
    
    func deletePlant(plant: String) {
        var counter = 0
        for i in plants{
            if i.name == plant {
                plants.remove(at: counter)
            }
            counter+=1
        }
        select = 0
        save()
    }
    
    func getPlantFromName(n: String) -> Plant? {
        for p in plants {
            if (p.name == n) {
                return p
            }
        }
        return nil
    }
    
    func retPlants() -> [Plant] {
        return plants
    }
    
    func retPlantsInRoom(room:Rooms) -> [Plant] {
        var lst:[Plant] = []
        for plant in plants{
            if(plant.inRoom == room){
                lst.append(plant)
            }
        }
        return lst
    }
    
    func containsName(n: String) -> Bool {
        for p in plants {
            if (p.name == n) {
                return true
            }
        }
        return false
    }
    
    
    func retSelect() -> Int {
        return select
    }
    
    func setSelect(i: Int) {
        select = i
    }
    
    func setSelectFromPlant(p: Plant) {
        var count = 0
        for plant in plants {
            if p.name == plant.name {
                select = count
            }
            count = count + 1
        }
    }
    
    func retSelectFromPlant() -> Plant {
        return plants[select]
    }
    
}



