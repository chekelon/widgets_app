import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InfiniteScrollScreen extends StatefulWidget {
  static const name = 'infinite_screen';

  const InfiniteScrollScreen({super.key});

  @override
  State<InfiniteScrollScreen> createState() => _InfiniteScrollScreenState();
}

class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {
  List<int> imagesIds = [1, 2, 3, 5];

  final ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool isMounted = true;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      //scrollController.position.pixels; --> posicion actual

      if (scrollController.position.pixels + 500 >=
          scrollController.position.maxScrollExtent) {
        //Load next page
        loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isMounted = false;
    scrollController.dispose();
  }

  Future loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));
    addFiveImages();
    isLoading = false;
    //TODO: revisar si esta montado el componente widget
    //Esta parte es muy importante ya que si salimos del screen y queremos redibujar el widget, este ya no existe
    //por lo que tronara la aplicacion
    if (!isMounted) return;
    setState(() {});
    moveScrollToBottom();
  }

  void addFiveImages() {
    final lastId = imagesIds.last;
    imagesIds.addAll([1, 2, 3, 4, 5].map((e) => lastId + e));
  }

  Future<void> onRefresh() async {
    //Algo a probar es que se marque mas el loader del onrefresh y al terminar la carga regrese a su posicion inicial
    //algo parecido al instagram

    //isLoading = true;
    //setState(() {});
    await Future.delayed(const Duration(seconds: 3));
    if (!isMounted) return;

    final lastId = imagesIds.last;
    //isLoading = false;
    imagesIds.clear();
    imagesIds.add(lastId + 1);
    addFiveImages();
    //isLoading = false;
    setState(() {});
  }

  void moveScrollToBottom() {
    if (scrollController.position.pixels + 150 <=
        scrollController.position.maxScrollExtent) return;

    scrollController.animateTo(scrollController.position.pixels + 120,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: RefreshIndicator(
            edgeOffset: 10,
            strokeWidth: 2,
            onRefresh: onRefresh,
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: imagesIds.length,
              itemBuilder: (context, index) {
                return FadeInImage(
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                    placeholder:
                        const AssetImage('assets/images/jar-loading.gif'),
                    image: NetworkImage(
                        'https://picsum.photos/id/${imagesIds[index]}/500/300'));
              },
            ),
          ),
        ),
        isLoading
            ? Positioned(
                right: (size.width / 2),
                bottom: 50,
                child: FadeIn(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle),
                    child: const CircularProgressIndicator(
                      strokeWidth: 6,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ))
            : const SizedBox()
      ]),
      floatingActionButton: FloatingActionButton(
          child: isLoading
              ? SpinPerfect(
                  infinite: true,
                  child: FadeIn(child: const Icon(Icons.refresh_rounded)))
              : const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop()),
    );
  }
}
