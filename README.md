# MouseShift AHK

Windows 11でタッチパッドとマウス／トラックボールを持ち替えると、ポインター設定を自動で切り替えるツールです。

**作者**：[@tanahata](https://x.com/tanahata)  
**ライセンス**：[MIT](LICENSE)

## ダウンロード

- **EXE版**：[MouseShift.exe](MouseShift.exe) — AutoHotkeyのインストール不要。Windows 64-bit用。
- **AHK版**：[MouseShift.ahk](MouseShift.ahk) — [AutoHotkey v2](https://www.autohotkey.com/) 2.0.31以降が必要。

どちらか一方をダウンロードしてください。GitHubのファイル画面では「Download raw file」から保存できます。

## 動作環境

- Windows 11 バージョン24H2以降（Surfaceで動作確認）
- Windows Precision Touchpadと、マウスとして認識される外付けマウス／トラックボール

## 使い方

1. ダウンロードした`MouseShift.exe`または`MouseShift.ahk`を書き込み可能なフォルダに保存し、ダブルクリックして起動します。
2. 初回の設定画面で、タッチパッドを操作して左側の「直前に操作したデバイスを登録」を押します。続いてマウスを操作して右側も登録します。
3. それぞれの速度・左右ボタン・ポインター精度・スクロール量・方向を設定し、「保存して適用」を押します。

以降はトレイに常駐し、最後に操作したデバイスに合わせて設定を切り替えます。設定画面はトレイアイコンから開けます。「Windows起動時に実行」は設定画面またはトレイメニューから切り替えられ、すぐに反映されます。

## 終了・更新

トレイメニューの「アプリを終了」から正常終了すると、起動前のWindows設定へ戻します。ウィンドウを閉じる・最小化するだけでは終了せず、トレイに格納されます。**強制終了時の設定復元は保証しません。**

設定は実行ファイルまたはスクリプトと同じフォルダの`MouseShift_AHK.ini`に保存されます。更新時は正常終了後に使用中の`.exe`または`.ahk`を置き換えてください。削除する場合は自動起動を先に解除してください。

EXE版にはAutoHotkeyの実行環境が含まれます。AutoHotkey本体の[ライセンス（GPL-2.0）とソースコード](https://github.com/AutoHotkey/AutoHotkey)は別途公開されています。すべてのWindows機種での動作を保証するものではありません。
