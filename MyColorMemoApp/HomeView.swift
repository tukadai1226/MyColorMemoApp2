//
//  HomeView.swift
//  MyColorMemoApp
//
//  Created by 大塚大樹 on 2025/02/03.
//

import Foundation
import UIKit // UIに関するクラスが格納されたモジュール
import RealmSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    // メモモデルを設定
    var memoDataList: [MemoDataModel] = []
    let themeColorTypekey = "themeColorTypekey"
    
    override func viewDidLoad() {
        print("HomeViewController")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() // 空のViewを配置
        setNavigationBarButton()
        setLeftNavigationBarButton()
        // ユーザーデフォルトから色データを取得
        let themeColorTypeInt = UserDefaults.standard.integer(forKey: themeColorTypekey)
        let themoColorType = MyColerType(rawValue: themeColorTypeInt) ?? .default
        setThemeColor(type: .default)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setMemoData()
        tableView.reloadData()
    }
    
    // レルムからメモデータを取得
    func setMemoData() {
        let realm = try! Realm()
        let result = realm.objects(MemoDataModel.self)
        memoDataList = Array(result)
    }
    
    @objc func tapAddButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboard.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    
    func setNavigationBarButton() {
        let buttonActionSelector: Selector = #selector(tapAddButton)
        let rightBarButoon = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelector)
        navigationItem.rightBarButtonItem = rightBarButoon
    }
    // カラーアイコンのセット
    func setLeftNavigationBarButton() {
        let buttonActionSelctor: Selector = #selector(didTapColorSettingButton)
        let leftButtonImage = UIImage(named: "colorSttingIcon")
        let leftButoon = UIBarButtonItem(image: leftButtonImage, style: .plain, target: self, action: buttonActionSelctor)
        navigationItem.leftBarButtonItem = leftButoon
    }
    
    @objc func didTapColorSettingButton() {
        let defaultAction = UIAlertAction(title: "デフォルト", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .default)
        })
        let orangeAction = UIAlertAction(title: "オレンジ", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .orange)
        })
        let redAction = UIAlertAction(title: "レッド", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .red)
        })
        let blueAction = UIAlertAction(title: "ブルー", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .blue)
        })
        let greenAction = UIAlertAction(title: "グリーン", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .green)
        })
        let pinkAction = UIAlertAction(title: "ピンク", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .pink)
        })
        let purpleAction = UIAlertAction(title: "パープル", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .purple)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "テーマカラーを選択して下さい", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(defaultAction)
        alert.addAction(orangeAction)
        alert.addAction(redAction)
        alert.addAction(blueAction)
        alert.addAction(greenAction)
        alert.addAction(pinkAction)
        alert.addAction(purpleAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // へったーの色を変更する
    func setThemeColor(type: MyColerType) {
        // navigationControllerクラスのnavigationBar.barTintColorに色を代入する
        guard let navigationBar = navigationController?.navigationBar else {
            print("NavigationControllerが存在しません")
            return
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = type.color
        // 指定されたナビゲーションの色がデフォルトかどうかを判別する
        let isDefault = type == .default
        // 指定された色がデフォルトだった場合は黒、デフォルト以外は白を代入する
        let tintColor: UIColor = isDefault ? .black : .white
        // ボタンの色を代入する
        navigationController?.navigationBar.tintColor = tintColor
        // ナビゲーションバーのタイトルの色もイメージカラーと同じ色にする
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: tintColor] // Dictionary型[Key: Value]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        print("color:\(type)")
        saveThemeColor(type: type)
    }
    // ユーザーデフォルトに値を保存
    func saveThemeColor(type: MyColerType) {
        UserDefaults.standard.setValue(type.rawValue, forKey: themeColorTypekey)
    }
}
// UITableViewDataSource:テーブルビューを作成
extension HomeViewController: UITableViewDataSource {
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataList.count
    }
    // セルの中身を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell") // reuseIdentifier:cellの識別子で作られたセルを再利用する
        let memoDataModel = memoDataList[indexPath.row] // Cellの(0から始まる)通り番号が順番に渡される(0から順番にアクセス)
        cell.textLabel?.text = memoDataModel.text
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
        return cell
    }
}
// UITableViewDelegate:テーブルビューを操作した際の挙動を指定
extension HomeViewController: UITableViewDelegate {
    // セルがタップされた際に、インデックス番号が渡される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboad = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboad.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        let memoData = memoDataList[indexPath.row]
        memoDetailViewController.configure(memo: memoData)
        tableView.deselectRow(at: indexPath, animated: true) // 選択状態をを解除
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    // テーブルビューが横須ワイプされた時に実行する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let targetMemo = memoDataList[indexPath.row]
        // レルムのメモデータを削除
        let realm = try! Realm()
        try! realm.write {
            realm.delete(targetMemo)
        }
        // プロパティからメモデータを削除
        memoDataList.remove(at: indexPath.row)
        // セルの削除
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
