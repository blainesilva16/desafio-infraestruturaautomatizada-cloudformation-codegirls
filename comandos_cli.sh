# Armazene templates e artefatos (ex.: pacotes Lambda) em um bucket S3 com versionamento ativado.

# empacota artefatos (substitui referências de código por S3)
# aws cloudformation package \
#   --template-file templates/main.yaml \
#   --s3-bucket meu-bucket-artifacts \
#   --output-template-file packaged.yaml \
# #   --profile dev

# # cria/atualiza a stack
# aws cloudformation deploy \
#   --template-file packaged.yaml \
#   --stack-name my-infra-stack-dev \
#   --capabilities CAPABILITY_NAMED_IAM \
#   --parameter-overrides Environment=dev \
# #   --profile dev

# aws cloudformation list-stacks --stack-status-filter ROLLBACK_FAILED CREATE_FAILED
# aws cloudformation delete-stack --stack-name my-infra-stack-dev
# aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE

# aws iam attach-user-policy \
  # --user-name aws-cli-desktop \
  # --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

aws cloudformation package \
  --template-file templates/main.yaml \
  --s3-bucket meu-bucket-artifacts \
  --output-template-file packaged.yaml \
  --profile dev

aws cloudformation deploy \
  --template-file packaged.yaml \
  --stack-name my-infra-stack-dev \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides Environment=dev \

aws cloudformation package --template-file templates/main.yaml --s3-bucket meu-bucket-artifacts --output-template-file packaged.yaml
  
aws cloudformation deploy --template-file packaged.yaml --stack-name my-infra-stack-dev --capabilities CAPABILITY_NAMED_IAM --parameter-overrides Environment=dev

# instalação de ferramenta de validação automática dos templates do AWS CloudFormation.(exemplo com pip)
# essa ferramenta analisa seu arquivo YAML/JSON (como main.yaml) e verifica se a estrutura, 
# os recursos e as propriedades estão corretos de acordo com as regras oficiais da AWS.
pip install cfn-lint

# rodando lint
cfn-lint templates/main.yaml

# validação do template
aws cloudformation validate-template --template-body file://templates/main.yaml

# # cria change set
# aws cloudformation create-change-set \
#   --stack-name my-infra-stack-dev \
#   --change-set-name cs-$(date +%s) \
#   --template-body file://packaged.yaml \
#   --capabilities CAPABILITY_NAMED_IAM

# # veja o change set
# aws cloudformation describe-change-set --stack-name my-infra-stack-dev --change-set-name <name>

# verificação de mudanças na stack (drift detection)
# aws cloudformation detect-stack-drift --stack-name my-infra-stack-dev
# aws cloudformation describe-stack-drift-detection-status --stack-drift-detection-id <id>
