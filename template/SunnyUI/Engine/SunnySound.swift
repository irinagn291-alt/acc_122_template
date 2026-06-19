import AVFoundation

enum SunnySound {
    private static var player: AVAudioPlayer?

    static func playPop(enabled: Bool) {
        guard enabled else { return }
        playTone(frequency: 520, duration: 0.12)
    }

    static func playCelebrate(enabled: Bool) {
        guard enabled else { return }
        playTone(frequency: 660, duration: 0.18)
    }

    private static func playTone(frequency: Double, duration: Double) {
        let sampleRate = 44100.0
        let frameCount = Int(sampleRate * duration)
        var samples = [Float](repeating: 0, count: frameCount)

        for i in 0..<frameCount {
            let t = Double(i) / sampleRate
            let envelope = 1.0 - (t / duration)
            samples[i] = Float(sin(2.0 * .pi * frequency * t) * envelope * 0.3)
        }

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(frameCount)) else { return }
        buffer.frameLength = AVAudioFrameCount(frameCount)
        let channel = buffer.floatChannelData![0]
        for i in 0..<frameCount { channel[i] = samples[i] }

        do {
            let engine = AVAudioEngine()
            let playerNode = AVAudioPlayerNode()
            engine.attach(playerNode)
            engine.connect(playerNode, to: engine.mainMixerNode, format: format)
            try engine.start()
            playerNode.scheduleBuffer(buffer, at: nil)
            playerNode.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.1) {
                engine.stop()
            }
        } catch {}
    }
}
