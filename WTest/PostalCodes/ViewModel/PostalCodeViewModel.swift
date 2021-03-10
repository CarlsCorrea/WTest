//
//  PostalCodeViewModel.swift
//  WTest
//
//  Created by Carlos Correa on 06/03/2021.
//

import UIKit
import CodableCSV

protocol PostalCodeViewModelDelegate: AnyObject {
    func tableViewReloadData()
    func setPostalCodes(postalCodes: [PostalCode])
    func showDownloadError()
    func setTitle(_ title: String)
    func setupSearchBar(title: String)
}

final class PostalCodeViewModel {
    public weak var delegate: PostalCodeViewModelDelegate?
    private var postalCodes: [PostalCode] = []
    private var filteredPostalCodes: [PostalCode] = []
    
    func viewDidLoad(delegate: PostalCodeViewModelDelegate) {
        self.delegate = delegate
        
        delegate.setupSearchBar(title: "Search postal code")
        delegate.setTitle("Postal codes")
        createTable()
    }
    
    func viewWillApper() {
        loadPostalCodes()
    }
    
     private func createTable() {
         let database = SQLiteDatabase.sharedInstance
         database.createTable()
     }
    
    func loadPostalCodes() {
        
        if (SQLiteCommands.rowsCount() != 0) {
            DispatchQueue.background(background: {
                if let _postalCodes = SQLiteCommands.presentRows() {
                    self.delegate?.setPostalCodes(postalCodes: _postalCodes)
                }
            }, completion:{
                self.delegate?.tableViewReloadData()
            })
        } else {
            do {
                try self.DownloadPostalCodes()
            } catch {
                print(error)
            }
        }

    }
    
    func searchBarSearchButtonClicked(inputText: String?) {
        guard let text = inputText, text.count >= 3 else {
            return
        }
        
        searchPostalCode(searchText: text)
    }
    
    private func searchPostalCode(searchText: String) {
        if let filter = SQLiteCommands.selectFromTable(text: searchText){
            self.filteredPostalCodes = filter
        }
        
        self.delegate?.setPostalCodes(postalCodes: self.filteredPostalCodes )
        self.delegate?.tableViewReloadData()
    }
    
    fileprivate func DownloadPostalCodes() throws {
        FileDownloader.downloadFile(url:URL(string: "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv")!, completion: { (success, inner: URLCompletionHandler) in
            do {
                if success {
                    let result = try inner()
                    if let destinationUrl = result.destinationUrl {
                        if (self.saveFileToDataBase(url: destinationUrl)) {
                            
                            if let _postalCodes = SQLiteCommands.presentRows() {
                                self.delegate?.setPostalCodes(postalCodes: _postalCodes)
                            }
                            self.delegate?.tableViewReloadData()
                            
                        } else {
                            self.delegate?.showDownloadError()
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        })
    }
    
    fileprivate func saveFileToDataBase(url:URL) -> Bool {
        do {
            let data = try Data(contentsOf: url)
            let result = try CSVReader.decode(input: data)
            
            for i in 1..<result.count {
                let cod_distrito: String? = result[row: i, column: 0]
                let cod_concelho: String? = result[row: i, column: 1]
                let cod_localidade: String? = result[row: i, column: 2]
                let nome_localidade: String? = result[row: i, column: 3]
                let cod_arteria: String? = result[row: i, column: 4]
                let tipo_arteria: String? = result[row: i, column: 5]
                let prep1: String? = result[row: i, column: 6]
                let titulo_arteria: String? = result[row: i, column: 7]
                let prep2: String? = result[row: i, column: 8]
                let local_arteria: String? = result[row: i, column: 9]
                let nome_arteria: String? = result[row: i, column: 10]
                let troco: String? = result[row: i, column: 11]
                let porta: String? = result[row: i, column: 12]
                let cliente: String? = result[row: i, column: 13]
                let num_cod_postal: String? = result[row: i, column: 14]
                let ext_cod_postal: String? = result[row: i, column: 15]
                let desig_postal: String? = result[row: i, column: 16]
                
                let postalCode = PostalCode(id: i,
                                            districtCode: cod_distrito ?? "",
                                            countyCode: cod_concelho ?? "",
                                            locationCode: cod_localidade ?? "",
                                            locationName: nome_localidade ?? "",
                                            arteryCode: cod_arteria ?? "",
                                            arteryType: tipo_arteria ?? "",
                                            prepOne: prep1 ?? "",
                                            arteryTitle: titulo_arteria ?? "",
                                            prepTwo: prep2 ?? "",
                                            arteryName: nome_arteria ?? "",
                                            arteryLocalion: local_arteria ?? "",
                                            change: troco ?? "",
                                            door: porta ?? "",
                                            customer: cliente ?? "",
                                            postalCode: num_cod_postal ?? "",
                                            extPostalCode: ext_cod_postal ?? "",
                                            designatedPostal: desig_postal ?? "",
                                            designatedPostalCollate: desig_postal ?? "")
                
                
                let isPostalCodeInserted = SQLiteCommands.insertRow(postalCode)
                        
                if isPostalCodeInserted == true {
                    print("Inserted " + postalCode.postalCode + "-" + postalCode.extPostalCode)
                } else {
                    print("error")
                }
                
            }
            
            return true
            
        } catch {
            print(error)
            return false
        }
    }

}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
