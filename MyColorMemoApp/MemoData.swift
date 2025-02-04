//
//  MemoData.swift
//  MyColorMemoApp
//
//  Created by 大塚大樹 on 2025/02/04.
//

import Foundation
import RealmSwift
// メモモデル(セルに表示するデータ)を定義
class MemoDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString // データを一意に識別するための識別子
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()
}
