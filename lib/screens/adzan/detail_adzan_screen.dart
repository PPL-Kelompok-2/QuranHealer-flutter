import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:quranhealer/screens/adzan/detail_adzan_new_screen.dart';
import 'package:quranhealer/screens/adzan/detail_adzan_view_model.dart';
import 'package:quranhealer/screens/adzan/widget/adzan_time.dart';
import 'package:quranhealer/screens/error/error_screen.dart';

class DetailAdzan extends StatefulWidget {
  final String id;
  final String nama;
  const DetailAdzan({super.key, required this.id, required this.nama});

  @override
  State<DetailAdzan> createState() => _DetailAdzanState();
}

class _DetailAdzanState extends State<DetailAdzan>
    with AutomaticKeepAliveClientMixin<DetailAdzan> {
  late Future<dynamic> detailDataFuture;

  @override
  void initState() {
    super.initState();

    final detailAdzanViewModel =
        Provider.of<DetailAdzanViewModel>(context, listen: false);
    String currentDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
    detailDataFuture = detailAdzanViewModel.getAdzanDetail("1501", currentDate);

    // ignore: unused_local_variable
    String formattedTime = DateFormat.Hms().format(DateTime.now());
  }

  Stream<DateTime> clockStream() {
    // ignore: prefer_const_constructors
    return Stream.periodic(Duration(seconds: 1), (i) => DateTime.now());
  }

  String getHariIni() {
    var now = DateTime.now();
    var formatter = DateFormat('EEEE', 'id');
    String formatted = formatter.format(now);
    return formatted;
  }

  String getTanggalSekarang() {
    var now = DateTime.now();
    var formatter = DateFormat('dd MMM yyyy', 'id_ID');
    String formatted = formatter.format(now);
    return formatted;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    initializeDateFormatting('id_ID', null);
    return Consumer<DetailAdzanViewModel>(
      builder: (
        context,
        provider,
        _,
      ) {
        final detail = provider.detailAdzan;
        return StreamBuilder<DateTime>(
          stream: clockStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final formattedTime = DateFormat.Hms().format(snapshot.data!);
              return FutureBuilder(
                future: detailDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return ErrorScreen(
                      onRefreshPressed: () {
                        String currentDate =
                            DateFormat('yyyy/MM/dd').format(DateTime.now());
                        setState(
                          () {
                            detailDataFuture =
                                provider.getAdzanDetail("1501", currentDate);
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasData) {
                    return Container();
                  } else {
                    if (detail?.jadwal.dhuha == null) {
                      return ErrorScreen(
                        onRefreshPressed: () {
                          String currentDate =
                              DateFormat('yyyy/MM/dd').format(DateTime.now());
                          setState(
                            () {
                              detailDataFuture =
                                  provider.getAdzanDetail("1501", currentDate);
                            },
                          );
                        },
                      );
                    } else {
                      return ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailNewAdzan(
                                      id: widget.id,
                                      nama: widget.nama,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      width: 3,
                                      color: Color.fromARGB(255, 123, 151, 151),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "Lihat di halaman baru",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 123, 151, 151),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Icon(
                                        Icons.chevron_right,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            decoration: BoxDecoration(
                              // color: const Colors.,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(0xFF0E6969)
                                            .withOpacity(0.8),
                                        const Color(0xFF0E6969)
                                            .withOpacity(0.9),
                                        const Color(0xFF0E6969),
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.nama,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              formattedTime,
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              getHariIni(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              getTanggalSekarang(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          child: Image.asset(
                                            'assets/icons/adzan/mosque.png',
                                            height: 120,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      AdzanTime(
                                        jadwalShalat: 'Imsak',
                                        waktuShalat: '${detail?.jadwal.imsak}',
                                      ),
                                      AdzanTime(
                                        jadwalShalat: 'Subuh',
                                        waktuShalat: '${detail?.jadwal.subuh}',
                                      ),
                                      AdzanTime(
                                        jadwalShalat: 'Terbit',
                                        waktuShalat: '${detail?.jadwal.terbit}',
                                      ),
                                      AdzanTime(
                                        jadwalShalat: 'Dhuha',
                                        waktuShalat: '${detail?.jadwal.dhuha}',
                                      ),
                                      AdzanTime(
                                        jadwalShalat: 'Dzuhur',
                                        waktuShalat: '${detail?.jadwal.dzuhur}',
                                      ),
                                      AdzanTime(
                                        jadwalShalat: 'Ashar',
                                        waktuShalat: '${detail?.jadwal.ashar}',
                                      ),
                                      AdzanTime(
                                        jadwalShalat: 'Maghrib',
                                        waktuShalat:
                                            '${detail?.jadwal.maghrib}',
                                      ),
                                      AdzanTime(
                                        jadwalShalat: 'Isya',
                                        waktuShalat: '${detail?.jadwal.isya}',
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/adzan");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          const Color(0xFF0E6969)
                                              .withOpacity(0.8),
                                          const Color(0xFF0E6969)
                                              .withOpacity(0.9),
                                          const Color(0xFF0E6969),
                                        ],
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Ganti Kota Adzan",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }
}
