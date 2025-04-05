# Hava Tahmini Uygulaması

Bu proje, Flutter kullanılarak geliştirilmiş basit bir hava tahmini uygulamasıdır. WeatherAPI servisini kullanarak girilen şehir için 7 günlük hava tahminlerini getirir. Uygulama, favorilere ekleme özelliği ile kullanıcıların favori şehirlerini saklayıp istedikleri zaman kolayca erişebilmelerini sağlar. Ayrıca, hava durumu açıklamalarına uygun emoji desteği ve okunabilir tarih formatı ile kullanıcı deneyimini artırır.

## Özellikler

- **7 Günlük Hava Tahmini:** Girilen şehir için 7 günlük hava durumu verilerini getirir.
- **Türkçe Dil Desteği:** API çağrılarında `lang=tr` parametresi kullanılarak hava durumu açıklamaları Türkçe döner.
- **Emoji Desteği:** Hava durumuna uygun (yağmur, kar, bulut, güneş, fırtına, sis vb.) emoji gösterimi.
- **Favorilere Ekleme:** Kullanıcılar favori şehirlerini ekleyip, Drawer üzerinden favorilere erişebilir.
- **Okunabilir Tarih Formatı:** API’den gelen tarihi “5 Nisan 2025” gibi okunabilir bir formata dönüştürür.

## Teknolojiler

- **Flutter** ve **Dart**: Uygulama geliştirme.
- **http**: API çağrıları için.
- **WeatherAPI**: Hava tahmini verileri için (7 günlük forecast endpoint).

## Kurulum ve Çalıştırma

### Gereksinimler

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Bir Flutter uyumlu IDE (Visual Studio Code, Android Studio, vb.)
- WeatherAPI üzerinden alınmış bir API anahtarı

### Adımlar

1. **Projeyi İndirin veya Klonlayın:**

   ```bash
   git clone <repository-url>
   ```

2. **Gerekli Paketleri Yükleyin:**

   Proje dizininde terminalden:

   ```bash
   flutter pub get
   ```

3. **API Anahtarınızı Ayarlayın:**

   `main.dart` dosyasında yer alan `apiKey` değişkeninin değerini, WeatherAPI’den aldığınız API anahtarı ile değiştirin:

   ```dart
   const String apiKey = 'YOUR_API_KEY';
   ```

4. **Uygulamayı Çalıştırın:**

   Terminal veya IDE üzerinden:

   ```bash
   flutter run
   ```

## Kullanım

Uygulama açıldığında ana ekranda bir TextField bulunur. Bu alana hava durumunu öğrenmek istediğiniz şehir adını girin.

"7 Günlük Hava Tahminini Getir" butonuna tıklayarak seçilen şehir için hava tahmin verilerini çekin.

Gelen veriler ekranın alt kısmında, her gün için tarih, maksimum/minimum sıcaklık ve hava durumu açıklaması (emoji ile birlikte) şeklinde listelenir.

Eğer beğendiğiniz bir şehir varsa, "Favorilere Ekle" butonuna tıklayarak favorilerinize ekleyin.

Sol üstteki Drawer menüsünü açarak favori şehirlerinize göz atabilir ve üzerine tıklayarak o şehrin hava durumunu tekrar getirebilirsiniz.

Ekranın üst kısmında, seçilen şehir ismi ve “Hava Durumu” ifadesi ile hangi şehrin verisinin görüntülendiği açıkça belirtilir.

## Proje Yapısı

### main.dart

Tüm uygulama kodları bu dosyada yer almaktadır. Ana bölümler:

- **API Çağrısı:** `fetchWeatherForecast(String city)` fonksiyonu, WeatherAPI’den 7 günlük hava tahmin verilerini çekmek için kullanılır.
- **Favorilere Ekleme:** `addToFavorites()` fonksiyonu, mevcut şehir favorilere eklenmemişse ekler.
- **Emoji Seçimi:** `getWeatherEmoji(String condition)` fonksiyonu, hava durumu açıklamasına göre uygun emojiyi seçer.
- **Tarih Formatlama:** `formatDate(String dateStr)` fonksiyonu, API’den gelen tarihi okunabilir bir formata dönüştürür.
- **UI:** `TextField`, butonlar, `Drawer` ve `ListView` kullanılarak kullanıcı arayüzü oluşturulmuştur.


