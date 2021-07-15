//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

class RemoteImageContainerViewModel: ObservableObject {
    
    @Published var imageData = Data()
    
    init(imageUrl: URL?) {
        guard let imgUrl = imageUrl else { return }
        
        URLSession.shared.dataTask(with: imgUrl) { data, response, error in
            guard let dataValue = data else { return }
            
            DispatchQueue.main.async {
                self.imageData = dataValue
            }
        }.resume()
    }
}
