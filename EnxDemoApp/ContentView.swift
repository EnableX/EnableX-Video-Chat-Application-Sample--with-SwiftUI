//
//  ContentView.swift
//  EnxDemoApp
//
//  Created by jaykumar on 24/12/21.
//

import SwiftUI
import AlertToast
import AVFoundation


func getMediaPremission(){
    let vStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if(vStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            })
    }
    let aStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if(aStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            })
    }
}

class RoomInput: ObservableObject {
    @Published var token: String!
}

struct ContentView: View {
    @State var username: String = ""
    @State var roomID: String = ""
    @State private var showToast = false
    @State private var errorMessage = ""
    @State private var createRoomModel : EnxCreateRoomModel!
    
    @State private var willMoveToNextScreen = false
    
    @State private var token : String = ""
    
    //@ObservedObject var tokenRequt = RoomInput()
    
    private var nameValidated: Bool {
            !username.isEmpty
        }
    private var roomIDValidated: Bool {
            !roomID.isEmpty
        }
    var body: some View {
        NavigationView {
               VStack (alignment: .center){
                   NavigationLink(destination:EnxConfrenceView(token: token,userName: username)
                                    , isActive: $willMoveToNextScreen) {
                       EmptyView() }
                   Image("logoImage")
                   Text("Welcome!").font(.title).bold().padding(.bottom, 20)
                   TextField("Enter name", text: $username).textFieldStyle(RoundedBorderTextFieldStyle()).padding(.leading, 40).padding(.trailing, 40)
                   TextField("Enter RoomID", text: $roomID).textFieldStyle(RoundedBorderTextFieldStyle())
                       .padding(.leading, 40).padding(.trailing, 40)
                   
                   HStack{
                       Button(action: {
                           if(!nameValidated){
                               errorMessage = "Please enter your Name"
                               showToast.toggle()
                           }else{
                               Api().createRoom { (roomResponse) in
                                   self.roomID = roomResponse.room_id
                                   self.createRoomModel = roomResponse
                               }
                           }
                       }){
                           Text("Create Room")
                               .padding(10).font(.system(size: 18))
                               .foregroundColor(Color.white)
                               .font(.system(size: 18))
                       }
                       .buttonStyle(ButtonStyling(type: .light, color: Color.gray))
                           .padding(.trailing,10)
                           .padding(.top, 20)
                           .shadow(color: Color.gray, radius: 14, x: 0, y: 0)
                       Button(action: {
                           if(!nameValidated){
                               errorMessage = "Please enter your Name"
                               showToast.toggle()
                           }else if(!roomIDValidated){
                               errorMessage = "Please enter a Valid RoomId"
                               showToast.toggle()
                           }
                           else{
                               let inputParam : [String : String] = ["name" : username , "role" :  "participant" ,"roomId" : createRoomModel.room_id, "user_ref" : "2236"]
                               Api().featchToken(requestParam: inputParam, completion: {tokenInfo  in
                                   //self.tokenRequt.token = tokenInfo.token!
                                   self.token = tokenInfo.token!
                                   print("Token Information \(tokenInfo.token!)")
                                   self.willMoveToNextScreen.toggle()
                               })
                           }
                        }){
                           Text("Join Room")
                               .padding(10)
                               .foregroundColor(Color.white)
                               .font(.system(size: 18))
                       }
                        .buttonStyle(ButtonStyling(type: .heavy, color: Color.red))
                        .padding(.leading,10)
                        .padding(.top, 20)
                        .shadow(color: Color.gray, radius: 14, x: 0, y: 0)
                        .buttonStyle(PlainButtonStyle())
                   }.toast(isPresenting: $showToast){
                       AlertToast(displayMode: .alert, type: .regular, title: errorMessage)
                   }
               }
               .onAppear(perform: {
                   getMediaPremission()
               })
        }
    }
}
public enum ButtonType {
    case light
    case italic
    case heavy
}
public struct ButtonStyling : ButtonStyle {
    public var type: ButtonType
    public var color : Color
    public init(type: ButtonType = .light , color : Color = Color.red) {
        self.type = type
        self.color = color
    }
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label.foregroundColor(Color.white)
            .padding(EdgeInsets(top: 5,
                                   leading: 5,
                                   bottom: 5,
                                   trailing: 5))
               .background(AnyView(Capsule().fill(color)))
               .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color.gray, lineWidth: 0))
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


