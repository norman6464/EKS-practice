# シンプルな Web Server
このリポジトリは、EKS (Elastic Kubernetes Service) 上でシンプルな Web サーバーをデプロイするためのサンプル構成です。

## 構成内容

```
.
├── README.md
├── eks-cluster.yaml            # EKS クラスターの設定ファイル
├── manifests                   # Kubernetes の manifest ファイルを格納
│   ├── deployment.yaml         # Web サーバーの Deployment を定義
│   ├── ingress.yaml            # Ingress リソースを定義（必要に応じて使用）
│   └── service.yaml            # Web サーバー用の Service を定義
└── webserver                   # Web サーバーの構成に関するファイルを格納
    ├── README.md
    └── docker                  # Docker 関連のファイル
        ├── Dockerfile          # Nginx ベースのイメージをビルド
        ├── conf.d
        │   └── default.conf    # Nginx の設定ファイル
        └── html
            └── index.html      # デフォルトの HTML ファイル
```

## 起動
### EKS クラスターを作成
`eks-cluster.yaml` を使用して、EKS クラスターを作成します。
```sh
eksctl create cluster -f ./eks-cluster.yaml
```

### Namespace を作成
Web アプリケーション用の Namespace を作成します。
```sh
kubectl create namespace simple-web
```

### マニフェストを適用
`manifests` ディレクトリ内のマニフェストを適用して、Web サーバーをデプロイします。
```sh
kubectl apply -f ./manifests
```


## 停止
### EKS クラスターを削除
作成した EKS クラスターを削除して、リソースを解放します。
```sh
eksctl delete cluster -f ./eks-cluster.yaml
```

