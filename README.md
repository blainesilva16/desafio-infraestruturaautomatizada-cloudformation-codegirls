# 🚀 Infraestrutura Automatizada com AWS CloudFormation

Este projeto tem como objetivo **implementar uma infraestrutura automatizada na AWS** utilizando **AWS CloudFormation**, permitindo criar e gerenciar recursos como roles do IAM e buckets S3 de forma declarativa e versionada.

---

## 🧩 1. Pré-requisitos

Antes de começar, verifique se você possui:

- 🟢 **Conta AWS ativa**
- 🟢 **AWS CLI configurada** com um perfil válido (`aws configure --profile dev`)
- 🟢 **Chaves de acesso IAM (Access Key e Secret Key)** salvas localmente
- 🟢 **Python 3.8+ instalado**
- 🟢 **cfn-lint** para validação de templates CloudFormation  

Instale o `cfn-lint` com:

```bash
pip install cfn-lint
```

Se o comando cfn-lint não for encontrado, use:

```bash
python -m cfn_lint templates/main.yaml
```

O cfn-lint (abreviação de CloudFormation Linter) é uma ferramenta de validação automática dos templates do AWS CloudFormation. 
Ele analisa seu arquivo YAML/JSON (como main.yaml) e verifica se a estrutura, os recursos e as propriedades estão corretos de acordo com as regras oficiais da AWS.

Crie um usuário IAM para utilizar no console (AWS CLI configurada), gere uma access key e rode os comandos abaixo para validar seu usuário:

```bash
aws configure
```

```bash
AWS Access Key ID [****************ABCD]: <sua nova access key>
AWS Secret Access Key [None]: <sua nova secret key>
Default region name [us-east-1]: <sua região, ex: sa-east-1>
Default output format [json]: 
```

Caso você use mais de um perfil, execute:

```bash
aws configure --profile dev
```

para configurar o perfil e depois confira com:

```bash
aws sts get-caller-identity --profile dev
```

Estrutura do repositório:

desafio-infraestruturaautomatizada-cloudformation-codegirls/                      # raiz do repositório
├── README.md
├── templates/                  # CloudFormation templates (YAML/JSON)
│   ├── main.yaml
├── scripts/                    # scripts de deploy/teste
│   └── deploy.sh
├── ci/                         # pipelines (GitHub Actions / CodeBuild)
│   └── github-actions.yml
└── comandos-cli.sh             # comandos usados

## 🧱 2. Template CloudFormation (main.yaml)

O arquivo principal templates/main.yaml define os recursos da infraestrutura.

O que esse template faz:
- Cria um bucket S3 com nome único e seguro.
- Cria uma Lambda Function simples em Python 3.12.
- Cria uma IAM Role apenas para a Lambda, com permissões mínimas (CloudWatch Logs + acesso ao S3).
- Usa parâmetros para ambiente (dev, staging, etc.), permitindo reutilização.
- Está 100% compatível com o comando aws cloudformation deploy.

## 📦 3. Empacotando e Implantando com a AWS CLI

Antes de implantar, você deve empacotar os artefatos (caso existam Lambdas, templates aninhados etc.)

```bash
aws cloudformation package \
  --template-file templates/main.yaml \
  --s3-bucket meu-bucket-artifacts \
  --output-template-file packaged.yaml \
  --profile dev
```

💡 O bucket meu-bucket-artifacts deve existir previamente.
Caso não exista, crie um manualmente no console S3 ou execute:

```bash
aws s3 mb s3://meu-bucket-artifacts --region <suaregiao> --profile dev
```

Em seguida, crie ou atualize a stack:

```bash
aws cloudformation deploy \
  --template-file packaged.yaml \
  --stack-name my-infra-stack-dev \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides Environment=dev \
  --profile dev
```

## 🧰 4. Diagnóstico e Gerenciamento

Verifique o status das stacks:

```bash
aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE ROLLBACK_FAILED
```

Para visualizar eventos detalhados:

```bash
aws cloudformation describe-stack-events --stack-name my-infra-stack-dev
```

Se precisar excluir a stack:

```bash
aws cloudformation delete-stack --stack-name my-infra-stack-dev
```

## ✅ 5. Validação e Boas Práticas

Use o cfn-lint para validar o template antes de implantar:

```bash
cfn-lint templates/main.yaml
```

## 🌍 6. Região da AWS

Certifique-se de estar utilizando a mesma região configurada no seu perfil CLI.
Exemplo: se o perfil dev foi criado na região de São Paulo (sa-east-1), verifique isso em:

```bash
aws configure list --profile dev
```

## 🧾 7. Resultados do Projeto

Após a execução bem-sucedida do deploy:
- Um bucket S3 será criado com o nome <account-id>-dev-lambda-example-bucket
- Uma IAM Role chamada dev-lambda-execution-role será provisionada
- Uma Lambda Function com nome dev-example-lambda será criada
- Todos os recursos poderão ser visualizados no console AWS CloudFormation

## 🔍 8. Próximos Passos

No próximo repositório, será implementada a automação de tarefas com:
- AWS Lambda Functions
- Integração com S3
- Permissões refinadas de execução via IAM Roles

💬 Créditos

Este projeto foi desenvolvido como parte de um estudo prático sobre infraestrutura como código (IaC) com AWS CloudFormation.
Autora: [Blaine Silva]
