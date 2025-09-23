# Usa uma imagem base Java 17 para construir a aplicação
FROM eclipse-temurin:17-jdk-jammy as builder

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia o arquivo Maven POM e o diretório src
COPY pom.xml .
COPY src ./src

# Compila o projeto Spring Boot e gera o JAR
RUN ./mvnw clean package -DskipTests

# Usa uma imagem base menor para a execução (runtime)
FROM eclipse-temurin:17-jre-jammy

# Define o diretório de trabalho
WORKDIR /app

# Copia o JAR compilado da etapa de build
COPY --from=builder /app/target/*.jar app.jar

# Expõe a porta que a aplicação escuta (porta padrão do Spring Boot)
EXPOSE 8080

# Define o comando para executar a aplicação
ENTRYPOINT ["java","-jar","app.jar"]
