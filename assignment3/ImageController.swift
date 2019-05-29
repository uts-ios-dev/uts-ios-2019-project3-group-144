//
//  ImageController.swift
//  assignment3
//
//  Created by Jacob Efendi on 5/29/19.
//  Copyright © 2019 group144. All rights reserved.
//

import Foundation
import UIKit

class ImageController {
    
    static let fileManager = FileManager.default
    static let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveImage(image: UIImage, recipe: Recipe) -> String? {
        
        let imageName = "\(recipe.id).png"
        
        if let imageData = image.pngData() {
            do {
                let filePath = documentsPath.appendingPathComponent(imageName)
                try imageData.write(to: filePath)
                print ("image was saved!")
                return imageName
            }
            catch {
                print("image could not be saved")
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func getImage(imageName: String) -> UIImage? {
        let filePath = documentsPath.appendingPathComponent(imageName).path
        
        guard fileManager.fileExists(atPath: filePath) else {
            print("Image does not exist at path: \(filePath)")
            return nil
        }
        
        if let imageData = UIImage(contentsOfFile: filePath) {
            return imageData
        } else {
            print("UIImage could not be created.")
            return nil
        }
    }
}
