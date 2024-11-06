# Используем официальный образ Gradle для сборки
FROM gradle:8.8-jdk17 AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Сначала копируем только файлы конфигурации Gradle и устанавливаем зависимости
COPY build.gradle.kts settings.gradle.kts ./
RUN gradle dependencies --no-daemon

# Затем копируем оставшуюся часть проекта и запускаем сборку
COPY . .
RUN gradle build --no-daemon -x test

# Используем официальный образ OpenJDK для запуска
FROM openjdk:17-jdk-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем скомпилированный JAR файл из предыдущего шага
COPY --from=build /app/build/libs/*.jar app.jar

# Открываем порт 8080 для приложения
EXPOSE 8080

# Запускаем приложение
CMD ["java", "-jar", "app.jar"]
