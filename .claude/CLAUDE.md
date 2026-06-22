# TrimlyX Agent Platform — Container Config

## Token Kuralları
- Her yanıt kısa ve öz. Filler/article/pleasantry YOK.
- CLI çıktı kısa tut: pipe through `head`/`tail` where needed.
- Paralel tool calls — batch et.
- Glob/Grep önce, Read sonra.

## Model Seçimi
- Sonnet 4.6 → DEFAULT (düşük maliyet)
- Haiku 4.5 → subagent/ucuz işler
- Opus 4.8 → kritik analiz (nadiren)

## Güvenlik Kuralları (KESİN)
- Demo bot J4OPNH → ASLA DOKUNMA
- Sadece TECC5ZTC botuna müdahale et (açıkça belirtilmedikçe)
- pm2 restart all KULLANMA — sadece belirli botu restart et
- Credentials asla git'e commit etme

## Proje Bilgisi
- Şirket: TrimlyX Media
- Ürün: WhatsApp Business otomasyon platformu (argonova.com.tr)
- VPS: 187.127.87.80 (root)
- Aktif botlar: BOT-TECC5ZTC (port 3100), BOT-TXZ027 (3101, pasif), BOT-J4OPNH (3102, DEMO)
- WordPress: argonova.com.tr (elementor, starter-templates)

## Agent'lar
9 departman agent'ı:
1. developer — VPS + WP bot sağlığı
2. siber_guvenlik — tehdit analizi, hardening
3. pazarlama_uzmani — WhatsApp B2C kampanya
4. seo_uzmani — organik trafik, Türk pazarı
5. tasarim_uzmani — UX/UI öneri
6. sosyal_medya_uzmani — içerik takvimi
7. video_editoru — video brief/script
8. mail_marketing — soğuk mail kampanya
9. yazilimci_yenilikci — ürün roadmap, rakip analiz
