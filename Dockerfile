# Dockerfile simplificado - Funciona siempre
FROM openjdk:17-jdk-slim

# Información del contenedor
LABEL maintainer="estudiante@monolito-escalable.com"
LABEL version="1.4.0"
LABEL description="Monolito Escalable - Lección 4 Docker"

# Instalar curl para health checks
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Crear usuario no-root para seguridad
RUN groupadd -r spring && useradd -r -g spring spring

# Crear directorio de la aplicación
WORKDIR /app

# Copiar JAR ya construido (debes ejecutar 'mvn package' antes)
COPY target/monolito-*.jar app.jar

# Cambiar propiedad del archivo al usuario spring
RUN chown spring:spring app.jar

# Cambiar a usuario no-root
USER spring:spring

# Exponer puerto de la aplicación
EXPOSE 8080

# Variables de entorno por defecto
ENV JAVA_OPTS="-Xmx512m -Xms256m"
ENV SPRING_PROFILES_ACTIVE=docker

# Health check para Docker
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/api/productos/health || exit 1

# Comando de inicio
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]