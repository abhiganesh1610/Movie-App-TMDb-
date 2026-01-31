//
//  MovieCast.swift
//  MovieApp
//
//  Created by Ganesh on 31/01/26.
//

import Foundation

struct MovieCredits: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}

struct Cast: Codable, Identifiable {
    let id: Int
    let adult: Bool
    let gender: Int?
    let knownForDepartment: String?
    let name: String
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case id, adult, gender
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order
    }
}

struct Crew: Codable, Identifiable {
    let id: Int
    let adult: Bool
    let gender: Int?
    let knownForDepartment: String?
    let name: String
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let creditID: String?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case id, adult, gender
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case creditID = "credit_id"
        case department, job
    }
}
