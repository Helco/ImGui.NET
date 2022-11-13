#!/usr/bin/env bash
set +e

if [ $# -eq 0 ]; then
    echo "Missing first argument. Please provide the tag to download."
    exit 1
fi

TAG=$1

SCRIPT_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO=https://github.com/Helco/imgui.net-nativebuild
CURL_ARGS="-Lo"

echo "Script is located in: $SCRIPT_ROOT"
echo "Using Tag: $TAG"

function download_set () {
echo -n "Downloading windows x86 $1: "
mkdir -p "$SCRIPT_ROOT/deps/$1/win-x86/"
curl $CURL_ARGS "$SCRIPT_ROOT/deps/$1/win-x86/$1.dll" "$REPO/releases/download/$TAG/$1.win-x86.dll"
echo ""

echo -n "Downloading windows x64 $1: "
mkdir -p "$SCRIPT_ROOT/deps/$1/win-x64/"
curl $CURL_ARGS "$SCRIPT_ROOT/deps/$1/win-x64/$1.dll" "$REPO/releases/download/$TAG/$1.win-x64.dll"
echo ""

echo -n "Downloading linux x64 $1: "
mkdir -p "$SCRIPT_ROOT/deps/$1/linux-x64/"
curl $CURL_ARGS "$SCRIPT_ROOT/deps/$1/linux-x64/$1.so" "$REPO/releases/download/$TAG/$1.so"
echo ""

echo -n "Downloading osx universal (x86_64 and arm64) $1: "
mkdir -p "$SCRIPT_ROOT/deps/$1/osx/"
curl $CURL_ARGS "$SCRIPT_ROOT/deps/$1/osx/$1.dylib" "$REPO/releases/download/$TAG/$1.dylib"
echo ""

echo -n "Downloading definitions json file: "
curl $CURL_ARGS "$SCRIPT_ROOT/src/CodeGenerator/definitions/$1/definitions.json" "$REPO/releases/download/$TAG/$1-definitions.json"
echo ""

echo -n "Downloading structs and enums json file: "
curl $CURL_ARGS "$SCRIPT_ROOT/src/CodeGenerator/definitions/$1/structs_and_enums.json" "$REPO/releases/download/$TAG/$1-structs_and_enums.json"
echo ""
}

download_set "cimgui"
download_set "cimguizmo"
