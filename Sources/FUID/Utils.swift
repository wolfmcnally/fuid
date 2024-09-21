import Foundation

func deserializeUUID(_ data: Data) -> UUID? {
    guard data.count >= MemoryLayout<uuid_t>.size else {
        return nil
    }
    
    return Data(data).withUnsafeBytes {
        UUID(uuid: $0.bindMemory(to: uuid_t.self).baseAddress!.pointee)
    }
}

extension UUID {
    var serialized: Data {
        withUnsafeBytes(of: uuid) { p in
            Data(p.bindMemory(to: UInt8.self))
        }
    }
}


extension Data {
    init?<S>(hex: S) where S: StringProtocol {
        guard let data = toData(hex: hex) else {
            return nil
        }
        self = data
    }
    
    var hex: String {
        toHex(data: self)
    }
}

func toHex(data: Data) -> String {
    data.reduce(into: "") {
        $0 += toHex(byte: $1)
    }
}

func toHex(byte: UInt8) -> String {
    String(format: "%02x", byte)
}

func toData<S>(hex: S) -> Data? where S: StringProtocol {
    guard hex.count & 1 == 0 else {
        return nil
    }
    let len = hex.count / 2
    var result = Data(capacity: len)
    for i in 0..<len {
        let j = hex.index(hex.startIndex, offsetBy: i*2)
        let k = hex.index(j, offsetBy: 2)
        let hexByte = hex[j..<k]
        if var num = toByte(hex: hexByte) {
            result.append(&num, count: 1)
        } else {
            return nil
        }
    }
    return result
}

func toByte<S>(hex: S) -> UInt8? where S: StringProtocol {
    guard hex.count == 2 else {
        return nil
    }
    return UInt8(hex, radix: 16)
}
