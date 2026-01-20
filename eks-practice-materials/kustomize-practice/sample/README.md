# 環境ごとの manifest 管理(kustomize)
## 構成

```
./manifests
├── base                         # base: 環境共通の manifest を配置
│   ├── deployment.yaml
│   ├── ingress.yaml
│   ├── kustomization.yaml
│   └── service.yaml
└── overlays
    ├── development              # development: 開発環境用の manifest
    │   ├── ingress.yaml
    │   └── kustomization.yaml
    └── production               # production: 本番環境用の manifest
        ├── deployment.yaml
        ├── ingress.yaml
        └── kustomization.yaml
```

## manifests ファイルの生成方法
### 開発環境の manifest を生成
```
kubectl kustomize ./manifests/overlays/development
```

### 本番環境の manifest を生成
```
kubectl kustomize ./manifests/overlays/production
```

### 開発環境の manifest と本番環境の manifest を比較
```sh
diff -u <(kubectl kustomize ./manifests/overlays/development) <(kubectl kustomize ./manifests/overlays/production)
```


## kustomize で生成される manifests を適用
### kustomize で作成される開発環境のmanifestを適用
```
kubectl apply -k ./manifests/overlays/development
```

### kustomize で作成される本番環境のmanifestを適用
```
kubectl apply -k ./manifests/overlays/production
```

