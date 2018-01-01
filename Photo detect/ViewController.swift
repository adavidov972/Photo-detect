//
//  ViewController.swift
//  Photo detect
//
//  Created by Avi Davidov on 25/09/2017.
//  Copyright © 2017 Avi Davidov. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON



class ViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var imgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imagePicked = info [UIImagePickerControllerOriginalImage] as? UIImage{
            imgView.image = imagePicked
            //sendImageToServer(image: imagePicked)
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnPhoto(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary//UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        picker.allowsEditing = false
        
        present(picker, animated: true, completion: nil)
    }
}






