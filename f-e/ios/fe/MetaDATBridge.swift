import Foundation
import AVFoundation

@objc(MetaDATBridge)
class MetaDATBridge: RCTEventEmitter {

  private var audioEngine: AVAudioEngine?
  private var streamingTimer: DispatchSourceTimer?
  private var isCurrentlyStreaming = false

  override init() {
    super.init()
  }

  // MARK: - React Native
  @objc
  override static func requiresMainQueueSetup() -> Bool {
    // Keep it false unless you must run on main thread
    return false
  }

  @objc
  override func supportedEvents() -> [String]! {
    return ["onAudioChunk"]
  }

  // MARK: - Module Methods
  @objc(initializeDAT:resolver:rejecter:)
  func initializeDAT(options: NSDictionary, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    // TODO: Replace with actual Meta DAT SDK initialization
    // Example: MetaDAT.shared.initialize(with: ...) -> call SDK
    // For now, we respond with success
    resolve(["initialized": true])
  }

  @objc(startAudioStream:rejecter:)
  func startAudioStream(resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    if isCurrentlyStreaming {
      // Already streaming
      resolve(["streaming": true])
      return
    }

    // TODO: Integrate real SDK audio stream here. For now, simulate.
    // Create and start a timer to emit pseudo audio chunks.
    isCurrentlyStreaming = true
    let queue = DispatchQueue(label: "com.fe.metadat.stream")
    streamingTimer = DispatchSource.makeTimerSource(queue: queue)
    streamingTimer?.schedule(deadline: .now(), repeating: .milliseconds(200))
    streamingTimer?.setEventHandler { [weak self] in
      guard let self = self else { return }
      // Simulate raw audio bytes - here we just craft random bytes for demo
      let sampleBytes = (0..<1024).map { _ in UInt8.random(in: 0...255) }
      let data = Data(sampleBytes)
      let base64String = data.base64EncodedString()
      // Emit the event to React Native
      self.sendEvent(withName: "onAudioChunk", body: ["data": base64String, "timestamp": Int(Date().timeIntervalSince1970 * 1000)])
    }
    streamingTimer?.resume()
    resolve(["streaming": true])
  }

  @objc(stopAudioStream:rejecter:)
  func stopAudioStream(resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    if !isCurrentlyStreaming {
      resolve(["streaming": false])
      return
    }
    isCurrentlyStreaming = false
    streamingTimer?.cancel()
    streamingTimer = nil
    resolve(["streaming": false])
  }

  @objc(isStreaming:rejecter:)
  func isStreaming(resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    resolve(["streaming": isCurrentlyStreaming])
  }

  // If the stream needs a safe shutdown
  deinit {
    streamingTimer?.cancel()
    streamingTimer = nil
  }
}
