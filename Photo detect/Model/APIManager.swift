//
//  APIManager.swift
//  Photo detect
//
//  Created by Avi Davidov on 30/12/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreML
import Vision



class APIManager {
    
    init() {
        
    }
    
    static let manager = APIManager()
    
    func uploadImageToAlpr (image : UIImage, complition : @escaping (NSDictionary?, Error?) -> Void) {
        
        
        let params : [String:String] = ["secret_key" : "sk_a173683074494aa49e7c726e", "recognize_vehicle" : "0", "country" : "eu", "return_image" : "0", "topn" : "10"]

        var paramString = ""
        for (key,val) in params{
            paramString += key
            paramString += "="
            paramString += val
            paramString += "&"
        }
        
        print(paramString)
        
        let url = "https://api.openalpr.com/v2/recognize?" + paramString
        
        Alamofire.upload(multipartFormData: { (data) in
            data.append(UIImageJPEGRepresentation(image, 1)!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url, method: .post) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    guard let responseDic = response.result.value as? [String:Any] else{
                        print(response.result.error?.localizedDescription ?? "unkown error")
                        return
                    }
                    let json = JSON (responseDic)
                    print(json)
                    
                    let monthlyCredit = json ["credits_monthly_used"].stringValue
                    
                    print("monthlyCredit is " + monthlyCredit)
                    
                    let resultsArray = json["results"].arrayObject
                    let resultArray = JSON(resultsArray)
                    let carPlateNumber = resultArray["plate"]
                    
                    print(resultArray)

                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func sendImageToServer(image:UIImage) {
        
        
        let url = URL(fileURLWithPath: "https://api.openalpr.com/v2/recognize")
        
        let PngImage = UIImagePNGRepresentation(image)
        if let base64Image = PngImage?.base64EncodedData(options: .lineLength64Characters){
        }
        guard let jpegImage = UIImageJPEGRepresentation(image, 0.7) else{
            print("Error conveting to JPEG")
            return
        }
        
        let parameters = ["secret_key" : "sk_a173683074494aa49e7c726e", "recognize_vehicle" : 0, "country" : "eu", "return_image" : 0, "topn" : 10] as [String : AnyObject]
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(jpegImage,
                                     withName: "imagefile",
                                     fileName: "image.jpg",
                                     mimeType: "image/jpeg")
            
            for (key, value) in parameters {
                
                multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
            }
            
        }, to: url,
           method: .post,
           headers: nil) { (encodingResult) in
            
            print(encodingResult)
        }
    }
    
    
    func aviDetect (ciImage : CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("can't load Inception3 model")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Can't get the result")
            }
            print(result.first)
        }
        let handler = VNImageRequestHandler(ciImage : ciImage)
        
        do{
            try handler.perform([request])
        }catch{
            fatalError("error in handler")
        }
        print()
    }
    
    
}
