
import AVFoundation
import UIKit
import ARKit
import Photos

public class ARSCNRecorder: NSObject {
    
    var writer: AVAssetWriter!
    var input: AVAssetWriterInput?
    var adaptor: AVAssetWriterInputPixelBufferAdaptor?
    var options:ARSCNRecorderOptions!
    
    var startTime: TimeInterval = 0.0
    var dispachQueue = DispatchQueue(label: "tokyo.kunofellasleep.ARSCNRecorder")
    var photoLibraryUtils = PhotoLibraryUtils()
    
    private let renderer = SCNRenderer(device: nil, options: nil)
    private var sceneView: SCNView!
    public typealias urlCompletion = (URL?) -> ()
    
    public func startRecording(_ sceneView: ARSCNView, _ options:ARSCNRecorderOptions){
        self.resetWriter(options)
        self.renderer.scene = sceneView.scene
        self.renderer.pointOfView = sceneView.pointOfView
        self.renderer.autoenablesDefaultLighting = sceneView.autoenablesDefaultLighting
        self.sceneView = sceneView
        self.sceneView.preferredFramesPerSecond = 30
        if writer.startWriting() {
            let cmTime = CMTimeMakeWithSeconds(startTime, preferredTimescale: Int32(NSEC_PER_SEC))
            writer.startSession(atSourceTime: cmTime)
            self.updateRecording(currentTime: startTime)
        }
    }
    
    public func finishRecording(isSaveLibrary:Bool, _ completion: @escaping urlCompletion) {
        guard let writer = self.writer else { return }
        if writer.status != .writing { return }
        input?.markAsFinished()
        writer.finishWriting {
            print("Finish writing :: \(self.options.url)")
            self.sceneView.preferredFramesPerSecond = 0
            if isSaveLibrary {
                self.photoLibraryUtils.checkRequest { (isRequested) in
                    if isRequested! {
                        self.photoLibraryUtils.save(self.options.url, { (isSaved) in
                            print("Saved video to Photo library :: \(String(describing: isSaved))")
                            completion(self.options.url)
                        })
                    }
                }
            } else {
                completion(self.options.url)
            }
        }
    }
    
    public func getIsRecording() -> Bool{
        guard let writer = self.writer else {
            return false
        }
        return (writer.status == .writing)
    }
    
    public func cancelRecording(){
        guard let writer = self.writer else { return }
        if writer.status != .writing { return }
        writer.cancelWriting()
        self.sceneView.preferredFramesPerSecond = 0
    }
    
    private func updateRecording(currentTime:TimeInterval){
        dispachQueue.async {
            guard let writer = self.writer else { return }
            if writer.status != .writing { return }
            let image = self.renderer.snapshot(atTime: currentTime, with: self.options.size, antialiasingMode: .multisampling2X)
            guard let pixelBufferPool = self.adaptor?.pixelBufferPool else {
                return }
            guard let pixelBuffer = image.getCvPixelBuffer(pixelBufferPool: pixelBufferPool) else {
                return
            }
            guard self.input?.isReadyForMoreMediaData ?? false else { return }
            let cmTime = CMTimeMakeWithSeconds(currentTime, preferredTimescale: Int32(NSEC_PER_SEC))
            self.adaptor?.append(pixelBuffer, withPresentationTime: cmTime)
        }
        
    }
    
    private func resetWriter( _ options:ARSCNRecorderOptions){
        self.options = options
        guard let writer = try? AVAssetWriter(outputURL: options.url, fileType: .mp4) else {
            fatalError("could not make writer")
        }
        self.writer = writer
        let settings : [String : Any] = [
            AVVideoCodecKey: options.codec,
            AVVideoWidthKey: options.size.width,
            AVVideoHeightKey: options.size.height
        ]
        self.input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
        self.writer.add(self.input!)
        self.adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: self.input!,
            sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
                kCVPixelBufferWidthKey as String: options.size.width,
                kCVPixelBufferHeightKey as String: options.size.height,
                ]
        )
    }
    
}

extension ARSCNRecorder: ARSCNViewDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let writer = self.writer else {
            self.startTime = time
            return
        }
        if writer.status == .writing {
            self.updateRecording(currentTime: time)
        } else {
            self.startTime = time
        }
    }
}


