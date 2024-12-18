//
//  EnxContentView.swift
//  EnxDemoApp
//
//  Created by EnxbleX on 18/12/24.
//
import SwiftUI

struct EnxContentView : View{
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel : EnxViewModelClass
    init(token : String!, userName : String! ){
        _viewModel = StateObject(wrappedValue: EnxViewModelClass(parameters: token, userName: userName))
    }
    var body : some View{
        ZStack{
            GeometryReader { geometry in
                VStack{
                    if let enxAtView = viewModel.enxAtView{
                        EnxViewResponsible(view: enxAtView, width: geometry.size.width, height: geometry.size.height).ignoresSafeArea()
                    }
                    Spacer()
                }
            }
            VStack{
                    if let localView = viewModel.enxLocalView{
                        EnxLocalViewResponsible(localView: localView).frame(width: 100, height: 120).padding(.trailing)
                    }
                    Spacer()
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing) // Ensures alignment within ZStack
                .padding()
            VStack {
                    Spacer()
                EnxActionView(enxViewModel: viewModel).frame(height: 40)
                    .padding()
                }
        }.onReceive(viewModel.$isDisconnected) { isDisconnected in
            if isDisconnected {
                presentationMode.wrappedValue.dismiss() 
            }
        }
    }
}
struct EnxContentView_Previews: PreviewProvider {
    static var previews: some View {
        EnxContentView(token: "token", userName: "UserName")
        
    }
}
