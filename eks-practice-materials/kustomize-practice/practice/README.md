# kustomize 化してみよう
これは kustomize 練習用のディレクトリです。

## 現在の状態
以下のように分けて manifests を管理している状況です。  
```
./manifests/
├── dev
│   ├── deployment.yaml
│   ├── ingress.yaml
│   └── service.yaml
└── prod
    ├── deployment.yaml
    ├── ingress.yaml
    └── service.yaml
```
課題は、同じような内容なのにそれぞれ別々で管理しているので不要な際が出てしまう可能性があることです。これを解消していきましょう。


##  dev と prod の違いを把握する
dev と prod それぞれの manifest ファイルを比較して違いを把握しましょう。  
差分がちらほら出てきますが、逆に言うとその差分以外は共通ということが言えます。


比較するコマンドの例
```
diff -u ./manifests/dev ./manifests/prod
```

```diff
❯ diff -u ./manifests/dev ./manifests/prod
diff -u ./manifests/dev/deployment.yaml ./manifests/prod/deployment.yaml
--- ./manifests/dev/deployment.yaml     2024-04-27 10:54:42
+++ ./manifests/prod/deployment.yaml    2024-04-27 10:55:41
@@ -6,7 +6,7 @@
   labels:
     app: webapp
 spec:
-  replicas: 1
+  replicas: 2
   selector:
     matchLabels:
       app: webapp
@@ -17,8 +17,8 @@
     spec:
       containers:
       - name: my-nginx
-        image: my-nginx:v1.0.0
-        imagePullPolicy: Never
+        image: 123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-nginx:v1.0.0
+        imagePullPolicy: Always
         ports:
         - containerPort: 80
       restartPolicy: Always
diff -u ./manifests/dev/ingress.yaml ./manifests/prod/ingress.yaml
--- ./manifests/dev/ingress.yaml        2024-04-27 10:57:09
+++ ./manifests/prod/ingress.yaml       2024-04-27 10:55:01
@@ -3,10 +3,13 @@
 metadata:
   name: web-lb
   namespace: kustomize-practice
+  annotations:
+    alb.ingress.kubernetes.io/scheme: internet-facing
+    alb.ingress.kubernetes.io/target-type: ip
   labels:
     app: webapp
 spec:
-  ingressClassName: nginx
+  ingressClassName: alb
   rules:
     - http:
         paths:
```
このように差分をみることで、ほとんどの内容が同じことと一部だけが異なることが把握出来ました。


## チャレンジ！
Kustomize を活用して manifests ファイルをリファクタリングしてみてください。

ヒントは以下の流れです。

1. dev をコピーして base を作る
2. base から dev を作成できるようにする ( ヒント: `touch ./manifests/dev/kustomization.yaml` )
3. base から prod を作成できるようにする
4. prod の場合、base を上書きするようにする（ ヒント: [patches \| SIG CLI](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patches/)) ）


## 最終的な構成
[こちら](../practice-answer/) に例があります。

