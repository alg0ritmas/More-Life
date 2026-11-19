# Armored Scout v0.2 — model üretimi
Kendi OBJ modelinden 332 üçgenlik GLB, 512x512 renk kaplaması ve Build 42 `model` tanımı üretildi. Modelin Build 42 tarafından gösterildiği henüz doğrulanmadı.
Komutlar: `python -m pip install trimesh numpy pillow`, `python vehicles/tools/build_assets.py`, `python vehicles/tests/validate_assets.py`.
`python vehicles/tools/inspect_game.py "C:\\Program Files (x86)\\Steam\\steamapps\\common\\ProjectZomboid"` yerel oyun araç scriptlerini salt okunur tarar ve yalnızca script isimlerini raporlar.
**Sınırlama:** statik tekerlekler gövdeyle birleşik, ayrı animasyon yok; vehicle bloğu, koltuk/kapı/fizik tanımı ve spawn entegrasyonu yok. Oynanabilir mod veya sunucu güncellemesi değildir.
