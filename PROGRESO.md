## 🐳 LECCIÓN 4 - DOCKER & AMAZON ECR

### OBJETIVOS COMPLETADOS
- ✅ Dockerización de aplicación Spring Boot
- ✅ Creación de imagen `appmonolitica:1.0.0`
- ✅ Configuración de Amazon ECR
- ✅ Subida de imagen al registro cloud
- ✅ Configuración de ECS Fargate cluster
- ✅ Comparativa EC2 vs ECS Fargate

### ARQUITECTURA IMPLEMENTADA

Local → Docker Image → Amazon ECR → ECS Fargate

### COMANDOS UTILIZADOS

## CONSTRUIR IMAGEN DOCKER

# Construir imagen
`docker build -t appmonolitica:1.0.0 .`
# Verificar imagen
`docker images | grep appmonolitica`

## PROBAR CONTENEDOR LOCAL

# Ejecutar contenedor
`docker run -d -p 8081:8080 --name monolito-local appmonolitica:1.0.0`
# Verificar estado
`docker ps`
# Ver logs (error BD esperado)
`docker logs monolito-local`

## CONFIGURAR ECR

# Crear repositorio ECR
`aws ecr create-repository --repository-name appmonolitica --region us-east-1`
# Obtener URL de ECR
`aws ecr describe-repositories --repository-names appmonolitica --region us-east-1`

## SUBIR IMAGEN A ECR

# Autenticar con ECR
`aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin [ACCOUNT].dkr.ecr.us-east-1.amazonaws.com`
# Taggear imagen
`docker tag appmonolitica:1.0.0 [ACCOUNT].dkr.ecr.us-east-1.amazonaws.com/appmonolitica:latest`
# Subir imagen
`docker push [ACCOUNT].dkr.ecr.us-east-1.amazonaws.com/appmonolitica:latest`

## ECS FARGATE (OPCIONAL)

# Crear cluster ECS
`aws ecs create-cluster --cluster-name monolito-cluster --region us-east-1`
# Verificar cluster
`aws ecs list-clusters --region us-east-1`

## COMPARATIVA: EC2 vs ECS FARGATE


| `Aspecto` | `EC2` | `ECS Fargate` |
|---------|-----|-------------|
|  Gestión de servidores  | Manual       | AWS gestiona        |
|  Escalado               | Manual/ASG   | Automático          |
|  Pricing                | Por hora     | Por uso de recursos |
|  Despliegue             | Más complejo | Más simple          |
|  Mantenimiento          |	Alto         | Bajo                |



