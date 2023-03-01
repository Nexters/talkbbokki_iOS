//
//  FileUtil.swift
//  talkbbokki
//
//  Created by USER on 2023/02/28.
//

import Foundation

private enum Path {
    static let downloadedContentsFolderName = "TempStore"
}

final class FileUtil {
    static let shared = FileUtil()
    private let libraryDirectory: String? = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
    lazy var rootDirectory: String? = {
        return libraryDirectory?.appending("/"+Path.downloadedContentsFolderName)
    }()
    
    func makePath(name: String) -> String? {
        rootDirectory?.appending("/"+name)
    }
    
    func makeFilePath(_ path: String) -> URL {
        URL(fileURLWithPath: path+".png")
    }
    
    @discardableResult
    func createDirectory(path: String) -> Bool {
        guard FileManager.default.fileExists(atPath: path) == false else {
            return true
        }
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
}
