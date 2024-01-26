//
//  ViewController.swift
//  DogsInformation
//
//  Created by Surachet Yaitammasan on 15/1/24.
//

import UIKit

// DogView protocol
protocol DogView: AnyObject {
	func updateTableView()
}

class ViewController: UIViewController {

	@IBOutlet weak var dogsTableView: UITableView!
	
	var viewModel: MainViewModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	private func setup() {
		configurationTableView()
		configurationViewModel()
		viewModel?.fetchDog()
	}
	
	private func configurationViewModel() {
		viewModel = MainViewModel()
		viewModel?.delegate = self
	}
	
	private func configurationTableView() {
		let nib = UINib(nibName: "DogTableViewCell", bundle: nil)
		dogsTableView.dataSource = self
		dogsTableView.delegate = self
		dogsTableView.register(nib, forCellReuseIdentifier: "DogTableViewCell")
	}
}

extension ViewController: DogView {
	func updateTableView() {
		DispatchQueue.main.async {
			self.dogsTableView.reloadData()
		}
	}
}

extension ViewController: DogViewModelDelegate {
	func didFetchDogs() {
		updateTableView()
	}
	
	func didFailFetchingDogs(error: Error) {
		print("Error is \(error.localizedDescription)")
	}
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel?.dogs.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "DogTableViewCell", 
													   for: indexPath) as? DogTableViewCell else {
			return UITableViewCell()
		}
		guard let dog = viewModel?.dog(at: indexPath.row) else { return UITableViewCell() }
		cell.config(with: dog)
		return cell
	}
}

//MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {}
