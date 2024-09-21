import Foundation
import NumberKit

// 2OgGZdF0XpQ7nuoC99CDxX

let alphabet: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
let base = BigInt(62)

let pow: [BigInt] = {
    var result: [BigInt] = []
    var a: BigInt = 1
    for i in 0..<22 {
        result.append(a)
        a *= base
    }
    return result
}()

let indexByAlphabet: [Character: Int] = {
    alphabet.enumerated().reduce(into: [Character: Int]()) { result, element in
        let (index, character) = element
        result[character] = index
    }
}()

enum Base62 {
}

extension Base62 {
    static func encode(uuid: UUID) -> String {
        let hex = uuid.serialized.hex.uppercased()
        return encode(hex: hex)!
    }
    
    static func encode(hex: String) -> String? {
        guard let bigInt = BigInt(from: hex, base: BigInt.hexBase) else {
            return nil
        }
        return encode(bigInt: bigInt)
    }
    
    static func encode(base10: String) -> String? {
        guard let bigInt = BigInt(from: base10) else {
            return nil
        }
        return encode(bigInt: bigInt)
    }
    
    static func encode(bigInt: BigInt) -> String {
        if bigInt == 0 {
            return "0"
        }
        var bytes: [Character] = []
        
        var num = bigInt
        while num > 0 {
            bytes.append(alphabet[Int(num % base)])
            num /= base
        }
        return String(bytes.reversed())
    }
}

extension Base62 {
    static func decodeToBigInt(_ base62: String) -> BigInt? {
        var result: BigInt = 0
        
        for (index, character) in base62.reversed().enumerated() {
            guard
                index < pow.count,
                let v = indexByAlphabet[character]
            else {
                return nil
            }
            let num = pow[index]
            let z = BigInt(v) * num
            result += z
        }
        return result
    }
    
    static func decodeToUUID(_ base62: String) -> UUID? {
        guard
            let num = decodeToBigInt(base62),
            let data = Data(hex: num.toString(base: BigInt.hexBase))
        else {
            return nil
        }
        
        return deserializeUUID(data)
    }
}
