//
//  NetworkService.swift
//  DogsInformation
//
//  Created by Surachet Yaitammasan on 16/1/24.
//

import Foundation

class BaseNetworkService {
	let session: URLSession
	
	init() {
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = 30
		session = URLSession(configuration: configuration)
	}
	
	func buildRequest<T: EndpointType>(_ endpoint: T) -> URLRequest {
		let url = URL(string: endpoint.baseUrl + endpoint.endpoint)!
		var request = URLRequest(url: url)
		request.httpMethod = endpoint.method.rawValue
		request.allHTTPHeaderFields = endpoint.headers
		
		switch endpoint.task {
		case .plain:
			break
		case .requestWithParameters(let parameters):
			request = configureParameters(request: request, parameters: parameters)
		case .requestWithBody(let body):
			request = configureBody(request: request, body: body)
		}
		
		return request
	}
	
	private func configureParameters(request: URLRequest, parameters: [String: Any]) -> URLRequest {
		var requestWithParameters = request
		if let url = requestWithParameters.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
			components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
			requestWithParameters.url = components.url
		}
		return requestWithParameters
	}
	
	private func configureBody(request: URLRequest, body: String) -> URLRequest {
		var requestWithBody = request
		requestWithBody.httpBody = body.data(using: .utf8)
		return requestWithBody
	}
	
	func dataTask(with request: URLRequest) async throws -> (Data, URLResponse) {
		do {
			let (data, response) = try await session.data(for: request)
			return (data, response)
		} catch {
			throw NetworkError.networkError(error)
		}
	}
	
	func validateResponse(_ response: URLResponse) throws {
		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkError.invalidResponse
		}
		
		if !(200..<300).contains(httpResponse.statusCode) {
			let data = try? Data(contentsOf: response.url ?? URL(fileURLWithPath: ""))
			let message = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown Error"
			throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: message)
		}
	}
}
