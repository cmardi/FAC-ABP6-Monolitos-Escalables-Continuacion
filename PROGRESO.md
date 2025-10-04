# 🚀 MONOLITO ESCALABLE - CHECKLIST MÓDULO 6

## ✅ CRITERIOS GENERALES REQUERIDOS (https://github.com/cmardi/FAC-ABP6-Monolitos-Escalables.git):
- [x] **CRUD:** 4-5 funcionalidades
- [x] **Tests unitarios:** 8-16 tests
- [x] **Cobertura JaCoCo:** ≥80%
- [x] **Ciclos TDD:** ≥12 (RED-GREEN-REFACTOR)
- [x] **Refactorizaciones:** 3-5
- [x] **Mockito:** ≥1 dependencia mockeada

## 📚 LECCIÓN 2: IMPLEMENTACIÓN MONOLÍTICA EN LA NUBE
- [x] Instancia EC2 básica
- [x] Security Groups configurados
- [x] Conectividad SSH + despliegue
- [x] Scripts de automatización
- [x] **BASE DE DATOS:** RDS
- [x] Conexión aplicación a BD

## 🐳 LECCIÓN 4: CONTENERIZACIÓN CON DOCKER  
- [x] Dockerfile multi-stage
- [x] Imagen en ECR (`monolito-escalable:leccion4`)
- [x] Health checks configurados
- [ ] **OPCIONAL:** ECS Fargate ← PARA LECCIÓN 6
- [x] **RAMAL:** `leccion-4-docker`

## ⚖️ LECCIÓN 3: ESCALABILIDAD Y ALTA DISPONIBILIDAD (ACTUAL)
- [x] Security Group (sg-009992cb39ab89d36)
- [x] Launch Template (lt-monolito-leccion3)
- [x] Target Group (tg-monolito-leccion3)
- [x] Health Check: `/actuator/health`
- [x] **Application Load Balancer (ALB)**
- [x] **Auto Scaling Group (ASG)**
- [x] **Scaling Policy (CPU > 70%)**
- [x] Pruebas distribución de tráfico
- [x] **RAMAL:** `leccion-3-escalabilidad`

## 📨 LECCIÓN 5: SERVICIOS DE MENSAJERÍA
- [x] Topic SNS para notificaciones
- [x] Cola SQS para mensajería
- [x] Integración con aplicación
- [x] Pruebas envío/recepción

## ☁️ LECCIÓN 6: REPRESENTACIÓN CLOUD
- [ ] Diagrama Cloudcraft (arquitectura completa)
- [ ] Estimación costos mensuales
- [ ] Documentación visual profesional

## 🗂️ ENTREGABLES FINALES:
- [x] Documento Word con portada y desarrollo completo
- [x] Capturas de cada paso + evidencias TDD
- [x] Tabla de métricas cumplidas
- [ ] Diagrama Cloudcraft + costos
- [ ] Conclusiones y lecciones aprendidas

## 🔗 RECURSOS AWS CREADOS:
- **VPC:** `vpc-0479f7a981326e4be` (default)
- **ECR:** `monolito-escalable:leccion4`
- **SG:** `monolito-leccion3-sg` 
- **LT:** `lt-monolito-leccion3`
- **TG:** `tg-monolito-leccion3`

## 🎯 PRÓXIMOS PASOS INMEDIATOS:
1. [x] Correcciones Dockerfile (health check)
2. [x] application.properties (config Load Balancer)
3. [x] Load Balancer en AWS Console
4. [x] Auto Scaling Group (CPU 70%)
5. [x] **BASE DE DATOS** (RDS)

## 📊 ESTADO GENERAL:
**Progreso total:** ~95%
**Lección 1:**      100% completada:    TDD GREEN, RED, REFACTOR
**Lección 2 y 3:**  100% completada:    Configuración inicial, infraestructura AWS, Spring Boot + RDS
**Lección 4:**       70% completada:    Docker + ECR completo, ECS Fargate configurado (problema técnico Docker)
**Lección 5:**      100% completada:    Tópico SNS configurado y SQS con envío/recepción de mensajes
**Lección 6:**        0% completada:    Representación Cloud