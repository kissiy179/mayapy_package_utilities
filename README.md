# mayapy_package_utilities
[maya_package_base](https://github.com/kissiy179/mayapy_package_base)を元にしたMaya用るpythonパッケージで使用するためのユーティリティを共通化しやすいように切り出したもの  
Mayaは予めインストールされている必要アリ

## 使い方
1. [maya_package_base](https://github.com/kissiy179/mayapy_package_base)を元にしたパッケージからサブモジュール**util**として登録する
1. ダウンロードされたら**setup.bat**を実行する
    1. 親パッケージの依存パッケージがインストールされる
    1. setup.pyが親パッケージにコピーされる
    1. このユーティリティを更新する度にsetup.pyを親パッケージにコピーするgithookが登録される
1. maya.bat/maya_en.bat/maya_jp.batもしくはmaya.batに言語(en or jp)/バージョンを指定したmata.batのショートカットを実行することで親パッケージの環境設定を適用したMayaが起動する

## ファイル
| ファイル名 | 概要 |
| ---- | ---- |
| setup.py | 親リポジトリの依存パッケージを解決するためのPythonスクリプト<br>setup.batから呼び出してこのパッケージ用の環境を設定するほか、親リポジトリをpip install可能なパッケージにするために親階層にコピーして使用する |
| setup.bat | インストールされているMayaを検索し、mayapyを使用してpip installで依存パッケージをインストールする<br>またsetup.pyの親階層へのコピーも行う |
| copy_setup_py.bat | setup.pyを親パッケージにコピーする<br>setup.bat、post-mergeフックから呼ばれる |
| link_githooks.bat | parent_githooks内のgithookテンプレートを親リポジトリにシンボリックリンク接続する<br>setup.bat、post-mergeフックから呼ばれる |
| maya.bat | インストールされているMayaを検索しこのパッケージへのパスを通して起動する<br>UI言語、Mayaバージョンを指定できる |
| maya_en/jp.bat | インストールされているMayaを検索しこのパッケージへのパスを通して起動する<br>en=英語/jp=日本語UI指定 |
