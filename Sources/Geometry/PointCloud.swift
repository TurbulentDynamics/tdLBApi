//
//  PointCloud.swift
//  MixedReality
//
//  Created by Evgeniy Upenik on 21.05.17.
//  Copyright © 2017 Evgeniy Upenik. All rights reserved.
//

import SceneKit


public enum PointCloudElementType: Int {
    case rotating = 0
    case fixed = 1
}



public struct PointCloudVertex {
    var i: Float, j: Float, k: Float
    var r: Float, g: Float, b: Float

    public init(i: Float, j: Float, k: Float, t: PointCloudElementType){
        self.i = i
        self.j = j
        self.k = k

        switch t {
        case .rotating:
            self.r = 0
            self.g = 0
            self.b = 0
        case .fixed:
            self.r = 1
            self.g = 1
            self.b = 1
        }
    }

    public init(i: Int, j: Int, k: Int, t: PointCloudElementType){
        self.init(i:Float(i), j:Float(j), k:Float(k), t:t)
    }

    public init(i: Double, j: Double, k: Double, t: PointCloudElementType){
        self.init(i:Float(i), j:Float(j), k:Float(k), t:t)
    }
}


public class PointCloud {

    var n: Int = 0
    var vertices: Array<PointCloudVertex> = []

    public func getNode() -> SCNNode {

        let node = buildNode(points: vertices)
        NSLog(String(describing: node))
        return node
    }

    public func getPointCloudFromFile(fileName: String) -> (Int, Int, Int) {

        self.n = 0
        var i, j, k: Double
        (i, j, k) = (0, 0, 0)

        var maxI: Int = 0
        var maxJ: Int = 0
        var maxK: Int = 0


        // Open file
        if let path = Bundle.main.path(forResource: fileName, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .ascii)
                var myStrings = data.components(separatedBy: "\n")

                // Read header
                while !myStrings.isEmpty {
                    let line = myStrings.removeFirst()
                    if line.hasPrefix("element vertex ") {
                        n = Int(line.components(separatedBy: " ")[2])!
                        continue
                    }
                    if line.hasPrefix("end_header") {
                        break
                    }
                }


                // Read data
                for d in 0...(self.n-1) {
                    let line = myStrings[d]
                    i = Double(line.components(separatedBy: " ")[0])!
                    j = Double(line.components(separatedBy: " ")[1])!
                    k = Double(line.components(separatedBy: " ")[2])!

                    if Int(i) > maxI {maxI = Int(i)}
                    if Int(j) > maxJ {maxJ = Int(j)}
                    if Int(k) > maxK {maxK = Int(k)}

                    let v = PointCloudVertex(i:i, j:j, k:k, t:.fixed)
                    vertices.append(v)

                }
                NSLog("Point cloud data loaded: %d points", n)
            } catch {
                print(error)
            }
        }
        return (maxI, maxJ, maxK)
    }




    public func buildNode(points: [PointCloudVertex]) -> SCNNode {
        let vertexData = NSData(
            bytes: points,
            length: MemoryLayout<PointCloudVertex>.size * points.count
        )
        let positionSource = SCNGeometrySource(
            data: vertexData as Data,
            semantic: SCNGeometrySource.Semantic.vertex,
            vectorCount: points.count,
            usesFloatComponents: true,
            componentsPerVector: 3,
            bytesPerComponent: MemoryLayout<Float>.size,
            dataOffset: 0,
            dataStride: MemoryLayout<PointCloudVertex>.size
        )
        let colorSource = SCNGeometrySource(
            data: vertexData as Data,
            semantic: SCNGeometrySource.Semantic.color,
            vectorCount: points.count,
            usesFloatComponents: true,
            componentsPerVector: 3,
            bytesPerComponent: MemoryLayout<Float>.size,
            dataOffset: MemoryLayout<Float>.size * 3,
            dataStride: MemoryLayout<PointCloudVertex>.size
        )
        let elements = SCNGeometryElement(
            data: nil,
            primitiveType: .point,
            primitiveCount: points.count,
            bytesPerIndex: MemoryLayout<Int>.size
        )
        let pointsGeometry = SCNGeometry(sources: [positionSource, colorSource], elements: [elements])

        return SCNNode(geometry: pointsGeometry)
    }
}