//
//  MainViewModel.swift
//  DogsInformation
//
//  Created by Surachet Yaitammasan on 15/1/24.
//

import Foundation

// DogViewModel protocol
protocol DogViewModelDelegate: AnyObject {
	func didFetchDogs()
	func didFailFetchingDogs(error: Error)
}

protocol DogViewModel: AnyObject {
	var delegate: DogViewModelDelegate? { get set }
	var dogs: [DogsModel] { get }
	var numberOfDogs: Int { get }
	
	func fetchDog()
	func dog(at index: Int) -> DogsModel
}


class MainViewModel: DogViewModel {
	
	var delegate: DogViewModelDelegate?
	
	private let networkService: NetworkService
	
	var dogs: [DogsModel] = []
	
	var numberOfDogs: Int {
		return dogs.count
	}
	
	init(networkService: NetworkService) {
		self.networkService = networkService
	}
	
	convenience init() {
		self.init(networkService: NetworkService(baseNetworkService: BaseNetworkService()))
	}
	
	func dog(at index: Int) -> DogsModel {
		dogs[index]
	}
	
	func fetchDog() {
		Task {
			do {
				let endpoint = Endpoint.dogs(page: 1, limit: 10)
				let result: Result<[DogsEntityElement]?, NetworkError> = try await networkService.request(endpoint)
				handleFetchResult(result)
			} catch {
				delegate?.didFailFetchingDogs(error: error)
			}
		}
	}
	
	private func handleFetchResult(_ result: Result<[DogsEntityElement]?, NetworkError>) {
		switch result {
		case .success(let data):
			guard let data = data else { return }
			dogs = data.map { DogsModel(id: $0.id, name: $0.name, origin: $0.origin)}
			delegate?.didFetchDogs()
		case .failure(let error):
			delegate?.didFailFetchingDogs(error: error)
		}
	}
}
