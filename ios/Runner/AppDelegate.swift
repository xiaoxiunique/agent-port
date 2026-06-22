import Flutter
import UIKit
import AVKit
import AVFoundation
import CoreMedia
import CoreVideo

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    DispatchQueue.main.async {
      if let controller = self.window?.rootViewController as? FlutterViewController {
        AgentPortPip.shared.register(with: controller)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// MARK: - Frame renderer (text → CVPixelBuffer → CMSampleBuffer)

final class AgentPortPipRenderer {
  struct Frame {
    let title: String
    let statusText: String
    let statusColor: UIColor
    let body: String
  }

  private(set) var renderSize: CGSize
  private var pixelBufferPool: CVPixelBufferPool?
  private var formatDescription: CMVideoFormatDescription?

  private let backgroundColor = UIColor(red: 0.043, green: 0.059, blue: 0.078, alpha: 1)
  private let titleColor = UIColor.white
  private let bodyColor = UIColor(white: 0.86, alpha: 1)
  private let padding: CGFloat = 12
  private var headerHeight: CGFloat { 22 }

  init(renderSize: CGSize = CGSize(width: 640, height: 360)) {
    self.renderSize = renderSize
  }

  func updateRenderSize(_ size: CGSize) {
    let normalized = CGSize(
      width: max(160, Int(size.width.rounded())),
      height: max(90, Int(size.height.rounded())))
    guard normalized != renderSize else { return }
    renderSize = normalized
    pixelBufferPool = nil
    formatDescription = nil
  }

  func makeSampleBuffer(_ frame: Frame, presentationTime: CMTime) -> CMSampleBuffer? {
    guard let pixelBuffer = makePixelBuffer() else { return nil }
    draw(frame, into: pixelBuffer)
    return wrap(pixelBuffer, presentationTime: presentationTime)
  }

  private func draw(_ frame: Frame, into pixelBuffer: CVPixelBuffer) {
    CVPixelBufferLockBaseAddress(pixelBuffer, [])
    defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }

    let width = CVPixelBufferGetWidth(pixelBuffer)
    let height = CVPixelBufferGetHeight(pixelBuffer)
    guard let base = CVPixelBufferGetBaseAddress(pixelBuffer) else { return }

    let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
      | CGBitmapInfo.byteOrder32Little.rawValue
    guard let ctx = CGContext(
      data: base,
      width: width,
      height: height,
      bitsPerComponent: 8,
      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
      space: CGColorSpaceCreateDeviceRGB(),
      bitmapInfo: bitmapInfo
    ) else { return }

    UIGraphicsPushContext(ctx)
    ctx.translateBy(x: 0, y: CGFloat(height))
    ctx.scaleBy(x: 1, y: -1)
    defer { UIGraphicsPopContext() }

    let bounds = CGRect(x: 0, y: 0, width: width, height: height)
    backgroundColor.setFill()
    ctx.fill(bounds)
    drawHeader(frame, in: bounds)
    drawBody(frame.body, in: bounds)
  }

  private func drawHeader(_ frame: Frame, in bounds: CGRect) {
    let dotSize: CGFloat = 9
    let dotY = padding + (headerHeight - dotSize) / 2
    let dotRect = CGRect(x: padding, y: dotY, width: dotSize, height: dotSize)
    frame.statusColor.setFill()
    UIBezierPath(ovalIn: dotRect).fill()

    let titleFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
    let titleX = dotRect.maxX + 8
    let statusFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
    let statusText = frame.statusText as NSString
    let statusSize = statusText.size(withAttributes: [.font: statusFont])
    let statusRect = CGRect(
      x: bounds.width - padding - statusSize.width,
      y: padding + (headerHeight - statusSize.height) / 2,
      width: statusSize.width,
      height: statusSize.height)
    statusText.draw(in: statusRect, withAttributes: [
      .font: statusFont,
      .foregroundColor: frame.statusColor,
    ])

    let titleRect = CGRect(
      x: titleX,
      y: padding,
      width: max(0, statusRect.minX - 8 - titleX),
      height: headerHeight)
    let titleParagraph = NSMutableParagraphStyle()
    titleParagraph.lineBreakMode = .byTruncatingTail
    (frame.title as NSString).draw(in: titleRect, withAttributes: [
      .font: titleFont,
      .foregroundColor: titleColor,
      .paragraphStyle: titleParagraph,
    ])
  }

  private func drawBody(_ body: String, in bounds: CGRect) {
    let font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
    let lineHeight = font.lineHeight
    let top = padding + headerHeight + 6
    let available = bounds.height - top - padding
    guard available > lineHeight else { return }
    let maxLines = max(1, Int(available / lineHeight))
    let lines = body.split(separator: "\n", omittingEmptySubsequences: false).suffix(maxLines)
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineBreakMode = .byTruncatingTail
    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: bodyColor,
      .paragraphStyle: paragraph,
    ]
    var y = top
    for line in lines {
      let rect = CGRect(
        x: padding,
        y: y,
        width: bounds.width - padding * 2,
        height: lineHeight)
      (String(line) as NSString).draw(in: rect, withAttributes: attributes)
      y += lineHeight
    }
  }

  private func makePixelBuffer() -> CVPixelBuffer? {
    if pixelBufferPool == nil { createPool() }
    guard let pool = pixelBufferPool else { return nil }
    var pixelBuffer: CVPixelBuffer?
    CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pool, &pixelBuffer)
    return pixelBuffer
  }

  private func createPool() {
    let attributes: [String: Any] = [
      kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
      kCVPixelBufferWidthKey as String: Int(renderSize.width),
      kCVPixelBufferHeightKey as String: Int(renderSize.height),
      kCVPixelBufferIOSurfacePropertiesKey as String: [:],
    ]
    var pool: CVPixelBufferPool?
    CVPixelBufferPoolCreate(kCFAllocatorDefault, nil, attributes as CFDictionary, &pool)
    pixelBufferPool = pool
  }

  private func wrap(_ pixelBuffer: CVPixelBuffer, presentationTime: CMTime) -> CMSampleBuffer? {
    if formatDescription == nil
      || !CMVideoFormatDescriptionMatchesImageBuffer(formatDescription!, imageBuffer: pixelBuffer) {
      var description: CMVideoFormatDescription?
      CMVideoFormatDescriptionCreateForImageBuffer(
        allocator: kCFAllocatorDefault,
        imageBuffer: pixelBuffer,
        formatDescriptionOut: &description)
      formatDescription = description
    }
    guard let formatDescription else { return nil }
    var timing = CMSampleTimingInfo(
      duration: .invalid,
      presentationTimeStamp: presentationTime,
      decodeTimeStamp: .invalid)
    var sampleBuffer: CMSampleBuffer?
    CMSampleBufferCreateReadyWithImageBuffer(
      allocator: kCFAllocatorDefault,
      imageBuffer: pixelBuffer,
      formatDescription: formatDescription,
      sampleTiming: &timing,
      sampleBufferOut: &sampleBuffer)
    if let sampleBuffer,
       let attachments = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, createIfNecessary: true),
       CFArrayGetCount(attachments) > 0 {
      let raw = CFArrayGetValueAtIndex(attachments, 0)
      let dictionary = unsafeBitCast(raw, to: CFMutableDictionary.self)
      CFDictionarySetValue(
        dictionary,
        Unmanaged.passUnretained(kCMSampleAttachmentKey_DisplayImmediately).toOpaque(),
        Unmanaged.passUnretained(kCFBooleanTrue).toOpaque())
    }
    return sampleBuffer
  }
}

// MARK: - PiP controller

final class AgentPortPip: NSObject {
  static let shared = AgentPortPip()

  private let displayLayer = AVSampleBufferDisplayLayer()
  private let renderer = AgentPortPipRenderer()
  private var pipController: AVPictureInPictureController?
  private var hostView: UIView?
  private var renderLoop: Timer?
  private var isPaused = false
  private var title = ""
  private var statusColor: UIColor = .systemGray
  private var statusText = ""
  private var body = ""
  private let bodyLineLimit = 60

  private override init() {
    super.init()
    displayLayer.videoGravity = .resizeAspect
  }

  func register(with controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: "agent_port/pip",
      binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      DispatchQueue.main.async {
        guard let self else { result(nil); return }
        switch call.method {
        case "isSupported":
          result(AVPictureInPictureController.isPictureInPictureSupported())
        case "start":
          self.applyArgs(call.arguments)
          self.start()
          result(nil)
        case "update":
          self.applyArgs(call.arguments)
          self.renderFrame()
          result(nil)
        case "stop":
          self.stop()
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }

  private func applyArgs(_ args: Any?) {
    guard let dict = args as? [String: String] else { return }
    title = dict["title"] ?? title
    if let s = dict["status"] {
      statusText = s
      statusColor = Self.color(forStatus: s)
    }
    body = dict["body"] ?? body
  }

  private static func color(forStatus s: String) -> UIColor {
    switch s.lowercased() {
    case "running": return .systemGreen
    case "waiting": return .systemYellow
    case "failed": return .systemRed
    case "done": return .systemBlue
    default: return .systemGray
    }
  }

  private func start() {
    guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
    configureAudioSession()
    attachLayerIfNeeded()
    setupControllerIfNeeded()
    startRenderLoop()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
      self?.pipController?.startPictureInPicture()
    }
  }

  private func stop() {
    pipController?.stopPictureInPicture()
  }

  private func startRenderLoop() {
    renderLoop?.invalidate()
    renderLoop = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.renderFrame()
    }
  }

  private func renderFrame() {
    guard !isPaused else { return }
    let sampleBufferRenderer = displayLayer.sampleBufferRenderer
    if sampleBufferRenderer.status == .failed { sampleBufferRenderer.flush() }
    let trimmed = body
      .split(separator: "\n", omittingEmptySubsequences: false)
      .suffix(bodyLineLimit)
      .joined(separator: "\n")
    let frame = AgentPortPipRenderer.Frame(
      title: title,
      statusText: statusText,
      statusColor: statusColor,
      body: trimmed)
    let time = CMClockGetTime(CMClockGetHostTimeClock())
    guard let sampleBuffer = renderer.makeSampleBuffer(frame, presentationTime: time) else { return }
    sampleBufferRenderer.enqueue(sampleBuffer)
  }

  private func attachLayerIfNeeded() {
    guard hostView == nil, let window = Self.keyWindow else { return }
    let host = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 68))
    host.isUserInteractionEnabled = false
    displayLayer.frame = host.bounds
    host.layer.addSublayer(displayLayer)
    window.insertSubview(host, at: 0)
    hostView = host
  }

  private func setupControllerIfNeeded() {
    guard pipController == nil else { return }
    let source = AVPictureInPictureController.ContentSource(
      sampleBufferDisplayLayer: displayLayer,
      playbackDelegate: self)
    let controller = AVPictureInPictureController(contentSource: source)
    controller.delegate = self
    pipController = controller
  }

  private func configureAudioSession() {
    let session = AVAudioSession.sharedInstance()
    try? session.setCategory(.playback, mode: .moviePlayback, options: [.mixWithOthers])
    try? session.setActive(true)
  }

  private func teardown() {
    renderLoop?.invalidate()
    renderLoop = nil
    displayLayer.sampleBufferRenderer.flush()
    hostView?.removeFromSuperview()
    hostView = nil
    isPaused = false
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
  }

  private static var keyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
  }
}

extension AgentPortPip: AVPictureInPictureSampleBufferPlaybackDelegate {
  func pictureInPictureController(
    _ controller: AVPictureInPictureController,
    setPlaying playing: Bool) {
    isPaused = !playing
  }
  func pictureInPictureControllerTimeRangeForPlayback(
    _ controller: AVPictureInPictureController) -> CMTimeRange {
    CMTimeRange(start: .negativeInfinity, duration: .positiveInfinity)
  }
  func pictureInPictureControllerIsPlaybackPaused(
    _ controller: AVPictureInPictureController) -> Bool {
    isPaused
  }
  func pictureInPictureController(
    _ controller: AVPictureInPictureController,
    didTransitionToRenderSize newRenderSize: CMVideoDimensions) {
    renderer.updateRenderSize(
      CGSize(width: Int(newRenderSize.width), height: Int(newRenderSize.height)))
    renderFrame()
  }
  func pictureInPictureController(
    _ controller: AVPictureInPictureController,
    skipByInterval skipInterval: CMTime,
    completion completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}

extension AgentPortPip: AVPictureInPictureControllerDelegate {
  func pictureInPictureControllerDidStartPictureInPicture(
    _ controller: AVPictureInPictureController) {}
  func pictureInPictureController(
    _ controller: AVPictureInPictureController,
    failedToStartPictureInPictureWithError error: Error) {
    teardown()
  }
  func pictureInPictureControllerDidStopPictureInPicture(
    _ controller: AVPictureInPictureController) {
    teardown()
  }
}
