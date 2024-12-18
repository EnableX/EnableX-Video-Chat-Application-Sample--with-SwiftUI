//
//  EnxActionView.swift
//  EnxDemoApp
//
//  Created by EnableX on 18/12/24.
//
import SwiftUI

struct EnxActionView : View{
    @ObservedObject var enxViewModel : EnxViewModelClass
    var body : some View{
        HStack{
            Button(action: {enxViewModel.selfMuteAudio(!enxViewModel.buttonStates[0])}){
                Image(enxViewModel.buttonStates[0]  ? "menuMute" : "menuUnmute")
            }.padding(.leading, 15)
                .padding(.trailing, 10)
            Button(action: {enxViewModel.selMuteVideo(!enxViewModel.buttonStates[1])}){
                Image(enxViewModel.buttonStates[1]  ? "hidecamera" : "unhidecamera")
            }.padding(.leading, 10)
                .padding(.trailing, 10)
            Button(action: {enxViewModel.switchCamera(!enxViewModel.buttonStates[2])}){
                Image(enxViewModel.buttonStates[2]  ? "switchcamera" : "switchcamera")
            }.padding(.leading, 10)
                .padding(.trailing, 10)
            Button(action: {enxViewModel.switchAudio(!enxViewModel.buttonStates[3])}){
                Image(enxViewModel.buttonStates[3]  ? "speaker" : "speakermute")
            }.padding(.leading, 10)
                .padding(.trailing, 10)
            Button(action: {enxViewModel.disconnectRoom()}){
                Image( "disconnect")
            }.padding(.leading, 10)
        }.padding()
            .background(Color.black.opacity(0.65))
            .cornerRadius(12)
            .shadow(radius: 4)
    }
}
