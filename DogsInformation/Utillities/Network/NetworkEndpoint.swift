//
//  NetworkRouter.swift
//  DogsInformation
//
//  Created by Surachet Yaitammasan on 15/1/24.
//

import Foundation

protocol EndpointType {
	var baseUrl: String { get }
	var endpoint: String { get }
	var method: HTTPMethod { get }
	var task: HTTPTask { get }
	var headers: [String: String] { get }
	var parameters: [String: Any] { get }
	var body: [String: String]? { get }
}

enum Endpoint {
	case dogs(page: Int, limit: Int)
}

extension Endpoint: EndpointType {
	var baseUrl: String {
		return APIConfig.baseURL
	}

	var endpoint: String {
		switch self {
		case .dogs:
			return "breeds"
		}
	}

	var method: HTTPMethod {
		switch self {
		case .dogs:
			return .get
		}
	}
	
	var task: HTTPTask {
		switch self {
		case .dogs:
			return .requestWithParameters(parameters: parameters)
		}
	}

	var headers: [String : String] {
		return ["x-api-key": APIConfig.apiKey]
	}

	var parameters: [String : Any] {
		switch self {
		case .dogs(let page, let limit):
			return ["page": page, "limit": limit]
		}
	}

	var body: [String: String]? {
		return nil
	}
}

