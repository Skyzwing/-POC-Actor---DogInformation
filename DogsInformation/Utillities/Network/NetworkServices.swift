//
//  NetworkServices.swift
//  DogsInformation
//
//  Created by Surachet Yaitammasan on 16/1/24.
//

import Foundation

actor NetworkService {
	private let baseNetworkService: BaseNetworkService
	
	init(baseNetworkService: BaseNetworkService) {
		self.baseNetworkService = baseNetworkService
	}
	
	func request<T: EndpointType, U: Decodable>(_ endpoint: T) async throws -> Result<U?, NetworkError> {
		do {
			let (data, response) = try await performDataTask(endpoint)
			try baseNetworkService.validateResponse(response)
			
			let decoder = JSONDecoder()
			let object = try decoder.decode(U.self, from: data)
			return .success(object)
		} catch let error as NetworkError {
			handleNetworkError(error)
			return .failure(error)
		} catch {
			handleUnexpectedError(error)
			return .failure(.unknow)
		}
	}
	
	private func performDataTask<T: EndpointType>(_ endpoint: T) async throws -> (Data, URLResponse) {
		let request = baseNetworkService.buildRequest(endpoint)
		return try await baseNetworkService.dataTask(with: request)
	}
	
	private func handleNetworkError(_ error: NetworkError) {
		switch error {
		case .invalidURL:
			print("Invalid URL error")
		case .networkError(let underlyingError):
			print("Network error: \(underlyingError)")
		case .invalidResponse:
			print("Invalid response error")
		case .decodingError(let decodingError):
			print("Decoding error: \(decodingError)")
		case .serverError(let statusCode, let message):
			print("Server error (\(statusCode)): \(message)")
		case .unknow:
			print("Unknow error")
		}
	}
	
	private func handleUnexpectedError(_ error: Error) {
		print("Unexpected error: \(error)")
	}
}

