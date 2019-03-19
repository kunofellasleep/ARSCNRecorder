
import UIKit
import CoreVideo

public extension UIImage {
    
    func getCvPixelBuffer(pixelBufferPool: CVPixelBufferPool) -> CVPixelBuffer?{
        
        guard let width = cgImage?.width else { return nil }
        guard let height = cgImage?.height else { return nil }
        
        var maybePixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &maybePixelBuffer)
        
        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        guard let context = CGContext(data: pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            else {
                return nil
        }
        guard let cgImage = cgImage else { return nil }
        let drawRect = CGRect(origin: .zero, size: size)
        context.clear(drawRect)
        context.draw(cgImage, in: drawRect)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
        return pixelBuffer
    }
    
}
