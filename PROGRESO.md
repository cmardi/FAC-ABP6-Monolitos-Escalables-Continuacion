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
- [ ] **BASE DE DATOS:** RDS o DynamoDB ← PENDIENTE
- [ ] Conexión aplicación a BD

## 🐳 LECCIÓN 4: CONTENERIZACIÓN CON DOCKER  
- [x] Dockerfile multi-stage
- [x] Imagen en ECR (`monolito-escalable:leccion4`)
- [x] Health checks configurados
- [ ] **OPCIONAL:** ECS Fargate ← PARA LECCIÓN 6
- [ ] **RAMAL:** `leccion-4-docker`

## ⚖️ LECCIÓN 3: ESCALABILIDAD Y ALTA DISPONIBILIDAD (ACTUAL)
- [x] Security Group (sg-009992cb39ab89d36)
- [x] Launch Template (lt-monolito-leccion3)
- [x] Target Group (tg-monolito-leccion3)
- [x] Health Check: `/actuator/health`
- [ ] **Application Load Balancer (ALB)**
- [ ] **Auto Scaling Group (ASG)** 
- [ ] **Scaling Policy (CPU > 70%)**
- [ ] Pruebas distribución de tráfico
- [ ] **RAMAL:** `leccion-3-escalabilidad`

## 📨 LECCIÓN 5: SERVICIOS DE MENSAJERÍA
- [ ] Topic SNS para notificaciones
- [ ] Cola SQS para mensajería
- [ ] Integración con aplicación
- [ ] Pruebas envío/recepción

## ☁️ LECCIÓN 6: REPRESENTACIÓN CLOUD
- [ ] Diagrama Cloudcraft (arquitectura completa)
- [ ] Estimación costos mensuales
- [ ] Documentación visual profesional

## 🗂️ ENTREGABLES FINALES:
- [ ] Documento Word con portada y desarrollo completo
- [ ] Capturas de cada paso + evidencias TDD
- [ ] Tabla de métricas cumplidas
- [ ] Diagrama Cloudcraft + costos
- [ ] Conclusiones y lecciones aprendidas

## 🔗 RECURSOS AWS CREADOS:
- **VPC:** `vpc-0479f7a981326e4be` (default)
- **ECR:** `monolito-escalable:leccion4`
- **SG:** `monolito-leccion3-sg` 
- **LT:** `lt-monolito-leccion3`
- **TG:** `tg-monolito-leccion3`

## 🎯 PRÓXIMOS PASOS INMEDIATOS:
1. [ ] Correcciones Dockerfile (health check) ← EN CURSO
2. [ ] application.properties (config Load Balancer)
3. [ ] Load Balancer en AWS Console
4. [ ] Auto Scaling Group (CPU 70%)
5. [ ] **BASE DE DATOS** (RDS/DynamoDB) ← IMPORTANTE

## 📊 ESTADO GENERAL:
**Progreso total:** ~45%  
**Lección 3:** 60% completada
**Próxima crítica:** Base de datos + Lección 5 (Mensajería)