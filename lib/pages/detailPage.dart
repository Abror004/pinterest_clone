import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/models/post_model.dart';
import 'package:pinterest/services/utils_service.dart';

class DetailPage extends StatefulWidget {
  static const String id = "DetailPage";

  List<int>? selectedIndex;
  List<Post>? posts;


  DetailPage({this.selectedIndex,this.posts});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  ScrollController _scrollController = ScrollController();
  List<Post> posts = [];
  List<int> selectedImageIndex = [];
  bool isLoading = false;
  bool isLoadPage = false;
  int postsLength = 0;

  // void fetchPosts() async {
  //   int pageNumber = (posts.length ~/ postsLength + 10);
  //   String? response =
  //   await Network.GET(Network.API_LIST, Network.paramsPage(pageNumber));
  //   List<Post> newPosts = Network.parseResponse(response!);
  //   posts.addAll(newPosts);
  //   setState(() {
  //     isLoadPage = false;
  //   });
  //   print("qo'wildi");
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedImageIndex.addAll(widget.selectedIndex!);
    posts.addAll(widget.posts!);
    // isLoading = true;
    // _showResponse(response);
    // _apiLoadList();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     setState(() {
    //       isLoadPage = true;
    //     });
    //     fetchPosts();
    //   }
    // });
  }

  // void _apiLoadList() async {
  //   await Network.GET(Network.API_LIST, Network.paramsEmpty())
  //       .then((response) => {_showResponse(response!)});
  // }

  // void _showResponse(String response) {
  //   setState(() {
  //     isLoading = false;
  //     posts = Network.parseResponse(response);
  //     posts.shuffle();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double imageHeight = posts[selectedImageIndex.last].height!.toDouble();
    double imageWidth = posts[selectedImageIndex.last].width!.toDouble();
    double iconSize = width / 20;
    return !isLoading ? Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          setState(() {
            if(selectedImageIndex.length == 1){
              Navigator.of(context).pushReplacementNamed('/Home_Page');
            }
            if(selectedImageIndex.length > 1){
              selectedImageIndex.removeLast();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) =>
                      DetailPage(
                        selectedIndex: selectedImageIndex, posts: posts,)));
            }
          });
          return false;
        },
        child: SafeArea(
            child: SingleChildScrollView(
          primary: true,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    Container(
                      height: imageHeight / (imageWidth / width),
                      width: imageWidth,
                      child: Stack(
                        children: [
                          Image(
                            image: NetworkImage(
                                posts[selectedImageIndex.last].urls.regular),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            alignment: Alignment.topRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  iconSize: iconSize,
                                  onPressed: () {
                                    // selectedImageIndex.add(selectedImageIndex.last+1);
                                    // selectImagePage(width,height);
                                  },
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                  ),
                                ),
                                // SizedBox(height: 1000,),
                                IconButton(
                                  iconSize: iconSize,
                                  splashRadius: 30,
                                  autofocus: true,
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.center_focus_weak,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: width / 30,
                      color: Colors.white,
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: width / 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: width / 20,
                            backgroundImage: NetworkImage(
                                posts[selectedImageIndex.last]
                                    .user!
                                    .profileImage!
                                    .large!),
                          ),
                          SizedBox(
                            width: width / 35,
                          ),
                          Expanded(
                            child: Text(
                              posts[selectedImageIndex.last].user!.name!,
                              style: TextStyle(fontSize: width / 30),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    posts[selectedImageIndex.last].description != null
                        ? Container(
                      color: Colors.white,
                            padding:
                                EdgeInsets.symmetric(horizontal: width / 15),
                            margin: EdgeInsets.symmetric(vertical: height / 60),
                            alignment: Alignment.center,
                            child: Text(
                              posts[selectedImageIndex.last].description,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                    posts[selectedImageIndex.last].altDescription != null ? Container(
                      color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: width / 15),
                            margin: EdgeInsets.symmetric(vertical: height / 60),
                            child: Text(
                              posts[selectedImageIndex.last].altDescription,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                    Container(
                      height: 80,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.chat_bubble),
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                minWidth: 80,
                                height: 60,
                                onPressed: () {},
                                shape: StadiumBorder(),
                                color: Colors.grey,
                                child: Text("Visit",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              MaterialButton(
                                minWidth: 80,
                                height: 60,
                                onPressed: () {},
                                shape: StadiumBorder(),
                                color: Colors.red,
                                child: Text("Save",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.share),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 0,
                      ),
                      child: Text(
                        "Comments",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.1),
                          radius: 25,
                          child: Text(
                            "A",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Add a comment",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: Text(
                        "More like this",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _scrollController,
                        crossAxisCount: 2,
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MaterialButton(
                            onPressed: () {
                              setState(() {
                                selectedImageIndex.add(index);
                              });
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailPage(selectedIndex: selectedImageIndex,posts: posts,)));
                            },
                            padding: EdgeInsets.all(0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    margin: EdgeInsets.all(5),
                                    decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    child: CachedNetworkImage(
                                      imageUrl: posts[index].urls.regular,
                                      placeholder: (context, url) => AspectRatio(
                                          aspectRatio: posts[index].width! / posts[index].height!,
                                          child: Container(
                                            color: Utils.getColorFromHex(posts[index].color!),
                                          )),
                                      errorWidget: (context, url, error) => AspectRatio(
                                          aspectRatio: posts[index].width! / posts[index].height!,
                                          child: Container(
                                            color: Utils.getColorFromHex(posts[index].color!),
                                          )),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    margin: EdgeInsets.only(bottom: width / 15, top: width / 100),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                          NetworkImage(posts[index].user!.profileImage!.large!),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            posts[index].user!.name!,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.topCenter,
                                          child: IconButton(
                                              padding: EdgeInsets.only(left: 5),
                                              alignment: Alignment.topCenter,
                                              splashRadius: 1,
                                              onPressed: () {},
                                              icon: Icon(Icons.more_horiz)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.transparent,
        focusElevation: 0,
        autofocus: false,
        focusColor: Colors.transparent,
        hoverElevation: 0,
        elevation: 0,
        onPressed: () {
          setState(() {
            if(selectedImageIndex.length == 1){
              Navigator.of(context).pushReplacementNamed('/Home_Page');
            }
            if(selectedImageIndex.length > 1){
              selectedImageIndex.removeLast();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) =>
                      DetailPage(
                        selectedIndex: selectedImageIndex, posts: posts,)));
            }
          });
        },
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    )
    : CircularProgressIndicator();
  }
}
