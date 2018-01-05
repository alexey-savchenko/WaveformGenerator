#!/usr/bin/swift

import Foundation

let fileURL = URL(fileURLWithPath: CommandLine.arguments[1])

print("Got:\n\(fileURL)\n")

do {
  let analyzer = AudioAnalyzer()
  let audioData = try analyzer.analyzeAudioFile(url: fileURL)
  print("Got \(audioData.count) points of data.")
  
  let metadata = AudioMetadataExtractor().extractMetadataOfFileAt(fileURL)
  
  let desample = analyzer.resample(audioData, to: 4096)
  let amp = analyzer.amplify(desample, by: 500)
  
  let image = WaveformGenerator().generateWaveformFromAudioData(amp, metadata: metadata)
  
//  print(image)
  let targetURL = URL(fileURLWithPath: "/Users/iosUser/Desktop",
                      isDirectory: true).appendingPathComponent("waveform_\(fileURL.lastPathComponent).png")
  
  FileManager.default.createFile(atPath: targetURL.path,
                                 contents: nil,
                                 attributes: nil)
  
  try image!.tiffRepresentation?.write(to: targetURL)
  
  print("Sucessfully finished! 🎈")
  
} catch {
  print(error.localizedDescription)
}



