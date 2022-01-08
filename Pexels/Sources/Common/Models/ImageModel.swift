//
// Copyright © 2021 An Tran. All rights reserved.
//

import SDWebImageSwiftUI
import SwiftUI

struct ImageModel: Identifiable, Hashable, Codable {
    
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID().uuidString
    let thumbnail: ImageSource
    let image: ImageSource
    
    @ViewBuilder
    func imageview() -> some View {
        switch image {
        case .local(let name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .remote(let url):
            WebImage(url: url, options: [.progressiveLoad, .delayPlaceholder, .scaleDownLargeImages])
                .resizable()
                .placeholder {
                    Image(systemName: "wifi.slash")
                        .font(.largeTitle)
                        .foregroundColor(Color.secondary.opacity(0.5))
                }
                .indicator { _, _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondary.opacity(0.2))
                }
                .scaledToFit()
        }
    }
}

enum ImageSource: Codable, Equatable {
    case local(_ name: String)
    case remote(_ url: URL)
    
    enum CodingKeys: String, CodingKey {
        case local, remote
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let localName = try container.decodeIfPresent(String.self, forKey: .local) {
            self = .local(localName)
        } else {
            guard let remoteURL = try container.decodeIfPresent(URL.self, forKey: .remote) else {
                throw ImageSourceError.decodingError
            }
            self = .remote(remoteURL)
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .local(let value):
            try container.encode(value, forKey: .local)
        case .remote(let value):
            try container.encode(value, forKey: .remote)
        }
    }
}

enum ImageSourceError: Error {
    case decodingError
}
