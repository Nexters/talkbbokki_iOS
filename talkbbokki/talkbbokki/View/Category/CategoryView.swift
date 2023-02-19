//
//  CategoryView.swift
//  talkbbokki
//
//  Created by USER on 2023/02/10.
//

import SwiftUI
import ComposableArchitecture

private enum Design {
    enum Constraint {
        struct Title {
            static let topInset: CGFloat = 87
            static let leftInset: CGFloat = 20
            static let spacing: CGFloat = 5.0
        }
        
        struct CardView {
            static let width: CGFloat = 155
            static let height: CGFloat = 180
            static let spacing: CGFloat = 16
            static let imageSize: CGSize = CGSize(width: 90, height: 90)
            static let cardSize: CGSize = CGSize(width: 159, height: 180)
        }
        
        struct CategoryView {
            static let spacing: CGFloat = 60
        }
    }
    
    enum Text {
        static let mainTitle = "Let’s\nBBOKKI !"
        static let subTitle = "친밀도를 골라보세요!\n딱 - 맞는 대화주제 추천해줄게요!"
        static let alertMessage = "아직 준비중이에요!\n조금만 기다려주세요."
        static let alertConfrimButton = "슬프지만 닫기"
    }
}

struct CategoryView: View {
    enum Scene: String, Identifiable {
        var id: String {
            self.rawValue
        }
        case cardList
    }
    
    @State private var selectedCategory: Model.Category = Model.Category.empty
    @State private var didTapAlert: ButtonType = .none
    @State private var present: Scene?
    let store: StoreOf<CategoryReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                ZStack {
                    Color.Talkbbokki.Primary.mainColor2.ignoresSafeArea()
                    VStack(spacing: Design.Constraint.CategoryView.spacing) {
                        CategoryTitleView()
                        CategoryCardGridView(touchedCardView: $selectedCategory,
                                             categories: viewStore.categories)
                        Spacer()
                    }
                    
                    if viewStore.isShowAlert {
                        AlertView(message: Design.Text.alertMessage,
                                  subMessage: "",
                                  buttons: [AlertButton(type: .confirm,
                                                        message: Design.Text.alertConfrimButton)],
                                  didTapButton: $didTapAlert)
                    }
                }
            }
            .onChange(of: didTapAlert, perform: { newValue in
                guard didTapAlert != .none else { return }
                didTapAlert = .none
                selectedCategory = Model.Category.empty
                viewStore.send(.showAlert)
            })
            .onChange(of: selectedCategory, perform: { newValue in
                guard newValue != Model.Category.empty else { return }
                guard newValue.text != "COMING\nSOON" else {
                    viewStore.send(.showAlert)
                    return
                }
                present = .cardList
            })
            .fullScreenCover(item: $present,
                             onDismiss: {
                selectedCategory = Model.Category.empty
            },
                             content: { scene in
                switch scene {
                case .cardList:
                    CardListView(category: selectedCategory,
                                 store: Store(initialState: CardListReducer.State(),
                                              reducer: CardListReducer()))
                }
            })
            .onAppear {
                viewStore.send(.fetchCategories)
            }
        }
    }
}

struct CategoryTitleView: View {
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Image("Graphic")
            }
            .offset(y: 38)
            
            HStack {
                VStack(alignment: .leading, spacing: Design.Constraint.Title.spacing) {
                    Text(Design.Text.mainTitle)
                        .font(.Pretendard.h1)
                    Text(Design.Text.subTitle)
                        .font(.Pretendard.b3_regular)
                }
                .foregroundColor(.Talkbbokki.GrayScale.white)
                Spacer()
            }
            .padding(.top, Design.Constraint.Title.topInset)
            .padding(.leading, Design.Constraint.Title.leftInset)
        }
    }
}

struct CategoryCardGridView: View {
    @Binding var touchedCardView: Model.Category
    let categories: [Model.Category]
    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed(Design.Constraint.CardView.width),
                                     spacing: Design.Constraint.CardView.spacing
                                    ),
                            GridItem(.fixed(Design.Constraint.CardView.width),
                                     spacing: Design.Constraint.CardView.spacing)],
                  spacing: Design.Constraint.CardView.spacing) {
            ForEach(categories) { category in
                CategoryCardView(touched: $touchedCardView,
                                 category: category)
                .frame(width: Design.Constraint.CardView.cardSize.width,
                       height: Design.Constraint.CardView.cardSize.height)
            }
        }
    }
}

struct CategoryCardView: View {
    @Binding var touched: Model.Category
    let category: Model.Category
    var body: some View {
        Button {
            touched = category
        } label: {
            ZStack {
                Color(hex: category.bgColor.color)
                    .cornerRadius(8)
                    .frame(height: Design.Constraint.CardView.height)
                VStack(spacing: 0) {
                    Image(category.imageName.orEmpty)
                        .resizable()
                        .frame(width: Design.Constraint.CardView.imageSize.width,
                               height: Design.Constraint.CardView.imageSize.height)
                    Text(category.text)
                        .foregroundColor(.white)
                        .font(.Pretendard.b2_bold)
                }
                Image("Bling")
                    .resizable()
                    .zIndex(0)
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(store: Store(initialState: CategoryReducer.State(),
                                  reducer: CategoryReducer()))
    }
}
