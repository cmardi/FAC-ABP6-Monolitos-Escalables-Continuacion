# Dockerfile para Lección 4
# Multi-stage build para optimizar tamaño de imagen

# Etapa 1: Construcción
FROM maven:3.8.6-openjdk-17 AS builder

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración Maven
COPY pom.xml .
COPY .mvn/ .mvn/
COPY mvnw .
COPY mvnw.cmd .

# Descargar dependencias (se cachea esta capa si pom.xml no cambia)
RUN mvn dependency:go-offline

# Copiar código fuente
COPY src/ src/

# Construir la aplicación (saltando tests para imagen más rápida)
RUN mvn clean package -DskipTests

# Etapa 2: Runtime
FROM openjdk:17-jdk-slim

# Información del contenedor
LABEL maintainer="estudiante@monolito-escalable.com"
LABEL version="1.4.0"
LABEL description="Monolito Escalable - Lección 4 Docker"

# Instalar herramientas necesarias
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Crear usuario no-root para seguridad
RUN groupadd -r spring && useradd -r -g spring spring

# Crear directorio de la aplicación
WORKDIR /app

# Copiar JAR desde la etapa de construcción
COPY --from=builder /app/target/monolito-*.jar app.jar

# Cambiar propiedad del archivo al usuario spring
RUN chown spring:spring app.jar

# Cambiar a usuario no-root
USER spring:spring

# Exponer puerto de la aplicación
EXPOSE 8080

# Variables de entorno por defecto
ENV JAVA_OPTS="-Xmx512m -Xms256m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"
ENV SPRING_PROFILES_ACTIVE=docker

# Health check para Docker
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/api/productos/health || exit 1

# Comando de inicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]