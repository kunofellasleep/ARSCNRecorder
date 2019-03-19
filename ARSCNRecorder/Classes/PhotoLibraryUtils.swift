
import UIKit
import Photos

public class PhotoLibraryUtils: NSObject {
    
    public typealias requestCompletion = (Bool?) -> ()
    public typealias saveCompletion = (Bool?) -> ()
    
    public func checkRequest(_ completion: @escaping requestCompletion) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            completion(true)
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .denied {
                    self.openDeniedAlert()
                }
                completion(status == .authorized)
            }
        }
    }
        
    public func save(_ videoUrl:URL, _ completion: @escaping saveCompletion) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoUrl)
        }) { isSuccess, error in
            if error != nil { print(error!) }
            completion(isSuccess)
        }
    }
    
    private func openDeniedAlert(){
        let alert = UIAlertController(title: "allow Photos access from setting", message: nil, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Setting", style: .default, handler: { (_) -> Void in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString ) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        })
        let closeAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(closeAction)
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
    
}
