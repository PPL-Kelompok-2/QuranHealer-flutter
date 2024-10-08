import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:quranhealer/screens/error/error_screen.dart';
import 'package:quranhealer/screens/quran/detail_quran_view_model.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

import 'package:quranhealer/screens/quran/widgets/ayat_item.dart';

class DetailSurahScreens extends StatefulWidget {
  final int nomor;
  final String namaLatin;
  final String arti;
  final int jumlahAyat;
  final String tempatTurun;
  final List quran;
  const DetailSurahScreens({
    super.key,
    required this.nomor,
    required this.arti,
    required this.jumlahAyat,
    required this.namaLatin,
    required this.tempatTurun,
    required this.quran,
  });

  @override
  State<DetailSurahScreens> createState() => _DetailSurahScreensState();
}

class _DetailSurahScreensState extends State<DetailSurahScreens>
    with SingleTickerProviderStateMixin {
  var bismillah = true;
  late Future<dynamic> detailDataFuture;
  final ScrollController _controller = ScrollController();
  final TextEditingController searchAyatControler = TextEditingController();
  late List<double> ayahHeights;

  @override
  void initState() {
    super.initState();

    final detailViewModel =
        Provider.of<DetailSurahViewModel>(context, listen: false);

    detailDataFuture = detailViewModel.getSurahDetail(widget.nomor);

    // untuk Search Surah
    ayahHeights = List<double>.generate(widget.jumlahAyat, (index) => 0.0);

    //Untuk Menghentikan Audio saat selesai
    audioPlayer.onPlayerStateChanged.listen(
      (event) {
        switch (event) {
          case PlayerState.completed:
            setState(
              () {
                playingAyatIndex = -1; // Mengubah isPlaying jadi false
              },
            );
            break;
          default:
            break;
        }
      },
    );
  }

  @override
  void dispose() {
    searchAyatControler.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  // open a dialog to add note
  void openSearchBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: searchAyatControler,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Cari Ayat...',
            prefix: const Icon(Icons.search),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Color(0xFF7E7777),
              ),
            ),
          ),
        ),
        actions: [
          FractionallySizedBox(
            widthFactor: 1.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                int? nomorAyatTujuan = int.tryParse(searchAyatControler.text);
                _scrollToAyah(nomorAyatTujuan!);
                FocusScope.of(context).unfocus();

                Navigator.pop(context);
              },
              child: const Text("Search Ayat"),
            ),
          ),
        ],
      ),
    );
  }

  // Untuk Search Ayat
  void _scrollToAyah(int ayahNumber) {
    double offset = ayahHeights
        .getRange(0, ayahNumber)
        .fold(0, (sum, height) => sum + height);

    _controller.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  //Untuk Play Audio
  AudioPlayer audioPlayer = AudioPlayer();
  int playingAyatIndex = -1;

  void playAyat(int index, String audioUrl) async {
    if (playingAyatIndex == index) {
      await audioPlayer.stop();
      setState(() {
        playingAyatIndex = -1;
      });
    } else {
      await audioPlayer.stop();
      await audioPlayer.play(UrlSource(audioUrl));
      setState(() {
        playingAyatIndex = index;
      });
    }
  }

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailSurahViewModel>(
      builder: (
        context,
        provider,
        _,
      ) {
        final detail = provider.detailSurah;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.namaLatin,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFF186D68),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${widget.nomor}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        widget.namaLatin,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        widget.arti,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        '${widget.tempatTurun}, ${widget.jumlahAyat} Ayat',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF9A9090,
                    ).withOpacity(0.08),
                  ),
                  child: FutureBuilder(
                    future: detailDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return ErrorScreen(
                          onRefreshPressed: () {
                            setState(
                              () {
                                detailDataFuture =
                                    provider.getSurahDetail(widget.nomor);
                              },
                            );
                          },
                        );
                      } else if (!snapshot.hasData) {
                        return Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16, bottom: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailSurahScreens(
                                                nomor: detail!
                                                    .suratSebelumnya!.nomor,
                                                arti: widget
                                                    .quran[detail
                                                            .suratSebelumnya!
                                                            .nomor -
                                                        1]
                                                    .arti,
                                                jumlahAyat: widget
                                                    .quran[detail
                                                            .suratSebelumnya!
                                                            .nomor -
                                                        1]
                                                    .jumlahAyat,
                                                namaLatin: detail
                                                    .suratSebelumnya!.namaLatin,
                                                tempatTurun: widget
                                                    .quran[detail
                                                            .suratSebelumnya!
                                                            .nomor -
                                                        1]
                                                    .tempatTurun,
                                                quran: widget.quran),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 6),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: detail?.suratSebelumnya == null
                                              ? const Color(0xFFB8C2B8)
                                              : const Color(0xFF186D68),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: detail?.suratSebelumnya == null
                                            ? const SizedBox(
                                                child: Icon(
                                                  Icons.block,
                                                  color: Color(0xFFB8C2B8),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  const Icon(
                                                    Icons.chevron_left,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    "${detail!.suratSebelumnya?.namaLatin}",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailSurahScreens(
                                                nomor: detail!
                                                    .suratSelanjutnya!.nomor,
                                                arti: widget
                                                    .quran[detail
                                                            .suratSelanjutnya!
                                                            .nomor -
                                                        1]
                                                    .arti,
                                                jumlahAyat: widget
                                                    .quran[detail
                                                            .suratSelanjutnya!
                                                            .nomor -
                                                        1]
                                                    .jumlahAyat,
                                                namaLatin: detail
                                                    .suratSelanjutnya!
                                                    .namaLatin,
                                                tempatTurun: widget
                                                    .quran[detail
                                                            .suratSelanjutnya!
                                                            .nomor -
                                                        1]
                                                    .tempatTurun,
                                                quran: widget.quran),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 6),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color:
                                              detail?.suratSelanjutnya == null
                                                  ? const Color(0xFFB8C2B8)
                                                  : const Color(0xFF186D68),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: detail?.suratSelanjutnya == null
                                            ? Container(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: const Icon(
                                                  Icons.block,
                                                  color: Color(0xFFB8C2B8),
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "${detail!.suratSelanjutnya?.namaLatin}",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.all(0),
                                                    child: Icon(
                                                      Icons.chevron_right,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: InkWell(
                                      onTap: openSearchBox,
                                      child: const Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  bismillah
                                      ? const Column(
                                          children: [
                                            Text(
                                              "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ",
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Color(0xFFA7711F),
                                              ),
                                            ),
                                            Text(
                                              "bismillāhir-raḥmānir-raḥīm(i).",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFA7711F),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              "Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.",
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                      : const Text(""),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: detail?.ayat.length,
                                    itemBuilder: (context, index) {
                                      final isPlaying =
                                          playingAyatIndex == index;
                                      return detail?.ayat[index].teksArab !=
                                              "بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ"
                                          ? AyatItem(
                                              index: index,
                                              onBuild: (height) {
                                                ayahHeights[index] = height;
                                              },
                                              nomorAyat:
                                                  detail!.ayat[index].nomorAyat,
                                              textIndonesia: detail
                                                  .ayat[index].teksIndonesia,
                                              textLatin:
                                                  detail.ayat[index].teksLatin,
                                              textArab:
                                                  detail.ayat[index].teksArab,
                                              isPlaying: isPlaying,
                                              onPlayToggle: (bool isPlaying) {
                                                playAyat(
                                                    index,
                                                    detail.ayat[index]
                                                        .audio["02"]!);
                                              },
                                            )
                                          : Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return ErrorScreen(
                          onRefreshPressed: () {
                            setState(
                              () {
                                detailDataFuture =
                                    provider.getSurahDetail(widget.nomor);
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
