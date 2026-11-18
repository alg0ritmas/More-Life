# Multiplayer 0.2.4 — altyapı testi
Öncelik Build 42 dedicated/Host; ayrı yeni test sunucusu, iki oyuncu, aynı oyun ve mod sürümü. Mevcut kayıtları yedekle. Bu sürüm MP'de sadece okuma ayarı raporlar; eski istemci hız, XP ve transfer kodunu MP'de etkinleştirmez.
## İlk iş: oyun içi yerleşik okuma ayarı
Host > Manage Settings > Edit Selected Settings > Sandbox > Character > Minutes Per Skill Book Page. Dedicated: sunucu kapalıyken <ServerName>_SandboxVars.lua içindeki mevcut MinutesPerPage değerini değiştir. 2.0 referansına göre 10x=0.2, 15x=0.133333, 20x=0.1. Diğer ayarlara dokunma. Yeniden başlat. Sürümün minimum değerini ve mevcut dünyada ayarın uygulandığını doğrula. Bu işlem mod gerektirmez.
## Mod testi
Test sunucusunda mod dosyalarını sunucu ve iki istemcide aynı sürümle kur. Yerel mod dağıtım yöntemini barındırma ortamına göre seç. Mod ID MoreLifeSmartInventory. Workshop ID henüz yok; Steam Workshop üzerinden otomatik dağıtım henüz yapılamaz.
1. Sunucu logunda [MoreLife MP 0.2.4] ve doğru MinutesPerPage değerini ara.
2. Her iki oyuncuda dünya sağ tık > More Life MP | Reading settings; değerler sunucuyla eşleşmeli.
3. Aynı sayfa sayısı, aynı karakter okuma özelliği, aynı gün uzunluğuyla 1x ve 20x kitap sürelerini ölç. Her oyuncu yeni okunmamış kitap kullanmalı.
4. Sunucudan çıkıp yeniden bağlan; politika değişmemeli. Yerel SP menü ve hızlandırma MP'de çalışmamalı.
5. Vanilla transfer, XP ve savaş davranışının değişmediğini kontrol et.
6. Oyun sürümü, sunucu türü, ayar, süreler, sunucu/istemci loglarındaki MoreLife satırları ve hataları kaydet. IP, kullanıcı bilgisi ve erişim anahtarlarını çıkar.
## Kabul
Sunucu ve iki istemci uyumu doğrulanmadan MP hız hook'u veya otomatik transfer açılmaz. Native transfer erişim/kapasite ve eşzamanlı oyuncu testleri sonraki aşama. Anti-cheat kapatılmaz.
