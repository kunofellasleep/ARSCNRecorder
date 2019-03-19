
import AVFoundation

public class ARSCNRecorderOptions: NSObject {
    //Default Settings
    let url = NSURL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("\(Int64(Date().timeIntervalSince1970 * 1000)).mp4")!
    public var codec:AVVideoCodecType = AVVideoCodecType.h264
    public var size:CGSize = CGSize(width: 1080.0, height: 1920.0)
}
