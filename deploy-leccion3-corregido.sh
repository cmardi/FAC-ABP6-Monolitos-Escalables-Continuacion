#!/bin/bash
set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🏗️  LECCIÓN 3 - VERSIÓN CORREGIDA${NC}"
echo "===================================="

# Configuración
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="998244282217"
TARGET_GROUP_NAME="tg-monolito-leccion3"

echo -e "${YELLOW}📋 Verificando prerequisitos...${NC}"

# Verificar imagen ECR
aws ecr describe-images \
  --repository-name monolito-escalable \
  --image-ids imageTag=leccion4 \
  --region $AWS_REGION > /dev/null 2>&1 && \
  echo -e "${GREEN}✅ Imagen ECR encontrada${NC}" || \
  { echo -e "${RED}❌ Imagen ECR no encontrada${NC}"; exit 1; }

# Paso 1: Crear Security Group (si no existe)
echo -e "${YELLOW}🛡️  Paso 1: Verificando Security Group...${NC}"

VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --query "Vpcs[0].VpcId" --output text --region $AWS_REGION)
echo -e "${GREEN}✅ VPC ID obtenida: $VPC_ID${NC}"

SG_ID=$(aws ec2 describe-security-groups --group-names "monolito-leccion3-sg" --region $AWS_REGION --query 'SecurityGroups[0].GroupId' --output text 2>/dev/null || true)

if [ -z "$SG_ID" ]; then
    SG_ID=$(aws ec2 create-security-group \
        --group-name "monolito-leccion3-sg" \
        --description "Security group for scalable monolith" \
        --vpc-id $VPC_ID \
        --region $AWS_REGION \
        --query 'GroupId' \
        --output text)
    
    aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $AWS_REGION
    aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 8080 --cidr 0.0.0.0/0 --region $AWS_REGION
    aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $AWS_REGION
    echo -e "${GREEN}✅ Security Group creado: $SG_ID${NC}"
else
    echo -e "${GREEN}✅ Security Group ya existe: $SG_ID${NC}"
fi

# Paso 2: Crear Launch Template (si no existe)
echo -e "${YELLOW}🚀 Paso 2: Verificando Launch Template...${NC}"
LT_EXISTS=$(aws ec2 describe-launch-templates --launch-template-names "lt-monolito-leccion3" --region $AWS_REGION --query 'LaunchTemplates[0]' 2>/dev/null || echo "false")

if [ "$LT_EXISTS" = "false" ]; then
    USER_DATA_BASE64=$(echo "#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 998244282217.dkr.ecr.us-east-1.amazonaws.com
docker pull 998244282217.dkr.ecr.us-east-1.amazonaws.com/monolito-escalable:leccion4
docker run -d -p 8080:8080 998244282217.dkr.ecr.us-east-1.amazonaws.com/monolito-escalable:leccion4" | base64 -w 0)

    aws ec2 create-launch-template \
        --launch-template-name "lt-monolito-leccion3" \
        --version-description "Launch template with Docker" \
        --launch-template-data "{
            \"ImageId\": \"ami-0c02fb55956c7d316\",
            \"InstanceType\": \"t2.micro\",
            \"KeyName\": \"monolito-key\",
            \"SecurityGroupIds\": [\"$SG_ID\"],
            \"UserData\": \"$USER_DATA_BASE64\",
            \"TagSpecifications\": [{
                \"ResourceType\": \"instance\",
                \"Tags\": [
                    {\"Key\": \"Name\", \"Value\": \"monolito-leccion3\"},
                    {\"Key\": \"Project\", \"Value\": \"monolito-escalable\"}
                ]
            }]
        }" \
        --region $AWS_REGION
    echo -e "${GREEN}✅ Launch Template creado${NC}"
else
    echo -e "${GREEN}✅ Launch Template ya existe${NC}"
fi

# Paso 3: SOLUCIÓN DEFINITIVA - Crear Target Group SIN health check path primero
echo -e "${YELLOW}🎯 Paso 3: Verificando Target Group existente...${NC}"

# Verificar si el Target Group ya existe
EXISTING_TG_ARN=$(aws elbv2 describe-target-groups \
    --names "$TARGET_GROUP_NAME" \
    --region $AWS_REGION \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text 2>/dev/null || echo "")

if [ -n "$EXISTING_TG_ARN" ]; then
    echo -e "${YELLOW}⚠️  Target Group ya existe: $EXISTING_TG_ARN${NC}"
    echo -e "${YELLOW}🔄 Eliminando Target Group existente...${NC}"

    # Eliminar el Target Group existente
    aws elbv2 delete-target-group \
        --target-group-arn "$EXISTING_TG_ARN" \
        --region $AWS_REGION

    echo -e "${GREEN}✅ Target Group existente eliminado${NC}"
    sleep 10  # Esperar a que se complete la eliminación
fi

# SOLUCIÓN: Crear Target Group SIN health check path primero
echo -e "${YELLOW}🎯 Creando Target Group (sin path inicial)...${NC}"

TG_ARN=$(aws elbv2 create-target-group \
    --name "$TARGET_GROUP_NAME" \
    --protocol HTTP \
    --port 8080 \
    --vpc-id "$VPC_ID" \
    --health-check-protocol HTTP \
    --health-check-port "8080" \
    --health-check-timeout-seconds 5 \
    --health-check-interval-seconds 30 \
    --healthy-threshold-count 2 \
    --unhealthy-threshold-count 3 \
    --health-check-enabled \
    --target-type "instance" \
    --region $AWS_REGION \
    --query 'TargetGroups[0].TargetGroupArn' \
    --output text)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Target Group creado exitosamente: $TG_ARN${NC}"

    # SOLUCIÓN: Configurar el health check path DESPUÉS usando MSYS_NO_PATHCONV
    echo -e "${YELLOW}🔄 Configurando health check path...${NC}"

    MSYS_NO_PATHCONV=1 aws elbv2 modify-target-group \
        --target-group-arn "$TG_ARN" \
        --health-check-path "/actuator/health" \
        --region $AWS_REGION

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Health check path configurado en: /actuator/health${NC}"
    else
        echo -e "${YELLOW}⚠️  No se pudo configurar el path, usando configuración por defecto${NC}"
    fi
else
    echo -e "${RED}❌ Error creando Target Group${NC}"
    exit 1
fi

# Verificación final
echo ""
echo -e "${YELLOW}📊 Verificación final...${NC}"
aws elbv2 describe-target-groups \
    --target-group-arns "$TG_ARN" \
    --region $AWS_REGION \
    --query 'TargetGroups[0].{Name:TargetGroupName,Port:Port,HealthCheckPath:HealthCheckPath,Protocol:Protocol}'

echo ""
echo -e "${BLUE}🎉 LECCIÓN 3 - INFRAESTRUCTURA COMPLETADA${NC}"
echo "================================================"
echo -e "${GREEN}✅ Todos los recursos creados exitosamente${NC}"