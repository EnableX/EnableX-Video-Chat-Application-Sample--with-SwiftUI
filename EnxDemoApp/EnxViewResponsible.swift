//
//  EnxViewResponsible.swift
//  EnxDemoApp
//
//  Created by EnableX on 18/12/24.
//

import SwiftUI

struct EnxViewResponsible : UIViewRepresentable{
    let view : UIView?
    let width: CGFloat
    let height: CGFloat
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    func makeUIView(context : Context) -> UIView{
        return view ?? UIView()
    }
}
