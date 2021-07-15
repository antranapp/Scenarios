//
// Copyright © 2021 An Tran. All rights reserved.
//

import Combine
import Foundation

class RemoteImageContainerViewModel: ObservableObject {
    
    @Published var imageData = Data()
    @Published var error: Bool = false
    
    init(url: URL?) {
        
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.error = true
                }
            }
            guard let dataValue = data else {
                DispatchQueue.main.async {
                    self.error = true
                }
                return
            }
            
            DispatchQueue.main.async {
                self.imageData = dataValue
            }
        }.resume()
    }
}
