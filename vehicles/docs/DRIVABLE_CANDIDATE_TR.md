# v0.3 — Sürülebilir araç tanımı adayı
**Oynanabilirlik doğrulanmadı.** Windows'ta `BUILD_VEHICLE_TEST.cmd` komutu, kullanıcının kendi yüklü Build 42 araç scriptlerinden 4 koltuklu bir kaynak arar. Orijinal oyun dosyalarına dokunmadan `MoreLifeVehicles.MLVArmoredScout` isimli yeni bir script üretir. Gövde modeli MLV_ArmoredScout ile değiştirilir, diğer bütün ayarlar kaynak araçtan korunur.

Bu, gerçek bir sürüş testi yapılmadan güvenilir ilan edilemez. Ayrı spawn tanımı yok; otomatik normal harita spawn'ı yapılmıyor. Dört koltuk, tekerlek yerleşimi, collision/physics, ses ve görünüm oyun içerisinde kontrol edilmeli. Paket canlı multiplayer sunucusuna veya Workshop'a kurulmamalı.

Çıktı: `42/media/scripts/vehicles/MLV_ArmoredScout.txt` ve `42/mlv_generation_report.json`. Oyun sürümünü ve kaynak scripti belirtir. Script üreticisi hiçbir özgün oyunun scriptini GitHub'a kopyalamaz.
