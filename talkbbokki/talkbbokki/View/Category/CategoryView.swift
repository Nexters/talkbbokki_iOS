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
            static let height: CGFloat = 179
        }
        
        struct CategoryView {
            static let spacing: CGFloat = 59
        }
    }
    
    enum Text {
        static let mainTitle = "오늘 이런\n토픽 어때요?"
        static let subTitle = "긴 침묵은 그만\n쉽게 뽑는 오늘의 주제"
    }
}

struct CategoryView: View {
    @State private var selectedCategory: Model.Category?
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
            }.onAppear {
                viewStore.send(.fetchCategories)
            }
        }
    }
}

struct CategoryTitleView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Design.Constraint.Title.spacing) {
                Text(Design.Text.mainTitle)
                Text(Design.Text.subTitle)
            }.background(Color.blue)
            Spacer()
        }
        .padding(.top, Design.Constraint.Title.topInset)
        .padding(.leading, Design.Constraint.Title.leftInset)
        .background(Color.green)
    }
}

struct CategoryCardGridView: View {
    @Binding var touchedCardView: Model.Category?
    let categories: [Model.Category]
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()),
                            GridItem(.flexible())]) {
            ForEach(categories) { category in
                CategoryCardView(touched: $touchedCardView,
                                 category: category)
            }
        }.background(Color.yellow)
    }
}

struct CategoryCardView: View {
    @Binding var touched: Model.Category?
    let category: Model.Category
    var body: some View {
        NavigationLink(destination: CardListView()) {
            ZStack {
                Color.red
                    .cornerRadius(15)
                    .padding()
                    .frame(height: Design.Constraint.CardView.height)
                Text(category.text)
                    .zIndex(0)
            }
        }
//        Button {
//            touched = category
//        } label: {
//            ZStack {
//                Color.red
//                    .cornerRadius(15)
//                    .padding()
//                    .frame(height: Design.Constraint.CardView.height)
//                Text(category.text)
//                    .zIndex(0)
//            }
//        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(store: Store(initialState: CategoryReducer.State(),
                                  reducer: CategoryReducer()))
    }
}
