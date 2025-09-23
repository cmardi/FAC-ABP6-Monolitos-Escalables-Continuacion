#!/bin/bash
# deploy-to-ecr.sh - Script para desplegar a Amazon ECR
# Lección 4: Docker

set -e  # Salir si cualquier comando falla

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🐳 INICIANDO DESPLIEGUE A AMAZON ECR${NC}"
echo -e "${BLUE}===============================================${NC}"

# Variables de configuración - MODIFICA SEGÚN TUS DATOS
AWS_REGION="us-east-1"
ECR_REPOSITORY="monolito-escalable"
IMAGE_TAG="leccion4"

echo -e "${YELLOW}📋 Configuración del despliegue:${NC}"
echo "   AWS Region: $AWS_REGION"
echo "   Repository: $ECR_REPOSITORY"
echo "   Image Tag: $IMAGE_TAG"
echo ""

# Paso 1: Verificar herramientas necesarias
echo -e "${YELLOW}🔍 Paso 1: Verificando herramientas necesarias...${NC}"

if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI no está instalado${NC}"
    echo "   Instálalo desde: https://aws.amazon.com/cli/"
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker no está instalado${NC}"
    exit 1
fi

if ! command -v mvn &> /dev/null; then
    echo -e "${RED}❌ Maven no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Todas las herramientas están disponibles${NC}"

# Paso 2: Verificar credenciales AWS
echo -e "${YELLOW}🔐 Paso 2: Verificando credenciales AWS...${NC}"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null) || {
    echo -e "${RED}❌ Error: No se pudieron obtener credenciales AWS${NC}"
    echo "   Configura AWS CLI con: aws configure"
    echo "   O verifica tus credenciales de AWS Academy"
    exit 1
}

echo -e "${GREEN}✅ Credenciales AWS válidas${NC}"
echo "   Account ID: $AWS_ACCOUNT_ID"
echo "   Region: $AWS_REGION"

# Paso 3: Construir aplicación Java
echo -e "${YELLOW}🔨 Paso 3: Construyendo aplicación Java...${NC}"
echo "   Ejecutando: mvn clean package -DskipTests"

mvn clean package -DskipTests || {
    echo -e "${RED}❌ Error al construir la aplicación Java${NC}"
    exit 1
}

# Verificar que el JAR se generó
if [ ! -f target/monolito-*.jar ]; then
    echo -e "${RED}❌ Error: No se encontró el archivo JAR en target/${NC}"
    exit 1
fi

JAR_FILE=$(ls target/monolito-*.jar | head -n1)
echo -e "${GREEN}✅ Aplicación construida exitosamente${NC}"
echo "   JAR generado: $JAR_FILE"

# Paso 4: Crear repositorio ECR si no existe
echo -e "${YELLOW}🏗️ Paso 4: Verificando repositorio ECR...${NC}"

aws ecr describe-repositories --repository-names $ECR_REPOSITORY --region $AWS_REGION > /dev/null 2>&1 || {
    echo -e "${YELLOW}📦 Creando repositorio ECR: $ECR_REPOSITORY${NC}"
    aws ecr create-repository \
        --repository-name $ECR_REPOSITORY \
        --region $AWS_REGION \
        --image-scanning-configuration scanOnPush=true || {
        echo -e "${RED}❌ Error al crear repositorio ECR${NC}"
        exit 1
    }
    echo -e "${GREEN}✅ Repositorio ECR creado${NC}"
}

echo -e "${GREEN}✅ Repositorio ECR verificado${NC}"

# Paso 5: Autenticación con ECR
echo -e "${YELLOW}🔐 Paso 5: Autenticando con ECR...${NC}"

aws ecr get-login-password --region $AWS_REGION | \
docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com || {
    echo -e "${RED}❌ Error al autenticarse con ECR${NC}"
    exit 1
}

echo -e "${GREEN}✅ Autenticación con ECR exitosa${NC}"

# Paso 6: Construir imagen Docker
echo -e "${YELLOW}🔨 Paso 6: Construyendo imagen Docker...${NC}"

docker build -t $ECR_REPOSITORY:$IMAGE_TAG . || {
    echo -e "${RED}❌ Error al construir imagen Docker${NC}"
    exit 1
}

echo -e "${GREEN}✅ Imagen Docker construida${NC}"

# Paso 7: Etiquetar imagen para ECR
ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:$IMAGE_TAG"
echo -e "${YELLOW}🏷️ Paso 7: Etiquetando imagen para ECR...${NC}"
echo "   URI de destino: $ECR_URI"

docker tag $ECR_REPOSITORY:$IMAGE_TAG $ECR_URI || {
    echo -e "${RED}❌ Error al etiquetar imagen${NC}"
    exit 1
}

echo -e "${GREEN}✅ Imagen etiquetada correctamente${NC}"

# Paso 8: Subir imagen a ECR
echo -e "${YELLOW}⬆️ Paso 8: Subiendo imagen a ECR...${NC}"
echo "   Esto puede tomar varios minutos..."

docker push $ECR_URI || {
    echo -e "${RED}❌ Error al subir imagen a ECR${NC}"
    exit 1
}

echo -e "${GREEN}✅ Imagen subida exitosamente a ECR${NC}"

# Resumen final
echo ""
echo -e "${GREEN}🎉 ¡DESPLIEGUE COMPLETADO EXITOSAMENTE!${NC}"
echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}📍 Imagen disponible en:${NC}"
echo "   $ECR_URI"
echo ""
echo -e "${YELLOW}💡 Comandos útiles:${NC}"
echo "   Para ejecutar localmente:"
echo "   docker run -p 8080:8080 $ECR_REPOSITORY:$IMAGE_TAG"
echo ""
echo "   Para usar en ECS Task Definition:"
echo "   $ECR_URI"
echo ""
echo "   Para ver en AWS Console:"
echo "   https://console.aws.amazon.com/ecr/repositories/$ECR_REPOSITORY/"
echo ""
echo -e "${GREEN}✅ Lección 4 - Docker: COMPLETADA${NC}"