import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Kullanıcının girdiği şehir adı
  String cityName = '';
  // Favorilere eklenen şehirlerin listesi
  List<String> favorites = [];
  // 7 günlük hava tahminlerinin tutulduğu liste
  List<dynamic> forecastDays = [];
  // Şehir adını ekranda göstermek için (seçilen şehir)
  String? cityDisplayName;

  // WeatherAPI üzerinden 7 günlük tahmini çeker
  Future<void> fetchWeatherForecast(String city) async {
    // WeatherAPI API key'in
    const String apiKey = 'a5dccc1c2410450f86b162406250504';
    // 7 günlük tahmin endpoint'i
    String url =
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&lang=tr';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Türkçe karakter sorunu yaşamamak için utf8 ile decode ediyoruz
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          forecastDays = data['forecast']['forecastday'];
          cityDisplayName = data['location']['name'];
        });
      } else {
        setState(() {
          forecastDays = [];
          cityDisplayName = null;
        });
      }
  }

  // Favorilere ekleme: Eğer şehir zaten yoksa ekle
  void addToFavorites() {
    if (cityDisplayName != null && !favorites.contains(cityDisplayName)) {
      setState(() {
        favorites.add(cityDisplayName!);
      });
    }
  }

  // Hava durumuna göre emoji seçen fonksiyon
  String getWeatherEmoji(String condition) {
    final lower = condition.toLowerCase();

    // Yağmur / yağış
    if (lower.contains('yağmur') ||
        lower.contains('yagmur') ||
        lower.contains('yağış') ||
        lower.contains('yagis') ||
        lower.contains('sağanak') ||
        lower.contains('saganak')) {
      return '🌧';
    }
    // Kar
    else if (lower.contains('kar') || lower.contains('karlı')) {
      return '❄';
    }
    // Bulutlu / kapalı / parçalı bulutlu
    else if (lower.contains('bulut') ||
        lower.contains('kapalı') ||
        lower.contains('parçalı') ||
        lower.contains('az bulut')) {
      return '☁';
    }
    // Güneşli / açık
    else if (lower.contains('güneşli') ||
        lower.contains('gunesli') ||
        lower.contains('açık')) {
      return '☀';
    }
    // Fırtına / gök gürültülü
    else if (lower.contains('fırtına') ||
        lower.contains('firtina') ||
        lower.contains('gök gürültülü') ||
        lower.contains('gok gurultulu')) {
      return '⛈';
    }
    // Sis
    else if (lower.contains('sis')) {
      return '🌫';
    }
    return "";
  }

  String formatDate(String dateStr) {
    final parts = dateStr.split('-'); // [YYYY, MM, DD]
    if (parts.length == 3) {
      final year = parts[0];
      final month = parts[1];
      final day = parts[2];
      final monthsTr = [
        'Ocak',
        'Şubat',
        'Mart',
        'Nisan',
        'Mayıs',
        'Haziran',
        'Temmuz',
        'Ağustos',
        'Eylül',
        'Ekim',
        'Kasım',
        'Aralık'
      ];
      final monthIndex = int.parse(month) - 1;
      if (monthIndex >= 0 && monthIndex < 12) {
        final monthName = monthsTr[monthIndex];
        return '$day $monthName $year';
      }
    }
    return dateStr; // Herhangi bir hata olursa orijinal hali
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Tahmini',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hava Tahmini'),
        ),
        // Favori şehirleri göstermek için
        drawer: Drawer(
          child: Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    'Favoriler',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(favorites[index]),
                      onTap: () {
                        // Favoriden tıklandığında o şehrin hava tahminini getir
                        Navigator.pop(context); // Drawer'ı kapat
                        fetchWeatherForecast(favorites[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Şehir adı girişi için TextField
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Şehir Adı',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  cityName = value;
                },
              ),
              const SizedBox(height: 16.0),
              // 7 günlük tahmini getiren buton
              ElevatedButton(
                onPressed: () {
                  if (cityName.isNotEmpty) {
                    fetchWeatherForecast(cityName);
                  }
                },
                child: const Text('7 Günlük Hava Tahminini Getir'),
              ),
              const SizedBox(height: 16.0),
              // Eğer tahminler geldiyse, favorilere ekle butonunu göster
              if (cityDisplayName != null)
                ElevatedButton(
                  onPressed: favorites.contains(cityDisplayName)
                      ? null
                      : addToFavorites,
                  child: Text(
                    favorites.contains(cityDisplayName)
                        ? 'Favorilerde Var'
                        : 'Favorilere Ekle',
                  ),
                ),
              const SizedBox(height: 16.0),
              // Seçilen şehrin hava durumu bilgisini göster
              if (cityDisplayName != null)
                Text(
                  "$cityDisplayName Hava Durumu",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 24.0),
              // Tahmin verileri geldiyse liste halinde göster
              if (forecastDays.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: forecastDays.length,
                    itemBuilder: (context, index) {
                      var day = forecastDays[index];
                      String date = day['date'];
                      double maxTemp = day['day']['maxtemp_c'];
                      double minTemp = day['day']['mintemp_c'];
                      String condition = day['day']['condition']['text'];

                      // Hava durumu açıklamasına göre emoji seç
                      String emoji = getWeatherEmoji(condition);

                      return Card(
                        color: Colors.lightBlue[50],
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            formatDate(date),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Max: $maxTemp °C, Min: $minTemp °C\nDurum: $emoji $condition',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
