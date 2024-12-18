//
//  EnxViewModelClass.swift
//  EnxDemoApp
//
//  Created by Enablex on 18/12/24.
//

import SwiftUI
import Combine
import EnxRTCiOS

class EnxViewModelClass : ObservableObject{
    @Published var buttonStates : [Bool] = [false,false,false,false]
    @Published var enxAtView : UIView?
    @Published var enxLocalView : EnxPlayerView!
    @Published var isDisconnected: Bool = false
    private var enxRTC : EnxRtc!
    private var enxLocalStream : EnxStream!
    private var enxRoom : EnxRoom!
    //Create self instance and enxRTC instance
    init(parameters : String, userName name : String){
        enxRTC = EnxRtc()
        joinEnxRoom(parameters, userName: name)
    }
    //Call join room Apis
    private func joinEnxRoom(_ token : String, userName name : String){
        let localStreamInfo : [String : Any] = ["video" : true ,"audio" : true ,"data" :true ,"name" :name,"type" : "public","audio_only": false,"audioMuted": false,"videoMuted": false]
        
        let playerConfiguration : [String : Any] = ["avatar":true,"audiomute":true, "videomute":true,"bandwidht":true, "screenshot":true,"iconColor" :"#0000FF"]
        
        let roomInfo : [String : Any]  = ["allow_reconnect" : true , "number_of_attempts" : 3, "timeout_interval" : 45,"playerConfiguration":playerConfiguration,"activeviews" : "view"]
        
        guard let enxStream = enxRTC.joinRoom(token, delegate: self, publishStreamInfo: localStreamInfo, roomInfo: roomInfo, advanceOptions: []) else {
            return
        }
        enxLocalStream = enxStream
        enxLocalStream.delegate = self
    }
    //Create local View
    private func createLocalView(){
            enxLocalView = EnxPlayerView(withLocalView: .zero)
    }
    private func updateBottomState(_ index : Int , state flag : Bool){
        DispatchQueue.main.async {
                   self.buttonStates[index] = flag
        }
    }
    func selfMuteAudio(_ flag : Bool){
        guard enxLocalStream != nil else {
            return
        }
        enxLocalStream.muteSelfAudio(flag)
    }
    func selMuteVideo(_ flag : Bool){
        guard enxLocalStream != nil else {
            return
        }
        enxLocalStream.muteSelfVideo(flag)
    }
    func switchCamera(_ flaf : Bool){
        guard enxLocalStream != nil else {
            return
        }
       let _ = enxLocalStream.switchCamera()
        updateBottomState(2, state: !self.buttonStates[2])
    }
    func disconnectRoom(){
        guard enxRoom != nil else {
            return
        }
        enxRoom.disconnect()
    }
    func switchAudio(_ flag : Bool){
        guard enxRoom != nil else {
            return
        }
        enxRoom.switchMediaDevice(flag ? "Speaker" : "Earpiece")
    }
    
    
}
extension EnxViewModelClass : EnxRoomDelegate, EnxStreamDelegate{
    func room(_ room: EnxRoom?, didConnect roomMetadata: [String : Any]?) {
        enxRoom = room
        createLocalView()
        enxRoom.publish(enxLocalStream)
        enxLocalStream.attachRenderer(enxLocalView!)
    }
    
    func didRoomDisconnect(_ response: [Any]?) {
        DispatchQueue.main.async {
                self.isDisconnected = true 
        }
    }
    
    func room(_ room: EnxRoom?, didError reason: [Any]?) {
        //ToDo
    }
    
    func room(_ room: EnxRoom?, didAddedStream stream: EnxStream?) {
        let _ = enxRoom.subscribe(stream!)
    }
    
    func room(_ room: EnxRoom?, userDidJoined Data: [Any]?) {
        //Handel user detaiuls once any user join after you joined
    }
    
    func room(_ room: EnxRoom?, userDidDisconnected Data: [Any]?) {
        //handle user disconnected details in room
    }
    func room(_ room: EnxRoom?, didActiveTalkerView view: UIView?) {
        DispatchQueue.main.async {
                    self.enxAtView = view
        }
    }
    func didAudioEvents(_ data: [String : Any]?) {
        updateBottomState(0, state: ((data!["msg"] as! String) == "Audio Off") ? true : false)
    }
    func didVideoEvents(_ responseData : [String : Any]?) {
        updateBottomState(1, state: ((responseData!["msg"] as! String) == "Video Off") ? true : false)
    }
    func didNotifyDeviceUpdate(_ updates: String) {
        updateBottomState(3, state: (updates == "Speaker") ? true : false)
    }
    
}
