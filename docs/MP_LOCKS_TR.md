# Multiplayer sandık kilitleri — geliştirme prototipi
More Life otomatik işlemi sandık başına tek oyuncuya ait geçici kilit kullanır. Başka oyuncu aynı sandığı isterse işlem başlatılmaz; arayüzde sunucudan doğrulanan oyuncu adı gösterilmesi hedeflenir. Farklı sandıklar bağımsızdır.
30 saniyelik kira süresi başlangıç varsayımıdır. Aktif sunucu işlemi süreyi yeniler; bitişte bırakır. Süre dolduğunda eski iş kesinlikle devam etmemelidir. Bağlantı kesilmesinde önce iş durdurulur, ardından kilit kaldırılır. Eski token yeni kilidi bırakamaz.
## Durum
Saf kilit ve dahili sunucu servis kodu var. Henüz gerçek PZ konteyner çözümleyicisi, erişim/kapsam denetimi, güvenli bağlantı kimliği yaşam döngüsü, saat adaptörü, istemci uyarısı veya native transfer entegrasyonu yok. Servis başlatılmıyor ve ağ komutu açılmıyor. Normal vanilla işlemler kilitlenmiyor. Bu nedenle oyun içi kilit çalışıyor denemez.
## Entegrasyon kabul kriterleri
Sunucu gerçek konteyneri çözümlemeli; istemcinin gönderdiği isim/kimlik/koordinat tek başına güvenilmez. Aynı konteynerin farklı erişim yolları aynı anahtarı üretmeli. Her eşya hareketinden önce geçerli kilit ve izin kontrol edilmeli. Çoklu konteyner işlemleri kaynak/hedef çatışmalarını çözmeli. Oyuncu ID yeniden kullanımı ve bağlantı kesilmesi test edilmeli. Vanilla transferle çakışmada eşya kaybı/çoğaltma olmamalı. İlk test iki oyunculu yedek sunucuda yapılmalı.
