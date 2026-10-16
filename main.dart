import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

const siteUrl = 'https://yarlsri.tv/';
// Replace these with verified website section URLs or direct streaming URLs.
const liveUrl = 'https://5a1178b42cc03.streamlock.net:443/yarlsritv/yarlsritv/playlist.m3u8';
const newsUrl = siteUrl;
const videosUrl = siteUrl;
const primaryBlue = Color(0xFF093B85);
const primaryRed = Color(0xFFE51F32);

void main() => runApp(const YarlsriApp());

class YarlsriApp extends StatelessWidget {
  const YarlsriApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'YARLSRI TV',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue), scaffoldBackgroundColor: const Color(0xFFF6F8FC), appBarTheme: const AppBarTheme(backgroundColor: primaryBlue, foregroundColor: Colors.white)),
    home: const SplashPage(),
  );
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: primaryBlue,
    body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)), child: Image.asset('assets/images/logo.png', width: 245, fit: BoxFit.contain)),
      const SizedBox(height: 24),
      const Text('YARLSRI TV', style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      const Text('உங்கள் தமிழ் தொலைக்காட்சி', style: TextStyle(color: Colors.white70, fontSize: 16)),
      const SizedBox(height: 32),
      const CircularProgressIndicator(color: Colors.white),
    ])),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int tab = 0;
  static const names = ['முகப்பு', 'Live TV', 'செய்திகள்', 'வீடியோக்கள்', 'மேலும்'];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Row(children: [Container(color: Colors.white, padding: const EdgeInsets.all(4), child: Image.asset('assets/images/logo.png', width: 110, height: 34, fit: BoxFit.contain)), const SizedBox(width: 10), const Expanded(child: Text('YARLSRI TV', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)))]), actions: [IconButton(tooltip: 'Share', onPressed: () => Share.share(siteUrl), icon: const Icon(Icons.share))]),
    body: tab == 0 ? _dashboard() : tab == 1 ? const LiveTvPage() : tab == 4 ? _more() : WebsitePage(key: ValueKey(tab), url: tab == 2 ? newsUrl : videosUrl, title: names[tab]),
    bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (value) => setState(() => tab = value), destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.live_tv_outlined), selectedIcon: Icon(Icons.live_tv), label: 'Live TV'),
      NavigationDestination(icon: Icon(Icons.article_outlined), selectedIcon: Icon(Icons.article), label: 'News'),
      NavigationDestination(icon: Icon(Icons.play_circle_outline), selectedIcon: Icon(Icons.play_circle), label: 'Videos'),
      NavigationDestination(icon: Icon(Icons.menu), label: 'More'),
    ]),
  );
  Widget _dashboard() => ListView(padding: const EdgeInsets.all(18), children: [
    Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [primaryBlue, Color(0xFF1566B3)]), borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Image.asset('assets/images/logo.png', height: 62, fit: BoxFit.contain),
      const SizedBox(height: 22),
      const Text('உங்கள் தமிழ் தொலைக்காட்சி', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('நேரலை, செய்திகள் மற்றும் நிகழ்ச்சிகள்', style: TextStyle(color: Colors.white70)),
      const SizedBox(height: 18),
      FilledButton.icon(style: FilledButton.styleFrom(backgroundColor: primaryRed), onPressed: () => setState(() => tab = 1), icon: const Icon(Icons.play_arrow), label: const Text('LIVE TV பார்க்க')),
    ])),
    const SizedBox(height: 26),
    const Text('எங்கள் சேவைகள்', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.55, children: [
      _tile('Live TV', Icons.live_tv, primaryRed, 1),
      _tile('செய்திகள்', Icons.newspaper, primaryBlue, 2),
      _tile('வீடியோக்கள்', Icons.ondemand_video, const Color(0xFF138A57), 3),
      _tile('Website', Icons.language, const Color(0xFF7B3DC7), 4),
    ]),
    const SizedBox(height: 16),
    const Text('குறிப்பு: Live TV நேரடி HLS ஒளிபரப்பைப் பயன்படுத்துகிறது. News, Videos பகுதிகளுக்கான தனித்தனி URL-களை பின்னர் இணைக்கலாம்.', style: TextStyle(color: Colors.black54, fontSize: 12)),
  ]);
  Widget _tile(String label, IconData icon, Color color, int index) => InkWell(onTap: () => index == 4 ? _openSite() : setState(() => tab = index), borderRadius: BorderRadius.circular(16), child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color, size: 32), const SizedBox(height: 10), Text(label, style: const TextStyle(fontWeight: FontWeight.w700))])));
  Widget _more() => ListView(children: [
    ListTile(leading: const Icon(Icons.language), title: const Text('இணையதளம்'), onTap: _openSite),
    ListTile(leading: const Icon(Icons.share), title: const Text('பகிரவும்'), onTap: () => Share.share(siteUrl)),
    const ListTile(leading: Icon(Icons.info_outline), title: Text('YARLSRI TV'), subtitle: Text('Android & iOS • Version 1.1.0')),
  ]);
  Future<void> _openSite() async { final uri = Uri.parse(siteUrl); await launchUrl(uri, mode: LaunchMode.externalApplication); }
}

class WebsitePage extends StatefulWidget {
  final String url;
  final String title;
  const WebsitePage({super.key, required this.url, required this.title});
  @override
  State<WebsitePage> createState() => _WebsitePageState();
}
class _WebsitePageState extends State<WebsitePage> {
  late final WebViewController controller;
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) { if (mounted) setState(() { loading = true; error = null; }); },
        onPageFinished: (_) { if (mounted) setState(() => loading = false); },
        onWebResourceError: (e) { if (e.isForMainFrame == true && mounted) setState(() { loading = false; error = e.description; }); },
        onNavigationRequest: (request) {
          final uri = Uri.tryParse(request.url);
          if (uri == null) return NavigationDecision.prevent;
          if (uri.scheme == 'http' || uri.scheme == 'https') return NavigationDecision.navigate;
          launchUrl(uri, mode: LaunchMode.externalApplication);
          return NavigationDecision.prevent;
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }
  @override
  Widget build(BuildContext context) => Column(children: [
    Row(children: [const SizedBox(width: 12), Expanded(child: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold))), IconButton(tooltip: 'Back', icon: const Icon(Icons.arrow_back), onPressed: () async { if (await controller.canGoBack()) await controller.goBack(); }), IconButton(tooltip: 'Refresh', icon: const Icon(Icons.refresh), onPressed: () => controller.reload())]),
    Expanded(child: Stack(children: [
      WebViewWidget(controller: controller),
      if (loading) const LinearProgressIndicator(color: primaryRed),
      if (error != null) Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.wifi_off, size: 48), const SizedBox(height: 10), const Text('இணையதளத்தைத் திறக்க முடியவில்லை'), const SizedBox(height: 10), ElevatedButton(onPressed: () => controller.loadRequest(Uri.parse(widget.url)), child: const Text('மீண்டும் முயற்சி'))]))),
    ])),
  ]);
}


class LiveTvPage extends StatefulWidget {
  const LiveTvPage({super.key});
  @override
  State<LiveTvPage> createState() => _LiveTvPageState();
}

class _LiveTvPageState extends State<LiveTvPage> with WidgetsBindingObserver {
  VideoPlayerController? _player;
  bool _loading = true;
  String? _error;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  Future<void> _start() async {
    final generation = ++_generation;
    final old = _player;
    _player = null;
    if (mounted) setState(() { _loading = true; _error = null; });
    if (old != null) await old.dispose();
    if (!mounted || generation != _generation) return;
    final controller = VideoPlayerController.networkUrl(Uri.parse(liveUrl));
    _player = controller;
    try {
      await controller.initialize();
      if (!mounted || generation != _generation) return;
      await controller.setLooping(false);
      await controller.play();
      if (mounted && generation == _generation) setState(() => _loading = false);
    } catch (_) {
      if (mounted && generation == _generation) {
        setState(() { _loading = false; _error = 'நேரலை தற்போது இயங்கவில்லை. மீண்டும் முயற்சிக்கவும்.'; });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _player?.pause();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ++_generation;
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = _player;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Row(children: [const Icon(Icons.circle, size: 12, color: primaryRed), const SizedBox(width: 8), const Text('YARLSRI TV • LIVE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)), const Spacer(), IconButton(tooltip: 'Reload stream', onPressed: _start, icon: const Icon(Icons.refresh))]),
      const SizedBox(height: 12),
      ClipRRect(borderRadius: BorderRadius.circular(14), child: Container(color: Colors.black, child: AspectRatio(aspectRatio: player != null && player.value.isInitialized && player.value.aspectRatio > 0 ? player.value.aspectRatio : 16 / 9, child: _loading ? const Center(child: CircularProgressIndicator(color: Colors.white)) : _error != null ? Center(child: Padding(padding: const EdgeInsets.all(12), child: Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)))) : player != null && player.value.isInitialized ? VideoPlayer(player) : const SizedBox.shrink()))),
      const SizedBox(height: 12),
      if (_error != null) FilledButton.icon(onPressed: _start, icon: const Icon(Icons.refresh), label: const Text('மீண்டும் முயற்சி')),
      if (!_loading && _error == null && player != null) Row(children: [IconButton(tooltip: 'Play / Pause', icon: Icon(player.value.isPlaying ? Icons.pause_circle : Icons.play_circle), iconSize: 36, onPressed: () async { if (player.value.isPlaying) { await player.pause(); } else { await player.play(); } if (mounted) setState(() {}); }), IconButton(tooltip: 'Mute / Unmute', icon: Icon(player.value.volume == 0 ? Icons.volume_off : Icons.volume_up), onPressed: () async { await player.setVolume(player.value.volume == 0 ? 1 : 0); if (mounted) setState(() {}); }), const Spacer(), const Text('நேரடி ஒளிபரப்பு')]),
      const SizedBox(height: 18),
      const Text('YARLSRI TV நேரலை', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('இணைய இணைப்பு அவசியம். ஒளிபரப்பு கிடைப்பது சேவையகத்தின் நிலையைப் பொறுத்தது.'),
    ]);
  }
}
