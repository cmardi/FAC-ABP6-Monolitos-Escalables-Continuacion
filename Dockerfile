FROM openjdk:17-slim

WORKDIR /app

# Instalar curl con apt (correcto para Debian/Ubuntu)
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

COPY target/monolito-*.jar app.jar

EXPOSE 8080

# HEALTH CHECK CORREGIDO - Usar actuator que se sabe que existe
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
