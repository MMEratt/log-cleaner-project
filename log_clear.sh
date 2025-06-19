#!/bin/bash

logfile="/var/log/myapp.log"
backupdir="/backup/logs"
timestamp=$(date +%Y%m%d_%H%M%S)

if [ -f "$logfile" ]; then
  echo "Log dosyası bulundu."

  size=$(du -k "$logfile" | cut -f1)

  if [ $size -gt 51200 ]; then
    echo "Dosya büyük ($size KB). Arşivleniyor..."

    if [ ! -d "$backupdir" ]; then
      echo "$backupdir klasörü oluşturuluyor..."
      mkdir -p "$backupdir"
    fi

    archive_name="myapp_$timestamp.tar.gz"
    tar -czf "$archive_name" "$logfile"
    mv "$archive_name" "$backupdir"

    echo "Orijinal log dosyası siliniyor..."
    rm -rf "$logfile"

    echo "Arşivleme tamamlandı: $backupdir/$archive_name"
  else
    echo "Log dosyası boyutu normal ($size KB)."
  fi

else
  echo "HATA: $logfile bulunamadı!"
fi
