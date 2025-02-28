#!/usr/bin/env bash

echo "Building known tonies for each folder"

while read -r subdir; do
    FOLDER=$(basename "${subdir}")

    NFC_FILES=()
    while IFS= read -r -d '' file; do
        NFC_FILES+=("$file")
    done < <(find "${subdir}" -type f -name "*.nfc" -print0 | sort -z)

    NFC_FILES_COUNT=${#NFC_FILES[@]}

    echo "${FOLDER} has ${NFC_FILES_COUNT}"
    {
      echo "# ${NFC_FILES_COUNT} ${FOLDER} NFC Files"
      echo ""
      echo "automatically generated, do not edit"
      echo ""
      echo "| Folder | Filename |"
      echo "|--------|----------|"
    } > "${subdir}/README.md"

    for file in "${NFC_FILES[@]}"; do
      FILE_NAME=$(basename "$file")
      FOLDER_NAME=$(basename "$(dirname "$file")")
      printf "| %s | %s |\n" "${FOLDER_NAME}" "${FILE_NAME}" >> "${subdir}/README.md"
    done

done < <(find "." -maxdepth 1 -type d ! -name ".*")
