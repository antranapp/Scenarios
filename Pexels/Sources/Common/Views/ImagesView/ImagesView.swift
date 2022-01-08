//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import SwiftUI

struct ImagesView: View {
    
    @State var columns: Int = 4
    
    @Namespace var animation
    
    @StateObject private var viewModel: ImagesViewModel
    
    private let favouritesImageManager: FavouritesImageManaging
    private let authenticationService: AuthenticationServiceProtocol
    
    @State var toggleFavourite: Bool = false
    
    init(
        authenticationService: AuthenticationServiceProtocol,
        pexelsImageService: ImageServiceProtocol,
        favouritesImageService: FavouritesImageManaging
    ) {
        _viewModel = StateObject(wrappedValue: ImagesViewModel(service: pexelsImageService))
        self.favouritesImageManager = favouritesImageService
        self.authenticationService = authenticationService
    }
    
    var body: some View {
        NavigationView {
            switch viewModel.viewState {
            case .loading:
                ProgressView("Loading ... ")
                    .navigationTitle("Pexels")
                    .onAppear(perform: viewModel.fetchImagesOnAppear)
            case .loaded(let images):
                StaggeredGrid(columns: columns, list: images.images) { image in
                    NavigationLink(destination: ImageView(image: image, favouritesImageManager: favouritesImageManager)) {
                        GridItemView(image: image)
                            .matchedGeometryEffect(id: image.id, in: animation)
                    }
                }
                .padding(.horizontal)
                .navigationTitle("Pexels")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            columns += 1
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            columns = max(columns - 1, 1)
                        } label: {
                            Image(systemName: "minus")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            authenticationService.logout()
                        } label: {
                            Image(systemName: "poweroff")
                        }
                    }
                }
                .animation(.easeInOut, value: columns)
            case let .failed(error):
                VStack(spacing: 20) {
                    Image(systemName: "xmark.octagon.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color.red)
                    Text(error.localizedDescription)
                        .font(.title)
                }
                .padding(.horizontal)
                .navigationTitle("Pexels")
            }
        }
    }
}

struct ImagesView_Previews: PreviewProvider {
    
    final class DummyImageService: FavouritesImageManaging {
        func fetch() -> Future<ImagesModel, Error> {
            Future { promise in
                return promise(.success(
                    ImagesModel(
                        images: Array(1 ... 10).map {
                            ImageModel(thumbnail: .local(String($0)), image: .local(String($0)))
                        }
                    ))
                )
            }
        }
        
        func toggle(_ imageModel: ImageModel) {}
        func hasFavourited(_ imageModel: ImageModel) -> Bool {
            false
        }
    }
    
    final class DummyAuthenticationService: AuthenticationServiceProtocol {
        let apiKey = CurrentValueSubject<String?, Never>(nil)
        func login(_ apiKey: String) {}
        func logout() {}
    }
    
    static var previews: some View {
        ImagesView(
            authenticationService: DummyAuthenticationService(),
            pexelsImageService: DummyImageService(),
            favouritesImageService: DummyImageService()
        )
    }
}

struct GridItemView: View {
    let image: ImageModel
    
    var body: some View {
        image.imageview()
    }
}
