FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

COPY src/ src/
COPY nuget.config .

RUN dotnet restore "src/API/API.csproj"
RUN dotnet test "src"
RUN dotnet build "src/API/API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "src/API/API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENV ASPNETCORE_URLS=http://+:80;
ENTRYPOINT ["dotnet", "API.dll"]
