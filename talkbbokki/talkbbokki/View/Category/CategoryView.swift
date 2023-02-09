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
    }
    
    enum Text {
        static let mainTitle = "오늘 이런\n토픽 어때요?"
        static let subTitle = "긴 침묵은 그만\n쉽게 뽑는 오늘의 주제"
    }
}

struct CategoryView: View {
    let store: StoreOf<CategoryReducer>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    CategoryTitleView()
                    Spacer()
                    CategoryCardGridView(categories: viewStore.categories)
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
    let categories: [Model.Category]
    var body: some View {
        LazyVGrid(columns: categories.map { _ in GridItem() }) {
            ForEach(categories) { category in
                CategoryCardView(category: category)
            }
        }
        .background(Color.yellow)
    }
}

struct CategoryCardView: View {
    let category: Model.Category
    var body: some View {
        ZStack {
            Color.red
                .cornerRadius(15)
                .frame(width: 150, height: 150)
                .padding()
            Text(category.text).zIndex(0)
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(store: Store(initialState: CategoryReducer.State(),
                                  reducer: CategoryReducer()))
    }
}
