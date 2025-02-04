//
//  MemoDetailView.swift
//  MyColorMemoApp
//
//  Created by 大塚大樹 on 2025/02/04.
//

import Foundation
import UIKit
import RealmSwift

class MemoDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    let memoData = MemoDataModel()
    
    var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }
    
    override func viewDidLoad() {
        displayData()
        setDoneButton()
        textView.delegate = self
    }
    // ホームビューから送られてきたデータをプロパティに保存
    func configure(memo: MemoDataModel) {
        memoData.text = memo.text
        memoData.recordDate = memo.recordDate
    }
    // プロパティに保存されているテキストをテキストビューに表示
    func displayData() {
        textView.text = memoData.text
        navigationItem.title = dateFormat.string(from: memoData.recordDate)
    }
    
    // キーボードを閉じる処理
    @objc func tapDoneButton() {
        view.endEditing(true)
    }
    // キーボードに閉じるボタンを生成
    func setDoneButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        toolBar.items = [commitButton]
        textView.inputAccessoryView = toolBar
    }
    // メモをレルムに保存
    func saveData(with text: String) {
        let realm = try! Realm()
        try! realm.write {
            memoData.text = text
            memoData.recordDate = Date()
            realm.add(memoData)
        }
        print("text:\(memoData.text),recordDate\(memoData.recordDate)")
    }
}
// テキストビューが変更される度にレルムに保存する
extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let updateText = textView.text ?? ""
        saveData(with: updateText)
    }
}
