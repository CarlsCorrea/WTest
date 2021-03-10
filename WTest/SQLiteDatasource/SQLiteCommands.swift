//
//  SQLiteCommands.swift
//  WTest
//
//  Created by Carlos Correa on 06/03/2021.
//

import Foundation
import SQLite

class SQLiteCommands {
    
    static var table = Table("postalCode")
    
    static let id = Expression<Int>("id")
    static let districtCode = Expression<String>("districtCode")
    static let countyCode = Expression<String>("countyCode")
    static let locationCode = Expression<String>("locationCode")
    static let locationName = Expression<String>("locationName")
    static let arteryCode = Expression<String>("arteryCode")
    static let arteryType = Expression<String>("arteryType")
    static let prepOne = Expression<String>("prepOne")
    static let arteryTitle = Expression<String>("arteryTitle")
    static let prepTwo = Expression<String>("prepTwo")
    static let arteryName = Expression<String>("arteryName")
    static let arteryLocalion = Expression<String>("arteryLocalion")
    static let change = Expression<String>("change")
    static let door = Expression<String>("door")
    static let customer = Expression<String>("customer")
    static let postalCode = Expression<String>("postalCode")
    static let extPostalCode = Expression<String>("extPostalCode")
    static let designatedPostal = Expression<String>("designatedPostal")
    static let designatedPostalCollate = Expression<String>("designatedPostal_collate")

    static func createTable() {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            try database.run(table.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(districtCode)
                table.column(countyCode)
                table.column(locationCode)
                table.column(locationName)
                table.column(arteryCode)
                table.column(arteryType)
                table.column(prepOne)
                table.column(arteryTitle)
                table.column(prepTwo)
                table.column(arteryName)
                table.column(arteryLocalion)
                table.column(change)
                table.column(door)
                table.column(customer)
                table.column(postalCode)
                table.column(extPostalCode)
                table.column(designatedPostal)
                table.column(designatedPostalCollate)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    static func insertRow(_ postalCodeValues:PostalCode) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        do {
            try database.run(table.insert(districtCode <- postalCodeValues.districtCode,
                                          countyCode <- postalCodeValues.countyCode,
                                          locationCode <- postalCodeValues.locationCode,
                                          locationName <- postalCodeValues.locationName,
                                          arteryCode <- postalCodeValues.arteryCode,
                                          arteryType <- postalCodeValues.arteryType,
                                          prepOne <- postalCodeValues.prepOne,
                                          arteryTitle <- postalCodeValues.arteryTitle,
                                          prepTwo <- postalCodeValues.prepTwo,
                                          arteryName <- postalCodeValues.arteryName,
                                          arteryLocalion <- postalCodeValues.arteryLocalion,
                                          change <- postalCodeValues.change,
                                          door <- postalCodeValues.door,
                                          customer <- postalCodeValues.customer,
                                          postalCode <- postalCodeValues.postalCode,
                                          extPostalCode <- postalCodeValues.extPostalCode,
                                          designatedPostal <- postalCodeValues.designatedPostal,
                                          designatedPostalCollate <- postalCodeValues.designatedPostal.folding(options: .diacriticInsensitive, locale: .current)))
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert row failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
    }
    
    static func rowsCount() -> Int {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return 0
        }
        var cnt = 0
        do {
            cnt = try database.scalar(table.count)
        } catch {
            print(error)
        }
        
        return cnt
    }
    
    static func selectFromTable(text:String) -> [PostalCode]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        let tableFiltered = table.filter(postalCode.like(text.lowercased()+"%") || extPostalCode.like(text.lowercased()+"%") || designatedPostalCollate.like(text.lowercased()+"%") )

        var postalCodeArray = [PostalCode]()
        
        do {
            for postCode in try database.prepare(tableFiltered) {
                
                let idValue = postCode[id]
                let districtCodeValue = postCode[districtCode]
                let countyCodeValue = postCode[countyCode]
                let locationCodeValue = postCode[locationCode]
                let locationNameValue = postCode[locationName]
                let arteryCodeValue = postCode[arteryCode]
                let prepOneValue = postCode[prepOne]
                let arteryTitleValue = postCode[arteryTitle]
                let prepTwoValue = postCode[prepTwo]
                let arteryNameValue = postCode[arteryName]
                let arteryLocalionValue = postCode[arteryLocalion]
                let changeValue = postCode[change]
                let doorValue = postCode[door]
                let customerValue = postCode[customer]
                let postalCodeValue = postCode[postalCode]
                let extPostalCodeValue = postCode[extPostalCode]
                let designatedPostalValue = postCode[designatedPostal]
                let designatedPostalCollateValue = postCode[designatedPostalCollate]
                
                let postalCodeObject = PostalCode(id: idValue, districtCode: districtCodeValue, countyCode: countyCodeValue, locationCode: locationCodeValue, locationName: locationNameValue, arteryCode: arteryCodeValue, arteryType: "", prepOne: prepOneValue, arteryTitle: arteryTitleValue, prepTwo: prepTwoValue, arteryName: arteryNameValue, arteryLocalion: arteryLocalionValue, change: changeValue, door: doorValue, customer: customerValue, postalCode: postalCodeValue, extPostalCode: extPostalCodeValue, designatedPostal: designatedPostalValue, designatedPostalCollate: designatedPostalCollateValue)
                
                postalCodeArray.append(postalCodeObject)
            }
        } catch {
            print("Present row error: \(error)")
        }
        return postalCodeArray
    }
    
    static func presentRows() -> [PostalCode]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }

        var postalCodeArray = [PostalCode]()
        do {
            for postCode in try database.prepare(table) {
                let idValue = postCode[id]
                let districtCodeValue = postCode[districtCode]
                let countyCodeValue = postCode[countyCode]
                let locationCodeValue = postCode[locationCode]
                let locationNameValue = postCode[locationName]
                let arteryCodeValue = postCode[arteryCode]
                let prepOneValue = postCode[prepOne]
                let arteryTitleValue = postCode[arteryTitle]
                let prepTwoValue = postCode[prepTwo]
                let arteryNameValue = postCode[arteryName]
                let arteryLocalionValue = postCode[arteryLocalion]
                let changeValue = postCode[change]
                let doorValue = postCode[door]
                let customerValue = postCode[customer]
                let postalCodeValue = postCode[postalCode]
                let extPostalCodeValue = postCode[extPostalCode]
                let designatedPostalValue = postCode[designatedPostal]
                let designatedPostalCollateValue = postCode[designatedPostalCollate]
                
                let postalCodeObject = PostalCode(id: idValue, districtCode: districtCodeValue, countyCode: countyCodeValue, locationCode: locationCodeValue, locationName: locationNameValue, arteryCode: arteryCodeValue, arteryType: "", prepOne: prepOneValue, arteryTitle: arteryTitleValue, prepTwo: prepTwoValue, arteryName: arteryNameValue, arteryLocalion: arteryLocalionValue, change: changeValue, door: doorValue, customer: customerValue, postalCode: postalCodeValue, extPostalCode: extPostalCodeValue, designatedPostal: designatedPostalValue, designatedPostalCollate: designatedPostalCollateValue)
                
                postalCodeArray.append(postalCodeObject)
                
            }
        } catch {
            print("Present row error: \(error)")
        }
        return postalCodeArray
    }
    
}
