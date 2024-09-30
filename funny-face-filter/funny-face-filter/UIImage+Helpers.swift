/// Copyright (c) 2024 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Vision
import OSLog

extension UIImage {
  /// Draws a vision rectangle on the image, adjusting for the image's orientation.
  ///
  /// This method is the main point of access, allowing you to draw a red rectangle on the image based on a vision rectangle.
  /// The rectangle's position is corrected based on the image's orientation.
  ///
  /// - Parameter visionRect: The rectangle to be drawn, provided in normalized coordinates.
  /// - Returns: A new `UIImage` with the vision rectangle drawn, or the original image if inputs are invalid.
  func drawVisionRect(_ visionRect: FaceModel?) -> UIImage? {
    
    logger.debug("Original UIImage has an orientation of: \(self.imageOrientation.rawValue)")
    // Ensure the image's CGImage representation is available.
    
    guard let cgImage = self.cgImage else {
      return nil
    }
    
    // If visionRect is not provided, return the original image.
    guard let visionRect = visionRect else {
      return self
    }
    
    // Prepare the context size based on the image dimensions.
    let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
    
    // Begin a new image context with the correct size and scale.
    UIGraphicsBeginImageContextWithOptions(imageSize, false, self.scale)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    
    // Draw the original image in the context.
    context.draw(cgImage, in: CGRect(origin: .zero, size: imageSize))
    
    
    // Calculate the rectangle using Vision's coordinate system to image coordinates.
      let correctedRect = VNImageRectForNormalizedRect(visionRect.boundingBox, Int(imageSize.width), Int(imageSize.height))
      
      guard let leftEyepoints = visionRect.observation.landmarks?.leftEye?.normalizedPoints else { return nil }
      guard let rightEyepoints = visionRect.observation.landmarks?.rightEye?.normalizedPoints else { return nil }
      
      let leftEyeRect = createEyeBoundingBox(points: leftEyepoints, faceBoundingBox: visionRect.boundingBox, imageSize: imageSize)
      
      let rightEyeRect = createEyeBoundingBox(points: rightEyepoints, faceBoundingBox: visionRect.boundingBox, imageSize: imageSize)
      
//      // Draw the vision rectangle for left eye.
        UIColor.black.withAlphaComponent(0.3).setFill()
        let leftEyeRectPath = UIBezierPath(roundedRect: leftEyeRect, cornerRadius: correctedRect.height + 10)
        leftEyeRectPath.fill()
        UIColor.white.setStroke()
        leftEyeRectPath.lineWidth = 10
        leftEyeRectPath.stroke()

      //      // Draw the vision rectangle for left eye.
        UIColor.black.withAlphaComponent(0.3).setFill()
        let rightEyeRectPath = UIBezierPath(roundedRect: rightEyeRect, cornerRadius: correctedRect.height + 10)
        rightEyeRectPath.fill()
        UIColor.white.setStroke()
        rightEyeRectPath.lineWidth = 10
        rightEyeRectPath.stroke()
      
    // Get the resulting image from the current context.
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    
    // End the image context to free up resources.
    UIGraphicsEndImageContext()
    
    // Adjust the image's orientation before returning.
    guard let finalCgImage = newImage?.cgImage else {
      return nil
    }
    
    let correctlyOrientedImage = UIImage(
      cgImage: finalCgImage,
      scale: self.scale,
      orientation: self.adjustOrientation()
    )
    logger.debug("Final image needs an orientation of \(correctlyOrientedImage.imageOrientation.rawValue) to look right.")
    return correctlyOrientedImage
  }
    
    private func createEyeBoundingBox(points: [CGPoint], faceBoundingBox: CGRect, imageSize: CGSize) -> CGRect {
        if points.isEmpty { return CGRect() }
        
        let minX = points.min { $0.x < $1.x }!.x
        let minY = points.min { $0.y < $1.y }!.y
        let maxX = points.max { $0.x < $1.x }!.x
        let maxY = points.max { $0.y < $1.y }!.y
        let minPoint = VNImagePointForFaceLandmarkPoint( vector_float2(Float(minX), Float(minY)), faceBoundingBox, Int(imageSize.width), Int(imageSize.height))
        let maxPoint = VNImagePointForFaceLandmarkPoint( vector_float2(Float(maxX), Float(maxY)), faceBoundingBox, Int(imageSize.width), Int(imageSize.height))
        let correctedRect = CGRect(x: minPoint.x, y: minPoint.y, width: maxPoint.x - minPoint.x, height: maxPoint.y - minPoint.y)
        
        return correctedRect
    }
  
  /// Adjusts the orientation of the image based on its current orientation.
  ///
  /// This method is private and only accessible within the extension to ensure that it is only used internally.
  ///
  /// - Returns: The adjusted orientation that is the mirrored counterpart of the image's current orientation.
  private func adjustOrientation() -> UIImage.Orientation {
    switch self.imageOrientation {
    case .up:
      return .downMirrored
    case .upMirrored:
      return .up
    case .down:
      return .upMirrored
    case .downMirrored:
      return .down
    case .left:
      return .rightMirrored
    case .rightMirrored:
      return .left
    case .right:
      return .leftMirrored
    case .leftMirrored:
      return .right
    @unknown default:
      return self.imageOrientation
    }
  }
}
