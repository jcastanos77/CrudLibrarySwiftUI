//
//  Entity.swift
//  CrudLibrarySwiftUI
//
//  Created by JECASTAÑOSM on 19/02/25.
//
import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let email: String
}
