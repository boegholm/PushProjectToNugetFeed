#!/bin/bash

projectjson="$1"
version="$2"
NUGET_KEY="$3"
NUGET_SOURCE="$4"
NUGET_SYM_SOURCE="$5"

echo "$projectjson" |sed "s/'/\"/g" | jq -r '.[]' | while read project; do
      dotnet pack "$project" --include-source --include-symbols -p:PackageVersion="$inputs" --output nupkgs -p:SymbolPackageFormat=snupkg
      dotnet nuget push ./nupkgs/*.nupkg --skip-duplicate -k $NUGET_KEY -s $NUGET_SOURCE
      dotnet nuget push ./nupkgs/*.snupkg --skip-duplicate -k $NUGET_KEY -s $NUGET_SYM_SOURCE
      rm ./nupkgs/*.nupkg ./nupkgs/*.snupkg
done
