//
//  ViewController.swift
//  AssetManager
//
//  Created by 정다연 on 8/26/24.
//

import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    private var stockPrices: [StockPriceOutput2] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchStockData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
    }
    
    private func fetchStockData() {
        Task {
            do {
                let prices = try await NetworkManager.shared.getOverseasStockPrice(
                    exchangeCode: "NAS", // NASDAQ
                    stockCode: "SHY"     // SHY 종목코드
                )
                stockPrices = prices ?? []
                print("✅ 해외주식 시세 조회 성공: \(stockPrices.count)개 데이터")
                
                await MainActor.run {
                    tableView.reloadData()
                }
            } catch {
                print("❌ 주식 데이터 조회 실패: \(error)")
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockPrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let price = stockPrices[indexPath.row]
        cell.textLabel?.text = "날짜: \(price.xymd ?? ""), 종가: \(price.clos ?? "")"
        return cell
    }
}

