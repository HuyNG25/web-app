# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj files and restore
COPY PCM.Core/PCM.Core.csproj PCM.Core/
COPY PCM.Infrastructure/PCM.Infrastructure.csproj PCM.Infrastructure/
COPY PCM.API/PCM.API.csproj PCM.API/
RUN dotnet restore PCM.API/PCM.API.csproj

# Copy everything and build
COPY . .
RUN dotnet build PCM.API/PCM.API.csproj -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish PCM.API/PCM.API.csproj -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 80
EXPOSE 443

COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PCM.API.dll"]
