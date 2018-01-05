#!/usr/bin/swift

import Foundation

guard CommandLine.arguments.count == 3 else {
  print("Please provide all required arguments. ❌")
  exit(0)
}

let fileURL = URL(fileURLWithPath: CommandLine.arguments[1])

let ampFactor = CommandLine.arguments[2]

do {
  let analyzer = AudioAnalyzer()
  let audioData = try analyzer.analyzeAudioFile(url: fileURL)
  print("Got \(audioData.count) points of data. Yay! ")
  
  let metadata = AudioMetadataExtractor().extractMetadataOfFileAt(fileURL)
  print("Metadata extraction done...")
  
  let desampledData = analyzer.resample(audioData, to: 4096)
  print("Downsampling done...")
  
  let amplifiedData = analyzer.amplify(desampledData, by: Float(ampFactor) ?? 100.0)
  print("Amplification done...")
  
  if let image = WaveformGenerator().generateWaveformFromAudioData(amplifiedData, metadata: metadata) {
    print("Image generation done...")
    
    let targetURL = URL(fileURLWithPath: FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop").path,
                        isDirectory: true).appendingPathComponent("waveform_\(metadata.filename).bmp")
    
    FileManager.default.createFile(atPath: targetURL.path,
                                   contents: nil,
                                   attributes: nil)
    
    try image.tiffRepresentation?.write(to: targetURL)
    print("File saved to: \(targetURL.path)")
    
    
    print("Sucessfully finished! 🎈🌟")
  } else {
   print("Image generation failed.")
  }
} catch {
  print("Caught an error:\n")
  print(error.localizedDescription)
}



