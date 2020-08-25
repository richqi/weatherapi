# Get Base Image (Full .NET Core SDK)
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

# Copy csproj and restore - Using dotnet restore to resolve any project dependencies (this is done using the .csproj file and retrieving any additional dependencies via Nuget)
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Generate runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
EXPOSE 80
#Copy the relevant files from both the dependency resolution step, (build-env), and build step, (/app/out), to our working directory /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "weatherapi.dll"]