//
//  Networking.swift
//  SpeedHub
//
//  Created by MacMini on 3.10.2021.
//

import Foundation
import UIKit




var baseURL : URL {
    return URL(string: "http://ergast.com/api/f1")!
}


enum ApiError : Error {
    case url, decoder, unknown
}


class NetworkManager {
    
    let populatedView : UIView
    let  indicator = CustomActivityIndicatorView(frame: .zero)
    
    let imageView = UIImageView(image: UIImage(named: "tyre"))
    init(populatedView : UIView) {
        self.populatedView = populatedView
        indicator.frame = populatedView.bounds
        indicator.hidesWhenStopped = true
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if #available(iOS 13.0, *) {
            indicator.backgroundColor = .systemGray6
        } else {
            // Fallback on earlier versions
        }
        indicator.color = .clear
        
        populatedView.insertSubview(indicator, at: 100)
        
        
//        indicator.insertSubview(imageView, at: 101)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.centerXAnchor.constraint(equalTo: indicator.centerXAnchor).isActive = true
//        imageView.centerYAnchor.constraint(equalTo: indicator.centerYAnchor).isActive  = true
//        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        imageView.layer.cornerRadius = 50
//        imageView.clipsToBounds = true
//        print(indicator.frame)
    }
    
    
    func commence<T : MyTask>( task : T , completion : @escaping (Result<T.Response,ApiError>) -> Void) {
        print(populatedView.bounds)
        
        guard let url = task.url else {
            completion(.failure(ApiError.url))
            return}
        print(url)
        indicator.startAnimating()
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                completion(.failure(ApiError.unknown))
                self.indicator.stopAnimating()
                return
            }
            
            
            if let data = data {
             
                do {
                    let returnedModel = try JSONDecoder().decode(T.Response.self, from: data)
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                    }
                    completion(.success(returnedModel))
                } catch let error {
                    print(error)
                    DispatchQueue.main.async {
                        self.indicator.stopAnimating()
                    }
                    
                    completion(.failure(ApiError.decoder))
                }
                
                
            } else {
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
                
                completion(.failure(ApiError.unknown))
            }
        }.resume()
        
        
    }
    
    
    
    
}
