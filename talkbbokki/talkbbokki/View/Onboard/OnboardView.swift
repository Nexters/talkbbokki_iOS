//
//  OnboardView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import SwiftUI

struct OnboardView: View {
    @AppStorage("didShowOnboard") var didShowOnboard : Bool = false
    @State private var didTapNext = false
    @State private var selectionID = 0
    @State private var taps: [SelectType] = [.selected, .nonSelected, .nonSelected]
    var body: some View {
        ZStack {
            TabView(selection: $selectionID) {
                OnboardFirstView()
                    .tag(0)
                OnboardSecondView()
                    .tag(1)
                OnboardThirdView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeOut(duration: 0.2), value: selectionID)
            .ignoresSafeArea()
            
            VStack {
                OnboardTabView(selectedIndex: selectionID,
                               select: taps).padding([.top])
                Spacer()
            }
            OnboardNextButton(isFinishedPage: selectionID >= 2,
                              didTapButton: $didTapNext)
        }
        .onChange(of: selectionID, perform: { newValue in
            print(selectionID)
            taps = taps.map { _ in .nonSelected }
            taps[selectionID] = .selected
        })
        .onChange(of: didTapNext) { newValue in
            guard selectionID >= 2 else {
                selectionID += 1
                return
            }
            UserDefaultValue.Onboard.didShow = true
            didShowOnboard.toggle()
        }
    }
}

struct OnboardTabView: View {
    let selectedIndex: Int
    let select: [SelectType]
    var body: some View {
        HStack {
            ForEach(select) { select in
                RoundedRectangle(cornerRadius: 2.5)
                    .foregroundColor(select.background)
                    .frame(width: select.frame.width,
                           height: select.frame.height)
            }
        }.onAppear {
            print(selectedIndex)
        }
    }
}

struct OnboardNextButton: View {
    let isFinishedPage: Bool
    @Binding var didTapButton: Bool
    var body: some View {
        VStack {
            Spacer()
            Button {
                didTapButton.toggle()
            } label: {
                if isFinishedPage {
                    ConfirmText(type: .cancel,
                                buttonMessage: "시작할래요!")
                } else {
                    ConfirmText(type: .next,
                                buttonMessage: "다음")
                }
            }.padding([.leading,.trailing,.bottom], 20)
        }
    }
}

enum SelectType: Identifiable {
    var id: Double {
        Date().timeIntervalSince1970
    }
    case selected
    case nonSelected
    
    var background: Color {
        switch self {
        case .selected:
            return Color.Talkbbokki.Primary.mainColor1
        case .nonSelected :
            return Color.Talkbbokki.GrayScale.gray6
        }
    }
    
    var frame: CGSize {
        switch self {
        case .selected:
            return CGSize(width: 33, height: 4)
        case .nonSelected:
            return CGSize(width: 18, height: 4)
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView()
    }
}
