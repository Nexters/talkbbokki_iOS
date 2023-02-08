//
//  API.Parameters.swift
//  talkbbokki
//
//  Created by USER on 2023/02/09.
//

import Foundation

extension API {
    enum Parameter {
        case map([String: Any?]?)
        case body(Encodable)
    }
}

extension API.Parameter {
    var params: [String : Any] {
        switch self {
        case .map(let dic):
            return dic?.compactMapValues{ $0 } ?? [:]
        case .body(let value):
            return value.toDictionary() ?? [:]
        }
    }
}

extension Decodable {
    static func decode<T: Decodable>(dictionary: [String: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: dictionary,
                                              options: [.fragmentsAllowed])
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension Encodable {
    func toDictionary(keyStrategy strategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys, options: JSONSerialization.ReadingOptions = [.allowFragments]) -> [String : Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = strategy
        
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: options)).flatMap { $0 as? [String:Any] }
    }
}

extension Data {
    func toDict() throws -> [String: Any]? {
        guard let dict = try JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        
        return dict
    }
    
    func parse<Element: Decodable>(keyStrategy strategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> Element {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = strategy
        return try decoder.decode(Element.self, from: self)
    }
}
