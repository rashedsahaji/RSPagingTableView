//
//  RESTManager.swift
//  RSPagingTableViewExample
//
//  Created by Rashed Sahajee on 21/11/22.
//

import Foundation
import Foundation

class PhotosRESTManager: NSObject {
    
    static var shared = PhotosRESTManager()
    
    func getPhotos(page: Int, limit: Int, completion: @escaping ((Result<Photos, Error>) -> Void)){
        let urlString: String = "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data, error == nil else {
                print("something is error")
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(Photos.self, from: data)
                completion(.success(decodedData))
            } catch (let error) {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
}
