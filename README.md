# mayapy_package_utilities
Mayaで使用するpythonパッケージでサブモジュールとして使用するためのユーティリティ  
親パッケージは[maya_package_base](https://github.com/kissiy179/mayapy_package_base)を元にする前提

| ファイル名 | 概要 |
| ---- | ---- |
| setup.py | 親リポジトリの依存パッケージを解決するためのPythonスクリプト<br>setup.batから呼び出してこのパッケージ用の環境を設定するほか、親リポジトリをpip install可能なパッケージにするために親階層にコピーして使用する |
| setup.bat | インストールされているMayaを検索し、mayapyを使用してpip installで依存パッケージをインストールする<br>またsetup.pyの親階層へのコピーも行う |
| copy_setup_py.bat | setup.pyを親パッケージにコピーする<br>setup.bat、post-mergeフックから呼ばれる |
| link_githooks.bat | parent_githooks内のgithookテンプレートを親リポジトリにシンボリックリンク接続する<br>setup.bat、post-mergeフックから呼ばれる |
| maya.bat | インストールされているMayaを検索しこのパッケージへのパスを通して起動する<br>UI言語、Mayaバージョンを指定できる |
| maya_en/jp.bat | インストールされているMayaを検索しこのパッケージへのパスを通して起動する<br>en=英語/jp=日本語UI指定 |
