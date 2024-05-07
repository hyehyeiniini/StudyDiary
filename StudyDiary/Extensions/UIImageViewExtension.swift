//
//  UIImageViewExtensions.swift
//  StudyDiary
//
//  Created by Chris lee on 5/5/24.
//

import UIKit

/*
 // Example
 let url = "http://.../a.jpg"
 imgView.downloadImage(from: url!)
 */

extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from urlStr: String) {
        let url = URL(string: urlStr)
        guard let url = url else {
            print("Couldn't create url object")
            return
        }
                      
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            // sync? async(원래코드)
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}

