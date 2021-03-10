//
//  FileDownloader.swift
//  WTest
//
//  Created by Carlos Correa on 06/03/2021.
//

import Foundation

class FileResult {
    var name:String?
    var destinationUrl:URL?
}

typealias ErrorCompletionHandler = () throws -> WTestErrors
typealias URLCompletionHandler = () throws -> FileResult

class FileDownloader {
    
    static func downloadFile(url: URL , completion: @escaping (_ success: Bool, _ inner: URLCompletionHandler) -> Void) -> Void {
        let itemUrl = url
        let documentsDirectoryURL = FileManager.default.temporaryDirectory
        let fileExtension = url.pathExtension
        let fileName = url.deletingPathExtension().lastPathComponent
        let destinationUrl = documentsDirectoryURL
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
    
        let fileResult = FileResult()
        fileResult.name = fileName + "." + url.pathExtension
        fileResult.destinationUrl = destinationUrl
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            completion(true, { return fileResult })
        } else {
            URLSession.shared.downloadTask(with: itemUrl, completionHandler: { (location, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        guard let tempLocation = location, error == nil else { return }
                        do {
                            try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                            completion(true, { return fileResult } )
                        } catch {
                            completion(false, { throw WTestErrors.downloadFailed })
                        }
                    } else {
                        completion(false, { throw WTestErrors.downloadFailed })
                    }
                } else {
                    completion(false, { throw WTestErrors.downloadFailed })
                }
            }).resume()
        }
    }
}
