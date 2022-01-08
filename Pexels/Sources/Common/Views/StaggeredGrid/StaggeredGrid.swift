//
// Copyright © 2021 An Tran. All rights reserved.
//

import SwiftUI

// Largely inspired by https://kavsoft.dev/
struct StaggeredGrid<Content: View, T: Identifiable>: View where T: Hashable {
    
    private let content: (T) -> Content
    private let list: [T]
    private let columns: Int
    private let showsIndicators: Bool
    private let spacing: CGFloat
    
    init(columns: Int = 1,
         showsIndeicators: Bool = false,
         spacing: CGFloat = 10,
         list: [T],
         @ViewBuilder content: @escaping (T) -> Content)
    {
        self.content = content
        self.list = list
        self.spacing = spacing
        self.showsIndicators = showsIndeicators
        self.columns = columns
    }
    
    func setup() -> [[T]] {
        
        var gridArray: [[T]] = Array(repeating: [], count: columns)
        
        var currentIndex = 0
        
        for object in list {
            gridArray[currentIndex].append(object)
            if currentIndex == (columns - 1) {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
        }
        
        return gridArray
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: showsIndicators) {
                HStack(alignment: .top) {
                    ForEach(setup(), id: \.self) { columnsData in
                        LazyVStack(spacing: spacing) {
                            ForEach(columnsData) { object in
                                content(object)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

struct StaggeredGrid_Previews: PreviewProvider {
    static var previews: some View {
        let images = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map {
            ImageModel(thumbnail: .local(String($0)), image: .local(String($0)))
        }
        StaggeredGrid(columns: 3, list: images) { image in
            GridItemView(image: image)
        }
    }
}
