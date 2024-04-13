import 'package:astroguide_flutter/controllers/post_controller.dart';
import 'package:astroguide_flutter/models/category_model.dart';
import 'package:astroguide_flutter/models/post_model.dart';
import 'package:astroguide_flutter/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/post_field.dart';
import 'widgets/post_data.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostController _postController = Get.put(PostController());
  final TextEditingController _textController = TextEditingController();
  final List<CategoryModel> categoryList = [
    CategoryModel(id: 1, name: 'Sin Categoria'),
    CategoryModel(id: 2, name: 'Estrellas'),
    CategoryModel(id: 3, name: 'Lunas'),
    CategoryModel(id: 4, name: 'Planetas'),
  ];
  /*final List<PostModel> postList = [
    PostModel(content: 'kasdkaskskad', categoryId: 1),
    PostModel(content: 'kasdkaskskad', categoryId: 1),
    PostModel(content: 'kasdkaskskad', categoryId: 1),
    PostModel(content: 'kasdkaskskad', categoryId: 2),
    PostModel(content: 'kasdkaskskad', categoryId: 2),
    PostModel(content: 'kasdkaskskad', categoryId: 3),
    PostModel(content: 'kasdkaskskad', categoryId: 4),
    PostModel(content: 'kasdkaskskad', categoryId: 4),
  ];*/

  CategoryModel? selectedCategory;
  List<PostModel> filteredPosts = [];

  void _filterPostsByCategory() {
    if (selectedCategory == null) return;
    setState(() {
      filteredPosts.clear();
      //TODO DESCOMENTAR
      filteredPosts = [
        ..._postController.posts.value
            .where((post) => post.categoryId == selectedCategory!.id)
      ];
      /*filteredPosts = [
        ...postList.where((post) => post.categoryId == selectedCategory!.id)
      ];*/
    });
  }

  @override
  void initState() {
    super.initState();
    _postController.getAllPosts();
    //TODO RESTAURAR EN PRODUCCION
    filteredPosts = [..._postController.posts.value];
    /*filteredPosts = [...postList];*/
  }

  void showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Crear nuevo post',
              style: TextStyle(
                  fontSize: ScreenSize.width * 0.05,
                  fontWeight: FontWeight.w900),
            ),
            PostFIeld(
              hintText: '¿Que estas pensando?',
              controller: _textController,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                backgroundColor: const Color.fromARGB(255, 2, 40, 255),
                elevation: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 10,
                ),
              ),
              onPressed: () async {
                await _postController.createPost(
                    content: _textController.text.trim(),
                    categoryId: selectedCategory!.id);
                _textController.clear();
                _postController.getAllPosts();
              },
              child: Obx(() {
                return _postController.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Publicar',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 253, 253)),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AstroGuide',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FilledButton(
          onPressed: () {
            if (selectedCategory == null) return;

            showCreatePostDialog();
          },
          child: const Text('Publicar')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () async {
              await _postController.getAllPosts();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: ScreenSize.width,
                  child: Text(
                    'Escoje un categoria para buscar \nlos post de tu interes...',
                    style: TextStyle(fontSize: ScreenSize.width * 0.035),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: ScreenSize.absoluteHeight * 0.015,
                ),
                _buildStateDropdown(),
                SizedBox(
                  height: ScreenSize.absoluteHeight * 0.02,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('Publicaciones'),
                const SizedBox(
                  height: 20,
                ),
                Obx(() {
                  print(_postController.posts);
                  return _postController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredPosts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: PostData(
                                post: filteredPosts[index],
                              ),
                            );
                          },
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildStateDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenSize.height * 0.012,
        horizontal: ScreenSize.width * 0.05,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 95, 95, 95)),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          isExpanded: true,
          menuMaxHeight: ScreenSize.height * 0.4,
          value: selectedCategory?.id.toString(),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          elevation: 16,
          dropdownColor: Colors.white,
          style: TextStyle(
            color: const Color.fromARGB(255, 44, 44, 44),
            fontSize: ScreenSize.width * 0.036,
          ),
          underline: null,
          hint: const Text("Seleccione Categoria"),
          onChanged: (newValue) {
            setState(() {});
            //TODO TERMINAR
            if (newValue == null) return;
            selectedCategory = categoryList
                .where(
                  (category) => category.id == int.parse(newValue),
                )
                .first;
            debugPrint('Category ID: $newValue');
            _filterPostsByCategory();
          },
          items: categoryList //categoryController.categories.value
              .map<DropdownMenuItem<String>>(
                  (category) => DropdownMenuItem<String>(
                        value: category.id.toString(),
                        child: Text(category.name),
                      ))
              .toList(),
        ),
      ),
    );
  }
}
