//
//  File.swift
//  
//
//  Created by Ethan Hardacre  on 1/29/21.
//

import Foundation
import SwiftUI

struct RemoteImage: View {
    
    public let id = UUID()
    
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        @Published var data = Data()
        var state = LoadState.loading

        init(url: String) {
            guard let parsedURL = URL(string: url) else {
                fatalError("Invalid URL: \(url)")
            }

            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }
            }.resume()
        }
    }

    @StateObject private var loader: Loader
    @State var loadComplete = false
    var loading: Image
    var failure: Image

    var body: some View {
        if !loadComplete{
            ProgressView()
        }else{
            selectImage()
                .resizable()
                .scaledToFit()
        }
    }

    init(url: String, loading: Image = Image(systemName: "rays"), failure: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
    }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                loadComplete = true
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}
