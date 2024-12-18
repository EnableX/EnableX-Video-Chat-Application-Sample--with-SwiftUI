//
//  EnxLocalViewResponsible.swift
//  EnxDemoApp
//
//  Created by EnxbleX on 18/12/24.
//
import SwiftUI
struct EnxLocalViewResponsible : UIViewRepresentable{
    let localView : UIView?
    func makeUIView(context: Context) -> UIView {
        return localView ?? UIView()
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        // No update logic needed for now
    }
    
}
