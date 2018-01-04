#!/usr/bin/swift

import Foundation

let fileURL = URL(fileURLWithPath: CommandLine.arguments[1])

print("Got:\n\(fileURL)\n")

do {
  let analyzer = AudioAnalyzer()
  let audioData = try analyzer.analyzeAudioFile(url: fileURL)
  print("Got \(audioData.count) points of data.")
  
  let metadata = AudioMetadataExtractor().extractMetadataOfFileAt(fileURL)
  
  let image = WaveformGenerator().generateWaveformFromAudioData(audioData, metadata: metadata)
  
  let targetURL = URL(fileURLWithPath: "/Users/DreDD/Desktop", isDirectory: true).appendingPathComponent("img.png")
  
  try image.tiffRepresentation?.write(to: targetURL)
  
} catch {
  print(error.localizedDescription)
}



