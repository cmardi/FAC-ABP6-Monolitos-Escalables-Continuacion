## Descripción del Proyecto

Aplicación monolítica escalable desarrollada en Java Spring Boot que implementa un CRUD completo de productos. El proyecto demuestra principios de arquitectura escalable, contenerización y buenas prácticas de desarrollo.

## 🎯 Metodología de Desarrollo

### 🔄 Evolución del Enfoque
El proyecto comenzó con un **enfoque CLI (Command Line Interface)** para configuraciones rápidas y luego migró a un **enfoque GUI (Graphical User Interface)** para una documentación más visual y detallada, siguiendo las mejores prácticas del curso.

**Fases de Implementación:**
1. **🔧 Fase CLI (Inicial)**
   - Configuración rápida via AWS CLI y terminal
   - Desarrollo ágil con comandos directos
   - Enfoque en funcionalidad sobre documentación

2. **🎨 Fase GUI (Actual)**
   - Configuración via AWS Management Console
   - Documentación visual con capturas de pantalla
   - Seguimiento del formato Aldo Frez para informes
   - Enfoque en reproducibilidad y documentación completa

### 📊 Beneficios del Enfoque Mixto
- **Velocidad inicial** con CLI para prototipado rápido
- **Documentación robusta** con GUI para entregables finales
- **Aprendizaje completo** de ambas interfaces de AWS
- **Preparación** para escenarios reales de trabajo

## Arquitectura Implementada: ##

Spring Boot 3.5.5 + ├── API REST JSON ├── Spring Data JPA ├── Capa de Servicio ├── Sistema de Persistencia └── Frontend Integrado

## Tecnologías Implementadas ##

Java 17 - JDK Corretto

Spring Boot 3.5.5 - Framework principal

Spring Data JPA - Persistencia de datos

H2 Database - Base de datos embebida inicialmente, luego MySQL en pruebas con AWS

Maven - Gestión de dependencias

Docker - Contenerización

## 🏗️ Arquitectura en AWS ##

MySQL RDS + Auto Scaling Group + Docker
Auto Scaling Group → EC2 Instances (t3.micro) → Spring Boot App → RDS MySQL (db.t4g.micro)

## 📊 Progreso del Proyecto - ABP6

### ✅ Lecciones Completadas

| Lección | Estado | Descripción | Rama GitHub |
|---------|--------|-------------|-------------|
| 1 | ✅ Completada | TDD + Fundamentos Escalabilidad | `leccion-1-tdd` |
| 2 | ✅ Completada | App Monolítica en EC2 + RDS MySQL | `leccion-2-monolito-gui` |
| 3 | ✅ Completada | Auto Scaling + High Availability | `leccion-3-escalabilidad-gui` |
| 4 | ✅ Completada | Docker + Amazon ECR | `leccion-4-docker-gui` |
| 5 | ❌ Pendiente | SNS/SQS - Mensajería | - |
| 6 | ❌ Pendiente | Documentación Final | - |

## 🌐 URLs de la Aplicación en Producción
- **🌍 Aplicación Principal**: http://3.90.191.76:8080/
- **🔗 API REST**: http://3.90.191.76:8080/api/productos
- **✅ Health Check**: http://3.90.191.76:8080/api/productos/test
- **📊 Spring Actuator**: http://3.90.191.76:8080/actuator/health

## Tecnologías Implementadas
- **Java 17** - JDK Corretto
- **Spring Boot 3.5.6** - Framework principal
- **Spring Data JPA** - Persistencia de datos
- **MySQL RDS** - Base de datos en AWS
- **Maven** - Gestión de dependencias
- **Docker** - Contenerización
- **AWS EC2** - Computación en la nube
- **AWS Auto Scaling** - Escalabilidad automática

monolito/
├── src/
│ ├── main/
│ │ ├── java/com/alkemy/monolito/
│ │ │ ├── model/Producto.java
│ │ │ ├── repository/ProductoRepository.java
│ │ │ ├── service/ProductoService.java
│ │ │ ├── controller/ProductoController.java
│ │ │ └── MonolitoApplication.java
│ │ └── resources/
│ │ ├── application.properties
│ │ └── static/
│ └── test/
├── data/
├── Dockerfile
└── pom.xml

## Endpoints de la API
- `GET /api/productos` - Obtener todos los productos
- `GET /api/productos/{id}` - Obtener producto por ID
- `POST /api/productos` - Crear nuevo producto
- `PUT /api/productos/{id}` - Actualizar producto
- `DELETE /api/productos/{id}` - Eliminar producto
- `GET /api/productos/test` - Health check de la aplicación

## ⚙️ Configuraciones

### 🔧 Desarrollo Local

`spring.datasource.url=jdbc:h2:file:./data/monolitodb`
`spring.datasource.username=sa`
`spring.datasource.password=`
`spring.h2.console.enabled=true`
`server.port=8080`

## Producción AWS ##

`spring.datasource.url=jdbc:mysql://db-monolito-new.c8x6eia0ogy7.us-east-1.rds.amazonaws.com:3306/base_prueba`
`spring.datasource.username=admin`
`spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver`
`spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect`
`server.port=8080`

## 🐳 Dockerización ##

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/monolito-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

## 📋 Recursos AWS Activos ##

EC2 Instances: app-monolito-reset (3.90.191.76)

RDS MySQL: db-monolito-new (db.t4g.micro)

Auto Scaling Group: appmonolitica-asg-reset

Launch Template: appmonolitica-template-reset

AMI: appmonolitica-ami-reset

Security Group: monolito-sg-reset

## 🛠️ Comandos Útiles ##
** 🔨 Desarrollo **

# Compilar proyecto
mvn clean compile

# Ejecutar aplicación local
mvn spring-boot:run

# Empaquetar para producción
mvn clean package -DskipTests

## ☁️ AWS & Producción ##

# Conectar a instancia EC2
ssh -i monolito-gui-key.pem ec2-user@3.90.191.76

# Probar endpoints remotos
curl http://3.90.191.76:8080/api/productos/test

# Ver logs de aplicación
tail -f app.log

## 🐳 Docker ##

# Construir imagen Docker
docker build -t alkemy-monolito .

# Ejecutar contenedor
docker run -p 8080:8080 alkemy-monolito

## 🚀 Funcionalidades Implementadas ##

✅ CRUD completo de productos

✅ API RESTful con JSON

✅ Persistencia con MySQL RDS

✅ Frontend integrado responsive

✅ Auto Scaling y High Availability

✅ Health Checks automáticos

✅ Contenerización con Docker

✅ Validaciones de datos robustas

## 📈 Métricas y Buenas Prácticas ##

4 operaciones CRUD completas

Arquitectura en capas (Controller-Service-Repository)

Manejo de excepciones centralizado

Configuración multi-ambiente

Seguridad con .gitignore para credenciales

Documentación técnica completa



