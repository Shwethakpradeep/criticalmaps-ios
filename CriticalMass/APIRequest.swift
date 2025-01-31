import Foundation

protocol APIRequestDefining {
    associatedtype ResponseDataType: Decodable
    var endpoint: Endpoint { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    func makeRequest() -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}

extension APIRequestDefining {
    func makeRequest() -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = httpMethod.rawValue
        request.addHeaders(headers)
        return request
    }

    func parseResponse(data: Data) throws -> ResponseDataType {
        return try data.decoded()
    }
}

private extension URLRequest {
    mutating func addHeaders(_ httpHeaders: HTTPHeaders?) {
        guard let headers = httpHeaders else {
            return
        }
        for header in headers {
            addValue(header.key, forHTTPHeaderField: header.value)
        }
    }
}
