//
//  WTestErrors.swift
//  WTest
//
//  Created by Carlos Correa on 06/03/2021.
//

import Foundation

enum WTestErrors: String, Error {
    case fileDoesNotExist = "The file you are trying to open does not exist"
    case couldNotOpenDocument = "Could not open the file"
    case downloadFailed = "The download failed"
}

extension WTestErrors : LocalizedError {
    var errorDescription: String? { return NSLocalizedString(rawValue, comment: "") }
}
