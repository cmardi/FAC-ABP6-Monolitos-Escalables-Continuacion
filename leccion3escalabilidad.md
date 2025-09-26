# LECCIÓN 3 - ESCALABILIDAD: INCOMPLETA

## 🎯 OBJETIVOS CUMPLIDOS
- [x] Security Group configurado
- [x] Launch Template con Docker y tu imagen ECR
- [x] Target Group para el Load Balancer
- [x] Health Check en /actuator/health
- [ ] Crear Application Load Balancer
- [ ] Crear Auto Scaling Group
- [ ] Configurar políticas de escalado (CPU > 70%)
- [ ] Probar distribución de tráfico

## 📊 ARCHIVOS IMPLEMENTADOS
1. **Deploy-leccion3-corregido.sh** - Creación y corrección script que automatiza el despliegue de una infraestructura escalable en AWS para una aplicación monolítica con las siguientes acciones técnicas:

Funcionalidades principales:
✅ Verificación de prerequisitos
Valida la existencia de la imagen Docker en ECR (monolito-escalable:leccion4)
✅ Configuración de Security Group
Crea/verifica security group con puertos 22 (SSH), 80 (HTTP), 8080 (App)
Asocia al VPC por defecto de la región
✅ Creación de Launch Template
Template lt-monolito-leccion3 con AMI Amazon Linux 2
User Data que automatiza:
Instalación y configuración de Docker
Pull de imagen ECR
Deployment del contenedor en puerto 8080
✅ Gestión de Target Group (SOLUCIÓN CORREGIDA)
Problema resuelto: Elimina y recrea el Target Group existente
Workaround técnico: Crea TG sin health path primero, luego lo configura
Usa MSYS_NO_PATHCONV=1 para evitar problemas de path en Windows/WSL
✅Arquitectura implementada:
Load Balancer → Target Group → Auto Scaling Group → EC2 Instances → Docker Container (8080)