# Github Action for Kubernetes CLI

Essa Action disponibiliza o comando `kubectl` para Github Actions.


> Você deve usar uma versão kubectl que esteja dentro de uma pequena diferença de versão do cluster control plane do Amazon EKS. Por exemplo, um cliente 1.26 kubectl funciona com clusters Kubernetes 1.25, 1.26 e 1.27.

## Uso

`.github/workflows/push.yml`

```yaml
on: push
name: deploy
jobs:
  deploy:
    name: deploy to cluster
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Install kubectl
        uses: qgx-pagamentos/aws-eks-kubectl-set@v1
        with:
          base64-kube-config: ${{ secrets.KUBE_CONFIG_DATA }}
          kubectl-version: 1.28.1
          aws-iam-auth-version: 0.6.11

      - name: Deploy Kubernetes cluster Service/Deployment
        run: |
          kubectl version
          kubectl apply -f deployment/kubernetes
```

## Secrets

`KUBE_CONFIG_DATA` – **requerido**: Um arquivo kubeconfig base64-encoded com as credenciais necessárias para o K8s acessar o cluster.
Exemplo de como gerar o arquivo base64-encoded:
```bash
cat $HOME/.kube/config | base64
```
[Inspiration](https://github.com/kodermax/kubectl-aws-eks)