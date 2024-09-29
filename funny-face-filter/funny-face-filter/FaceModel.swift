//
//  FaceModel.swift
//  funny-face-filter
//
//  Created by Peter Grapentien on 9/29/24.
//

import Foundation
import Vision

class FaceModel {
    var boundingBox: CGRect = CGRect()
    var leftEyeRect: CGRect = CGRect()
    var rightEyeRect: CGRect = CGRect()
    var observation: VNFaceObservation = VNFaceObservation()
}
