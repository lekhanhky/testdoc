# syntax=docker/dockerfile:1

# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
#Install dependencies
RUN apt-get update
RUN apt-get install -y libc6 libicu-dev libfontconfig1

WORKDIR /src

# Copy solution and restore as distinct layers
COPY ["TestDoc/TestDoc.Blazor.Server/TestDoc.Blazor.Server.csproj", "TestDoc/TestDoc.Blazor.Server/"]
COPY ["TestDoc/TestDoc.Module/TestDoc.Module.csproj", "TestDoc/TestDoc.Module/"]
COPY . .
# Copy thư mục chứa các gói nuget vào image
COPY nuget-packages /nuget-packages

WORKDIR "/src/TestDoc/TestDoc.Blazor.Server"
RUN dotnet nuget add source /nuget-packages --name LocalDevExpress
RUN dotnet restore
# Thêm nguồn nuget cục bộ

# Build and publish
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000

ENTRYPOINT ["dotnet", "TestDoc.Blazor.Server.dll"]