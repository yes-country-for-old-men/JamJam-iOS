//
//  NavigationBarBackAndLogoAndLoginButtonModifier.swift
//  Jamjam
//
//  Created by 권형일 on 7/1/25.
//

import SwiftUI

// 뒤로가기 + 로고 + 로그인
struct NavigationBarBackAndLogoAndLoginButtonModifier: ViewModifier {
    @Environment(NavigationRouter.self) var navRouter
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.mainBackground)
        appearance.shadowColor = .clear // 하단 Divider 제거
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        navRouter.back()
                    } label: {
                        Image(systemName: "chevron.left")
                            .scaledToFit()
                            .frame(width: 24)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Image("jamjam_main_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navRouter.navigate(.loginView)
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 64, height: 30)
                            .foregroundStyle(Color.JJTitle)
                            .overlay {
                                Text("로그인")
                                    .font(.pretendard(Pretendard.semiBold, size: 14))
                                    .foregroundStyle(.white)
                            }
                            .padding(.trailing, 20)
                    }
                }
            }
    }
}
