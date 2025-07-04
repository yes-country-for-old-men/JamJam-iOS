//
//  NavigationBarBackAndNameModifier.swift
//  Jamjam
//
//  Created by 권형일 on 7/1/25.
//

import SwiftUI

// 뒤로가기 + 이름
struct NavigationBarBackAndNameModifier: ViewModifier {
    @Environment(NavigationRouter.self) var navRouter
    
    let name: String
    
    init(name: String) {
        self.name = name
        
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
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 20))
                            .foregroundStyle(.gray)
                        
                        Text(name)
                            .font(.pretendard(Pretendard.semiBold, size: 19))
                    }
                }
            }
    }
}
