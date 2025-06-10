# syntax=docker/dockerfile:1

# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# Install dependencies
RUN apt-get update

RUN apt-get upgrade -y

RUN apt-get install -y libc6

RUN apt-get install -y libicu-dev

RUN apt-get install -y libfontconfig1

RUN apt-get clean

RUN rm -rf /var/lib/apt/lists/*





WORKDIR /src

# Copy solution and restore as distinct layers
COPY ["TestDoc/TestDoc.Blazor.Server/TestDoc.Blazor.Server.csproj", "TestDoc/TestDoc.Blazor.Server/"]
COPY ["TestDoc/TestDoc.Module/TestDoc.Module.csproj", "TestDoc/TestDoc.Module/"]
COPY . .
# Copy the local nuget-packages directory into the image at the new location
COPY nuget-packages /src/TestDoc/nuget-packages

WORKDIR /src/TestDoc/
#RUN dotnet nuget add source /src/TestDoc/nuget-packages --name LocalDevExpress
#RUN dotnet restore
# Add the local nuget source
# Chuyển đến thư mục chứa tệp .csproj
WORKDIR /src/TestDoc/TestDoc.Blazor.Server

# Kiểm tra xem tệp .csproj có tồn tại trong thư mục này không
RUN ls -al /src/TestDoc/TestDoc.Blazor.Server

# Chạy dotnet restore
RUN dotnet restore TestDoc.Blazor.Server.csproj


# Build and publish
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000

ENTRYPOINT ["dotnet", "TestDoc.Blazor.Server.dll"]
