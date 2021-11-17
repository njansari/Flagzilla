////
////  FlowLayoutView.swift
////  Flagzilla
////
////  Created by Nayan Jansari on 16/10/2021.
////
//
//import SwiftUI
//
//struct FlowLayoutView<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
//    let data: Data
//    let spacing: CGFloat
//    let content: (Data.Element) -> Content
//
//    @State private var totalHeight: Double = .infinity
//
//    init(_ data: Data, spacing: CGFloat = 4, @ViewBuilder content: @escaping (Data.Element) -> Content) {
//        self.data = data
//        self.spacing = spacing
//        self.content = content
//    }
//
////    var background: some View {
////        GeometryReader { geo in
////            Color.clear
////                .onAppear {
////                    totalHeight = geo.frame(in: .local).size.height
////                }
////        }
////    }
//
//    var body: some View {
//        VStack {
////            GeometryReader(content: main)
//        }
//        .frame(maxHeight: totalHeight)
//    }
//
//    @ViewBuilder func main(geometry: GeometryProxy) -> some View {
//        var size: CGSize = .zero
//        var lastHeight: CGFloat = .zero
//
////        ZStack(alignment: .topLeading) {
////            ForEach(data, id: \.self) { item in
////                content(item)
////                    .padding(spacing)
////                    .alignmentGuide(.top) { _ in
////                        topAlignment(size: &size, item: item)
////                    }
////                    .alignmentGuide(.leading) { dimensions in
////                        leadingAlignment(geometry: geometry, dimensions: dimensions, size: &size, lastHeight: &lastHeight, item: item)
////                    }
////            }
////        }
////        .padding(-spacing)
////        .background {
////            background
////        }
//    }
//
//    func topAlignment(size: inout CGSize, item: Data.Element) -> CGFloat {
//        let result = size.height
//
//        if item == data.last {
//            size.height = 0
//        }
//
//        return result
//    }
//
//    func leadingAlignment(geometry: GeometryProxy, dimensions: ViewDimensions, size: inout CGSize, lastHeight: inout CGFloat, item: Data.Element) -> CGFloat {
//        if abs(size.width - dimensions.width) > geometry.size.width {
//            size.width = 0
//            size.height -= lastHeight
//        }
//
//        lastHeight = dimensions.height
//
//        let result = size.width
//
//        if item == data.last {
//            size.width = 0
//        } else {
//            size.width -= dimensions.width
//        }
//
//        return result
//    }
//}
//
//struct FlowLayout_Previews: PreviewProvider {
//    static let items = [
//        "Some long item here", "And then some longer one",
//        "Short", "Items", "Here", "And", "A", "Few", "More",
//        "And then a very very long one"
//    ]
//
//    static var previews: some View {
//        FlowLayoutView(items, spacing: 4) { item in
//            Text(item)
//                .padding()
//                .background(.yellow)
//                .cornerRadius(10)
//        }
//        .padding()
//    }
//}
