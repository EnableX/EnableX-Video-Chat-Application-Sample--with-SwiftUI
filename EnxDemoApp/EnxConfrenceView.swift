//
//  EnxConfrenceView.swift
//  EnxDemoApp
//
//  Created by jaykumar on 24/12/21.
//

import SwiftUI
import EnxRTCiOS
import Foundation
import AlertToast


//View Wrapper from native UIkit to SwiftUi
struct EnxConfView : UIViewControllerRepresentable{
    let token : String!
    let UserName  : String!
    let enxBrizCalss = BridgingClass()
    func makeUIViewController(context: Context) -> BridgingClass{
        enxBrizCalss.view.backgroundColor = .black
        enxBrizCalss.joinRoom(token, UserName)
        return enxBrizCalss
    }
    func disconnectFromRoom(){
        enxBrizCalss.disconnect()
    }
    func muteAudio(isMute : Bool){
        enxBrizCalss.selfMuteAudio(isMute)
    }
    func muteVideo(isMute : Bool){
        enxBrizCalss.selfMuteVideo(isMute)
    }
    func switchAudioMedia(isSpoeaker : Bool){
        enxBrizCalss.changeToSpeaker(isSpoeaker)
    }
    func changesCamera(){
        enxBrizCalss.switchCamera()
    }
    func updateUIViewController(_ uiViewController: BridgingClass, context: Context) {}
    typealias UIViewControllerType = BridgingClass
}
extension Notification.Name {
    static var disconnect: Notification.Name { return .init("disconnect") }
    static var audio: Notification.Name { return .init("audio") }
    static var video: Notification.Name { return .init("vedio") }
    static var media: Notification.Name { return .init("media") }
    static var error: Notification.Name { return .init("error") }
}
class BridgingClass: UIViewController, EnxStreamDelegate, EnxRoomDelegate {
    func switchCamera() {
        _ = localStream.switchCamera()
    }
    func selfMuteAudio(_ flag: Bool) {
        localStream.muteSelfAudio(flag)
    }
    func selfMuteVideo(_ flag: Bool) {
        localStream.muteSelfVideo(flag)
    }
    func disconnect() {
        remoteRoom.disconnect()
    }
    func changeToSpeaker(_ flag: Bool) {
        if(flag){
            remoteRoom.switchMediaDevice("Speaker")
        }else{
            remoteRoom.switchMediaDevice("Earpiece")
        }
    }
    private var enxRTC = EnxRtc()
    private var remoteRoom : EnxRoom!
    private var localStream : EnxStream!
    func joinRoom(_ token : String, _ username : String){
        let localStreamInfo : [String : Any] = ["video" : true ,"audio" : true ,"data" :true ,"name" :username,"type" : "public","audio_only": false]
        
        let playerConfiguration : [String : Any] = ["avatar":true,"audiomute":true, "videomute":true,"bandwidht":true, "screenshot":true,"iconColor" :"#0000FF"]
        
        let roomInfo : [String : Any]  = ["allow_reconnect" : true , "number_of_attempts" : 3, "timeout_interval" : 20,"playerConfiguration":playerConfiguration,"activeviews" : "view"]
        
        guard let steam = enxRTC.joinRoom(token, delegate: self, publishStreamInfo: localStreamInfo , roomInfo: roomInfo , advanceOptions: nil) else{
            return
        }
        self.localStream = steam
        self.localStream.delegate = self as EnxStreamDelegate
    }
    func createLocalView() -> EnxPlayerView{
        let enxplayerView = EnxPlayerView(withLocalView: CGRect.init(x: 10, y: 20, width: 100, height: 120))
        self.view.addSubview(enxplayerView)
        self.view.bringSubviewToFront(enxplayerView)
        return enxplayerView;
    }
    //Mark - EnxRoom Delegates
    
    /*
     This Delegate will notify to User Once he got succes full join Room
     */
    func room(_ room: EnxRoom?, didConnect roomMetadata: [String : Any]?){
        remoteRoom = room
        remoteRoom.publish(localStream)
        localStream.attachRenderer(createLocalView())
    }
    /*
     This Delegate will notify to User Once he Getting error in joining room
     */
    func room(_ room: EnxRoom?, didError reason: [Any]?) {
        let resDict = reason![0] as! [String : Any]
        let userinfo: [String: String] = ["Error": resDict["msg"] as! String]
        NotificationCenter.default.post(Notification(name: .error,
                                                           object: nil,
                                                           userInfo: userinfo))
    }
    /*
     This Delegate will notify to  User Once he/she Publisg Stream
     */
    func room(_ room: EnxRoom?, didPublishStream stream: EnxStream?) {
        //To Do
        remoteRoom.switchMediaDevice("Speaker")
    }
    /*
     This Delegate will notify to User if any new person added to room
     */
    func room(_ room: EnxRoom?, didAddedStream stream: EnxStream?) {
       _ =  room!.subscribe(stream!)
    }
    /*
     This Delegate will notify to User to subscribe other user stream
     */
    func room(_ room: EnxRoom?, didSubscribeStream stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User if Room Got discunnected
     */
    func didRoomDisconnect(_ response: [Any]?) {
        NotificationCenter.default.post(Notification(name: .disconnect,
                                                           object: nil,
                                                           userInfo: nil))
    }
    /*
     This Delegate will notify to User if any person join room
     */
    func room(_ room: EnxRoom?, userDidJoined Data: [Any]?) {
       //To Do
    }
    /*
     This Delegate will notify to User if any person got discunnected
     */
    func room(_ room: EnxRoom?, userDidDisconnected Data: [Any]?) {
        //To Do
    }
    /*
     This Delegate will notify to end User if Room connecton status changed
     */
    func room(_ room: EnxRoom?, didChangeStatus status: EnxRoomStatus) {
        //To Do
    }
    func room(_ room: EnxRoom?, didActiveTalkerView view: UIView?) {
        self.view.addSubview(view!)
        self.view.sendSubviewToBack(view!)
    }
    func room(_ room: EnxRoom?, didEventError reason: [Any]?) {
        let resDict = reason![0] as! [String : Any]
        let userinfo: [String: String] = ["Error": resDict["msg"] as! String]
        NotificationCenter.default.post(Notification(name: .error,
                                                           object: nil,
                                                           userInfo: userinfo))
    }
    func didNotifyDeviceUpdate(_ updates: String) {
        NotificationCenter.default.post(Notification(name: .media,
                                                           object: nil,
                                                     userInfo: ["mediaName" : updates]))
    }
    //Mark- EnxStreamDelegate Delegate

    /*
     This Delegate will notify to current User If any user has stoped There Video or current user Video
     */
    func didVideoEvents(_ responseData : [String : Any]?) {
        //To Do
        NotificationCenter.default.post(Notification(name: .video,
                                                           object: nil,
                                                           userInfo: responseData))
    }
    /*
     This Delegate will notify to current User If any user has stoped There Audio or current user Video
     */
    func didAudioEvents(_ data: [String : Any]?) {
        NotificationCenter.default.post(Notification(name: .audio,
                                                           object: nil,
                                                           userInfo: data))
    }
}

struct EnxConfrenceView: View {
    @Environment(\.presentationMode) var presentationMode
    var token : String!
    var userName : String!
    var someView : EnxConfView!
    
    @State var isAudioMute : Bool = false
    @State var isVideoMute : Bool = false
    @State var isSpeaker : Bool = false
    @State var isDisconnect : Bool = false
    
    @State private var showToast = false
    @State private var errorMessage = ""
    
    var disconnectNotification = NotificationCenter.default.publisher(for: .disconnect)
    var audioNotification = NotificationCenter.default.publisher(for: .audio)
    var videoNotification = NotificationCenter.default.publisher(for: .video)
    var mediaNotification = NotificationCenter.default.publisher(for: .media)
    var errorNotification = NotificationCenter.default.publisher(for: .error)
    
    var body: some View {
        VStack (alignment: .center){
            someView
            .ignoresSafeArea()
            VStack{
                Button(action: {
                    someView.disconnectFromRoom()
                }){
                    Image("disconnect")
                }.padding(.bottom, 5)
                HStack{
                    Button(action: {
                        someView.muteAudio(isMute: !isAudioMute)
                    }){
                        Image(isAudioMute == true ? "menuMute" : "menuUnmute")
                    }.padding(.leading, 30)
                    Button(action: {
                        someView.muteVideo(isMute: isVideoMute)
                    }){
                        Image(isVideoMute == true ? "unhidecamera" : "hidecamera")
                       
                    }.padding(.leading, 15)
                        .padding(.trailing, 15)
                    Button(action: {
                        someView.changesCamera()
                    }){
                        Image("switchcamera")
                    }.padding(.leading, 15)
                    .padding(.trailing, 15)
                    Button(action: {
                        someView.switchAudioMedia(isSpoeaker: !isSpeaker)
                    }){
                        Image(isSpeaker == true ? "speaker" : "speakermute")
                    }.padding(.leading, 15)
                        .padding(.trailing, 15)
                }.frame(maxWidth: .infinity, maxHeight: 60)
                    .background(Color.gray)
                    .cornerRadius(12)
            }.background(Color.clear)
                .frame(maxWidth: .infinity, maxHeight: 120,alignment: .bottomTrailing)
                .padding(.leading, 5)
                .padding(.trailing, 5)
                .padding(.bottom, 10)
        }.background(Color.black)
        .navigationBarHidden(true)
            .onReceive(disconnectNotification, perform: { _ in
                self.presentationMode.wrappedValue.dismiss()
            })
            .onReceive(audioNotification, perform: { desc in
                isAudioMute.toggle()
            })
            .onReceive(videoNotification, perform: { desc in
                isVideoMute.toggle()
            })
            .onReceive(mediaNotification, perform: { desc in
                    isSpeaker.toggle()
            })
            .onReceive(errorNotification, perform: { desc in
                let message = desc.userInfo!["Error"]! as! String
                errorMessage = message
                showToast.toggle()
            })
            .toast(isPresenting: $showToast){
                AlertToast(displayMode: .alert, type: .regular, title: errorMessage)
            }
            
    }
    init(token : String!, userName : String! ){
        self.token = token
        self.userName = userName
        someView = EnxConfView(token: token, UserName: userName)
    }
}
struct EnxConfrenceView_Previews: PreviewProvider {
    static var previews: some View {
        EnxConfrenceView(token: "token", userName: "UserName")
        
    }
}

