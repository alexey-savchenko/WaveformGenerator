//
//  WaveformGenerator.swift
//  WaveformGenerator
//
//  Created by Alexey Savchenko on 04.01.2018.
//  Copyright © 2018 Alexey Savchenko. All rights reserved.
//

import Foundation
import Cocoa

class WaveformGenerator {
  
  func generateWaveformFromAudioData(_ audioData: [Float],
                                     metadata: AudioMetadata) -> NSImage? {
    
    let baseDataCount = audioData.count
    
    let baseRect = CGRect(x: 0, y: 0, width: baseDataCount, height: lrintf(audioData.max()!) * 2)
    
    let workingRect = baseRect.applying(CGAffineTransform(scaleX: 1, y: 1.1))
    
    var outputImage: NSImage? = nil
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let bitmapContext = CGContext(
      data: nil,
      width: Int(workingRect.size.width),
      height: Int(workingRect.size.height),
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: colorSpace,
      bitmapInfo: bitmapInfo.rawValue)
    
    var offset: CGFloat = 0
    
    if let context = bitmapContext {
      
      let bgPath = CGPath(rect: workingRect, transform: nil)
      context.addPath(bgPath)
      context.setFillColor(NSColor.white.cgColor)
      context.fillPath()
      
      for dataPoint in audioData {
        
        let upperbarRect = CGRect(x: offset,
                                  y: workingRect.midY + CGFloat(dataPoint),
                                  width: CGFloat(1.0),
                                  height: CGFloat(-dataPoint))
        
        let bottombarRect = CGRect(x: offset,
                                   y: workingRect.midY - CGFloat(dataPoint),
                                   width: CGFloat(1.0),
                                   height: CGFloat(dataPoint))
        
        let bottombarPath = CGPath(rect: bottombarRect, transform: nil)
        let upperbarPath = CGPath(rect: upperbarRect, transform: nil)
        context.addPath(bottombarPath)
        context.addPath(upperbarPath)
        offset += 1
        
      }
      
      context.setFillColor(NSColor.red.cgColor)
      context.fillPath()
      
      //Draw text
      context.setTextDrawingMode(.fillStroke)
      
      let textAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: NSFont.systemFont(ofSize: 40),
                                                          NSAttributedStringKey.foregroundColor: NSColor.black]
      
      //Draw file name
      context.textPosition = CGPoint(x: 50, y: workingRect.height - 50)
      let filenameAttrString = NSAttributedString(string: "Filename: \(metadata.filename)", attributes: textAttributes)
      
      let filenameLine = CTLineCreateWithAttributedString(filenameAttrString)
      CTLineDraw(filenameLine, context)
      
      //Draw author name
      context.textPosition = CGPoint(x: 50, y: workingRect.height - 92)
      let authorAttrString = NSAttributedString(string: "Author: \(metadata.author)", attributes: textAttributes)
      
      let authorLine = CTLineCreateWithAttributedString(authorAttrString)
      CTLineDraw(authorLine, context)
      
      //Draw duration
      context.textPosition = CGPoint(x: 50, y: workingRect.height - 132)
      let durationAttrString = NSAttributedString(string: "Duration: \(metadata.duration) min.", attributes: textAttributes)
      
      let durationLine = CTLineCreateWithAttributedString(durationAttrString)
      CTLineDraw(durationLine, context)
      
      
      if let image = context.makeImage() {
        outputImage = NSImage(cgImage: image,
                              size: workingRect.size)
      }
      
    }
    
    return outputImage
    
  }
  
}

