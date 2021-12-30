//
//  EnxCreateRoomModel.swift
//  EnxDemoApp
//
//  Created by jaykumar on 24/12/21.
//

import Foundation

class EnxCreateRoomModel : NSObject{
    var room_id : String!
    var  mode : String!
    var participantName : String!
    var error : String!
    var isRoomFlag : Bool!
}
class EnxTokenModel : NSObject{
    var token :String!
    var error : String!
   
}
class Api {
    func createRoom(completion:@escaping (EnxCreateRoomModel) -> ()) {
        //create the url with URL
        let url = URL(string: kBasedURL + "createRoom")!
        //Create A session Object
        let session = URLSession.shared
        //Now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if(kTry){
             request.addValue(kAppId, forHTTPHeaderField: "x-app-id")
            request.addValue(kAppkey, forHTTPHeaderField: "x-app-key")
        }
        session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else{
                let roomdataModel = EnxCreateRoomModel()
                roomdataModel.error = error.debugDescription
                DispatchQueue.main.async {
                    completion(roomdataModel)
                }
                return}
            guard let data = data else {
                let roomdataModel = EnxCreateRoomModel()
                roomdataModel.isRoomFlag = false
                DispatchQueue.main.async {
                    completion(roomdataModel)
                }
                return}
            do{
                if let responseValue = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]{
                    print("requestBody",responseValue)
                    let roomdataModel = EnxCreateRoomModel()
                    if (responseValue["result"] as! Int) == 0{
                        if let respValue = responseValue["room"] as? [String : Any]{
                            roomdataModel.room_id = (respValue["room_id"] as! String)
                            let settingValue = respValue["settings"] as! [String : Any]
                            roomdataModel.mode = (settingValue["mode"] as! String)
                            roomdataModel.isRoomFlag = true
                        }
                        else{
                            roomdataModel.isRoomFlag = false
                        }
                    }
                    else{
                        roomdataModel.isRoomFlag = false
                    }
                    DispatchQueue.main.async {
                        completion(roomdataModel)
                    }
                   
                }
            }catch{
                let roomdataModel = EnxCreateRoomModel()
                roomdataModel.error = error.localizedDescription
                DispatchQueue.main.async {
                    completion(roomdataModel)
                }
                print(error.localizedDescription)
            }
        }).resume()
    }
    func featchToken(requestParam : [String: String] , completion:@escaping (EnxTokenModel) -> ()){
        //create the url with URL
        let url = URL(string: kBasedURL + "createToken")!
        //Create A session Object
        let session = URLSession.shared
        //Now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: requestParam, options:.prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if(kTry){
             request.addValue(kAppId, forHTTPHeaderField: "x-app-id")
             request.addValue(kAppkey, forHTTPHeaderField: "x-app-key")
        }
        //create dataTask using the session object to send data to the server
        session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else{
                let tokenModel = EnxTokenModel()
                tokenModel.error = error?.localizedDescription
                DispatchQueue.main.async {
                    completion(tokenModel)
                }
                return}
            guard let data = data else {
                let tokenModel = EnxTokenModel()
                tokenModel.token = ""
                DispatchQueue.main.async {
                    completion(tokenModel)
                }
                return}
            do{
                if let responseValue = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]{
                    print(responseValue)
                    let tokenModel = EnxTokenModel()
                    if let token = responseValue["token"] as? String{
                        tokenModel.token = token
                    }
                    else{
                        tokenModel.token = nil
                    }
                    DispatchQueue.main.async {
                        completion(tokenModel)
                    }
                }
            }catch{
                let tokenModel = EnxTokenModel()
                tokenModel.error = error.localizedDescription
                DispatchQueue.main.async {
                    completion(tokenModel)
                }
                print(error.localizedDescription)
            }
        }).resume()
        
    }
    
    
    
}
