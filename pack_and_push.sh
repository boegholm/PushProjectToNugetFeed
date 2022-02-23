#!/bin/bash

projectjson="$1"
version="$2"
NUGET_KEY="$3"
NUGET_SOURCE="$4"
NUGET_SYM_SOURCE="$5"
echo Packing projects: "$projectjson"
echo "$projectjson" |sed "s/'/\"/g" | jq -r '.[]' | while read project; do
      echo "Pack project: $project"
      dotnet pack "$project" --include-source --include-symbols -p:PackageVersion="$inputs" --output nupkgs -p:SymbolPackageFormat=snupkg
      echo pushing
      dotnet nuget push ./nupkgs/*.nupkg --skip-duplicate -k $NUGET_KEY -s $NUGET_SOURCE
      dotnet nuget push ./nupkgs/*.snupkg --skip-duplicate -k $NUGET_KEY -s $NUGET_SYM_SOURCE
      echo "removing pushed packages"
      rm ./nupkgs/*.nupkg ./nupkgs/*.snupkg
      echo removed, done
done
echo "done packing"
