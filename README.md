    Monolito Escalable - Fundamentos de Arquitectura Cloud ABP6

1. Descripción del Proyecto

Aplicación monolítica escalable desarrollada en Java Spring Boot que implementa un CRUD completo de productos. El proyecto demuestra principios de arquitectura escalable, contenerización y buenas prácticas de desarrollo.

2. Arquitectura

Spring Boot 3.5.5 + 
├── API REST JSON
├── Spring Data JPA
├── Capa de Servicio
├── Sistema de Persistencia
└── Frontend Integrado

3. Tecnologías Implementadas

- Java 17 - JDK Corretto

- Spring Boot 3.5.5 - Framework principal

- Spring Data JPA - Persistencia de datos

- H2 Database - Base de datos embebida

- Maven - Gestión de dependencias

- Docker - Contenerización

4. Estructura del Proyecto

monolito/
├── src/
│   ├── main/
│   │   ├── java/com/alkemy/monolito/
│   │   │   ├── model/Producto.java
│   │   │   ├── repository/ProductoRepository.java
│   │   │   ├── service/ProductoService.java
│   │   │   ├── controller/ProductoController.java
│   │   │   └── MonolitoApplication.java
│   │   └── resources/
│   │       ├── application.properties
│   │       └── static/
│   └── test/
├── data/
├── Dockerfile
└── pom.xml

5. Endpoints de la API

-   GET /api/productos - Obtener todos los productos

-   GET /api/productos/{id} - Obtener producto por ID

-   POST /api/productos - Crear nuevo producto

-   PUT /api/productos/{id} - Actualizar producto

-   DELETE /api/productos/{id} - Eliminar producto

6. Configuración

- Desarrollo Local

    spring.datasource.url=jdbc:h2:file:./data/monolitodb
    spring.datasource.username=sa
    spring.datasource.password=
    spring.h2.console.enabled=true
    server.port=8080

7. Dockerización

    FROM openjdk:17-jdk-slim
    WORKDIR /app
    COPY target/monolito-0.0.1-SNAPSHOT.jar app.jar
    EXPOSE 8080
    ENTRYPOINT ["java", "-jar", "app.jar"]

8. Comandos Útiles

    bash
    # Compilar proyecto
    mvn clean compile

    # Ejecutar aplicación
    mvn spring-boot:run

    # Empaquetar para producción
    mvn clean package

    # Construir imagen Docker
    docker build -t alkemy-monolito .

9. Funcionalidades
    - CRUD completo de productos

    - API RESTful con JSON

    - Persistencia de datos

    - Frontend integrado responsive

    - Contenerización con Docker

    - Validaciones de datos

10. Métricas Implementadas

4 operaciones CRUD completas

-   Arquitectura en capas

-   Manejo de excepciones

-   Documentación completa

-   Código limpio y organizado