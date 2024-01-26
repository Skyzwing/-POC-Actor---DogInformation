//
//  HTTPTask.swift
//  DogsInformation
//
//  Created by Surachet Yaitammasan on 16/1/24.
//

import Foundation

enum HTTPTask {
	case plain
	case requestWithParameters(parameters: [String: Any])
	case requestWithBody(body: String)
}
