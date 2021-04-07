// Kevin Li - 3:24 PM - 7/13/20

import SwiftUI

extension Image {

    public static var uTurnLeft: Image = Image(systemName: "arrow.uturn.left")

}

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
