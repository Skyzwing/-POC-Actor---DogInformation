//
//  NetworkErrorEntity.swift
//  DogsInformation
//
//  Created by Surachet Yaitammasan on 15/1/24.
//

import Foundation

// APIError enum
enum NetworkError: Error {
	case invalidURL
	case networkError(Error)
	case invalidResponse
	case decodingError(Error)
	case serverError(statusCode: Int, message: String)
	case unknow
}
