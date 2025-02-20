//
//  Entity.swift
//  CrudLibrarySwiftUI
//
//  Created by JECASTAÑOSM on 19/02/25.
//
import Foundation

struct Task: Identifiable, Codable {
    var id: Int
    var title: String
    var completed: Bool
}
