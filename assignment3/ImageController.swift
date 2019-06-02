import Foundation
import UIKit

// controller containing image management functions (save, load, update)
/*
 NOTE: images are saved in documents directory NOT in core data
 core data objects contain a reference to the image's file path
 */
class ImageController {
    
    // filemanager and document path objects
    static let fileManager = FileManager.default
    static let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // function to save image
    static func saveImage(image: UIImage, recipe: Recipe) -> String? {
        
        // image name is set based on recipe id
        let imageName = "\(recipe.id).png"

        // if the image can be converted into png data, try and save it
        if let imageData = image.pngData() {
            do {
                // set the file path
                let filePath = documentsPath.appendingPathComponent(imageName)
                // write and save image to the file path
                try imageData.write(to: filePath)
                return imageName
            }
            catch { return nil }
        } else { return nil }
    }
    
    // function to update image in existing file path
    static func updateImage(imageName: String, newImage: UIImage) {
        // get the file path
        let filePath = documentsPath.appendingPathComponent(imageName)
        
        // check if the file exists
        guard fileManager.fileExists(atPath: filePath.path) else { return }
        
        // if the new image can be converted into png data, replace the initial image
        if let imageData = newImage.pngData() {
            do {
                // remove the original image
                try fileManager.removeItem(at: filePath)
                // save the new image
                try imageData.write(to: filePath)
            } catch let error as NSError { print("Could not delete \(imageName): \(error)") }
        }
    }
    
    // function to get an image based on its name
    static func getImage(imageName: String) -> UIImage? {
        
        // get the file path of the image
        let filePath = documentsPath.appendingPathComponent(imageName).path
        
        // check if the image exists
        guard fileManager.fileExists(atPath: filePath) else { return nil }
        
        // return the image
        if let imageData = UIImage(contentsOfFile: filePath) { return imageData }
        else { return nil }
    }
}
