//
//  ProfanityFilter.swift
//  GoshDarnIt
//
//  Created by Ryan Maxwell on 27/09/16.
//  Copyright © 2016 Cactuslab. All rights reserved.
//

import Foundation

class ProfanityResources {
    
    class func getFilterFilesURLS() -> [URL]? {
        let fm = FileManager.default
        let path = Bundle(for: ProfanityResources.self).resourcePath!
        
        var urls = [URL]()
        
        do {
            let fileNames = try fm.contentsOfDirectory(atPath: path)
            
            
            for fileName in fileNames {
                let token = fileName.components(separatedBy: ".")
                let fileNameWithoutExtension = token[0]
                
                guard let url = Bundle(for: ProfanityResources.self).url(forResource: fileNameWithoutExtension, withExtension: "json")
                    else { continue }
                
                urls.append(url)
            }
            
            return urls
        } catch {
            return []
        }
    }
}

struct ProfanityDictionary {
    
    static let profaneWords: Set<String> = {
        
        guard let fileURLS = ProfanityResources.getFilterFilesURLS()
            else { return Set<String>() }
        
        var wordStrings = [String]()
        
        for url in fileURLS {
            do {
                let fileData = try Data(contentsOf: url, options: NSData.ReadingOptions.uncached)
                
                guard let words = try JSONSerialization.jsonObject(with: fileData, options: []) as? [String] else {
                    return Set<String>()
                }
                
                wordStrings.append(contentsOf: words)
                
            } catch {
                return Set<String>()
            }
        }
        
        return Set(wordStrings)
    }()
}

public struct ProfanityFilter {
    
    static func censorString(_ string: String) -> String {
        var cleanString = string
        
        for word in string.profaneWords() {
            
            let cleanWord = "".padding(toLength: word.characters.count, withPad: "*", startingAt: 0)
            
            cleanString = cleanString.replacingOccurrences(of: word, with: cleanWord, options: [.caseInsensitive], range: nil)
        }
        
        return cleanString
    }
}

public extension String {
    
    public func profaneWords() -> Set<String> {
        
        var delimiterSet = CharacterSet()
        delimiterSet.formUnion(CharacterSet.punctuationCharacters)
        delimiterSet.formUnion(CharacterSet.whitespacesAndNewlines)
        
        let words = Set(self.lowercased().components(separatedBy: delimiterSet))
        
        return words.intersection(ProfanityDictionary.profaneWords)
    }
    
    public func containsProfanity() -> Bool {
        return !profaneWords().isEmpty
    }
    
    public func censored() -> String {
        return ProfanityFilter.censorString(self)
    }
    
    public mutating func censor() {
        self = censored()
    }
}

public extension NSString {
    
    public func censored() -> NSString {
        return ProfanityFilter.censorString(self as String) as NSString
    }
}

public extension NSMutableString {
    
    public func censor() {
        setString(ProfanityFilter.censorString(self as String))
    }
}

public extension NSAttributedString {
    
    public func censored() -> NSAttributedString {
        
        let profaneWords = string.profaneWords()
        
        if profaneWords.isEmpty {
            return self
        }
        
        let cleanString = NSMutableAttributedString(attributedString: self)
        
        for word in profaneWords {
            
            let cleanWord = "".padding(toLength: word.characters.count, withPad: "*", startingAt: 0)
            
            var range = (cleanString.string as NSString).range(of: word, options: .caseInsensitive)
            while range.location != NSNotFound {
                let attributes = cleanString.attributes(at: range.location, effectiveRange: nil)
                let cleanAttributedString = NSAttributedString(string: cleanWord, attributes: attributes)
                cleanString.replaceCharacters(in: range, with: cleanAttributedString)
                
                range = (cleanString.string as NSString).range(of: word, options: .caseInsensitive)
            }
        }
        
        return cleanString
    }
}
