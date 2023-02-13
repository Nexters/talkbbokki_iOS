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
            static let imageSize: CGSize = CGSize(width: 100, height: 100)
        }
        
        struct CategoryView {
            static let spacing: CGFloat = 60
        }
    }
    
    enum Text {
        static let mainTitle = "Let’s\nBBOKKI !"
        static let subTitle = "친밀도를 골라보세요!\n딱 - 맞는 대화주제 추천해줄게요!"
    }
}

struct CategoryView: View {
    @State private var selectedCategory: Model.Category = Model.Category.empty
    @State private var presentCardListView: Bool = false
    let store: StoreOf<CategoryReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack(spacing: Design.Constraint.CategoryView.spacing) {
                    CategoryTitleView()
                    CategoryCardGridView(touchedCardView: $selectedCategory,
                                         categories: viewStore.categories)
                    Spacer()
                }
            }
            .onChange(of: selectedCategory, perform: { newValue in
                guard newValue != Model.Category.empty else { return }
                presentCardListView.toggle()
            })
            .fullScreenCover(isPresented: $presentCardListView,
                             onDismiss: {
                selectedCategory = Model.Category.empty
            },content: {
                CardListView(category: selectedCategory,
                             store: Store(initialState: CardListReducer.State(),
                                          reducer: CardListReducer()))
            })
            .onAppear {
                viewStore.send(.fetchCategories)
            }
        }
    }
}

struct CategoryTitleView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Design.Constraint.Title.spacing) {
                Text(Design.Text.mainTitle).font(.Pretendard.h1)
                    .frame(maxHeight: .infinity)
                Text(Design.Text.subTitle).font(.Pretendard.b3_regular)
                    .frame(maxHeight: .infinity)
            }
            Spacer()
        }
        .padding(.top, Design.Constraint.Title.topInset)
        .padding(.leading, Design.Constraint.Title.leftInset)
        .background(Color.green)
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
            }
        }.background(Color.yellow)
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
                Color.red
                    .cornerRadius(15)
                    .frame(height: Design.Constraint.CardView.height)
                VStack(spacing: 0) {
                    Image("")
                        .frame(width: Design.Constraint.CardView.imageSize.width,
                               height: Design.Constraint.CardView.imageSize.height)
                        .background(Color.blue)
                    Text(category.text)
                        .foregroundColor(.white)
                        .font(.Pretendard.b2_bold)
                }.zIndex(0)
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
