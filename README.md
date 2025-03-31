# Hamorel
## 環境

- Language: Swift
- Version: 5.8
- Xcode: 14.3
- Framework: SwiftUI
- Architecture: MVVM　（必要ない部分はViewModelを省略）

### ライブラリ
- Firebase Analytics
- Firebase Appcheck
- Firebase Auth
- Firebase firestore

## API
- MusicKit

## 概要
MusicKit及びFirebaseを使用しています。
ユーザーのAppleMusicのライブラリを取得し、firestoreにアップロードします。
firestore上に部屋を作成し、部屋の中の複数ユーザーの音楽ライブラリから共通の曲を探索し、プレイリストを作成します。

## 使い方
実機での動作が必要です。AppleMusicに加入している必要があります。
初回起動時のみMusicライブラリへのアクセス許可と登録(メールアドレス、またはゲスト)が必要です。
ユーザーの一人がルームを作成を選択します。ルーム作成後、roomPinが表示されます。
他のユーザーはルームに参加を選択した後、roomPinを入力しルームに参加します。
ユーザーが全員ルームに入ったのち、プレイリストを作成を選択するとAppleMusicライブラリにプレイリストが追加されます。


