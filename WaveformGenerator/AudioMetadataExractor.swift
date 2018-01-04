//
//  AudioMetadataExractor.swift
//  WaveformGenerator
//
//  Created by Alexey Savchenko on 04.01.2018.
//  Copyright © 2018 Alexey Savchenko. All rights reserved.
//

import Foundation
import AVFoundation

class AudioMetadataExtractor {
  
  func extractMetadataOfFileAt(_ fileURL: URL) -> AudioMetadata {
    
    let filename = fileURL.lastPathComponent
    
    let item = AVPlayerItem(url: fileURL)
    
    let durInSeconds = CMTimeGetSeconds(item.asset.duration)
    
    let duration = "\(durInSeconds / 60)".substring(to: "\(durInSeconds / 60)".index("\(durInSeconds / 60)".startIndex, offsetBy: 4)).appending(" m.")
    
    let artistname: String
    
    if let artistMetadataIndex = item.asset.commonMetadata.index(where: { (metadataitem) -> Bool in
      return metadataitem.commonKey?.rawValue == "artist"
    }) {
      if let name = item.asset.commonMetadata[artistMetadataIndex].stringValue {
        artistname = name
      } else {
        artistname = "Undefined"
      }
    } else {
      artistname = "Undefined"
    }
    
    return AudioMetadata(filename: filename,
                         author: artistname,
                         duration: duration)
    
  }
  
}
