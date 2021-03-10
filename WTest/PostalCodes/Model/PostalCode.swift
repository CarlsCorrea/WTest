//
//  PostalCode.swift
//  WTest
//
//  Created by Carlos Correa on 06/03/2021.
//

import Foundation

struct PostalCode: Equatable {
    let id: Int
    let districtCode: String
    let countyCode: String
    let locationCode: String
    let locationName: String
    let arteryCode: String
    let arteryType: String
    let prepOne: String
    let arteryTitle: String
    let prepTwo: String
    let arteryName: String
    let arteryLocalion: String
    let change: String
    let door: String
    let customer: String
    let postalCode: String
    let extPostalCode:String
    let designatedPostal: String
    let designatedPostalCollate: String
    
    enum CodingKeys: String, CodingKey {
        case districtCode = "cod_distrito"
        case countyCode = "cod_localidade"
        case locationCode = "nome_localidade"
        case arteryCode = "cod_arteria"
        case arteryType = "tipo_arteria"
        case prepOne = "prep1"
        case arteryTitle = "titulo_arteria"
        case prepTwo = "prep2"
        case arteryName = "nome_arteria"
        case arteryLocalion = "local_arteria"
        case change = "troco"
        case door = "porta"
        case customer = "cliente"
        case postalCode = "num_cod_postal"
        case extPostalCode = "ext_cod_postal"
        case designatedPostal = "desig_postal"
        case designatedPostalCollate = "designatedPostal_collate"
    }
    
}



