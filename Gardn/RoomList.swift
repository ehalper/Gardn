//
//  RoomList.swift
//  Gardn
//
//  Created by Harleen Kaur on 4/30/22.
//

import Foundation
import SwiftUI

enum Rooms: String, CaseIterable, Identifiable, Codable{
    case  Living, Dining, Kitchen, Bedroom, Bathroom, Outside
    var id: Self { self }
}

func getRoomFromString(r:String) -> Rooms{
    for room in Rooms.allCases{
        if(room.rawValue == r){
            return room
        }
    }
    return Rooms.Living
}
