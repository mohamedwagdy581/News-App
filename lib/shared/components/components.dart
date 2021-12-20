import 'package:flutter/material.dart';
import 'package:news_app/modules/web_view/web_view_screen.dart';

Widget buildArticleItem(
  article,
  context,
) =>
    InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(
              url: article['url'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage('${article['urlToImage']}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: SizedBox(
                height: 120.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${article['title']} ',
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

Widget articleBuilder(list, context, {isSearch = false}) {
  return list.length > 0
      ? ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              buildArticleItem(list[index], context),
          separatorBuilder: (context, index) => const Divider(
            height: 10.0,
            thickness: 3.0,
          ),
          itemCount: list.length,
        )
      : isSearch
          ? Container()
          : const Center(
              child: CircularProgressIndicator(),
            );
}

// Default TextFormField
Widget defaultTextField({
  required IconData prefix,
  required String lable,
  required Function() onTap,
  String? Function(String?)? validate,
  String? Function(String?)? onChange,
  TextEditingController? controller,
  TextInputType? keyboardType,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      validator: validate,
      keyboardType: keyboardType,
      onTap: onTap,
      onChanged: onChange,
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: lable,
        prefixIcon: Icon(prefix),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
