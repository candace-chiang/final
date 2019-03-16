//
//  FirebaseAPIHelper.swift
//  
//
//  Created by Will Oakley on 10/24/18.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class FirebaseAPIClient {
    
    static func getSnaps(completion: @escaping ([SnapImage]) -> ()) {
        /* PART 2A START */
        let snapsRef = Database.database().reference().child("snapImages")
        
        print("getting snaps")
        
        snapsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let allSnaps = snapshot.value as? [String : Any] ?? [:]
            var newSnaps: [SnapImage] = []
            
            print("time to get this bread")
            
            for (key, value) in allSnaps {
                let dict = value as! [String: Any]
                print(dict)
                let dict2 = dict as? [String: String] ?? [:]
                if dict2 == [:] {
                    continue
                }
                let imageURL = dict2["imageURL"]!
                let storageRef = Storage.storage().reference(forURL: imageURL)
                
                print("About to get image")
                
                var image: UIImage!
                storageRef.getData(maxSize: 30 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error)
                        image = nil
                        return
                    } else {
                        image = UIImage(data: data!)
                        print("got image")
                        let snap = SnapImage(imageDict: dict2, image: image)
                        newSnaps.append(snap)
                        print("snap added!")
                    }
                }
            }
            
            completion(newSnaps)
        })
        /* PART 2A FINISH */
    }
}
