import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/models/post_model.dart';
import 'package:pinterest/pages/detailPage.dart';
import 'package:pinterest/services/http_service.dart';
import 'package:pinterest/services/utils_service.dart';

class Home_Page extends StatefulWidget {
  static const String id = "/Home_Page";

  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  TextEditingController _controller = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  int postsLength = 0;
  bool typing = false;

  // List list = ["For you", "Today", "Following", "Health", "Recipes"];
  List list = ["All"];
  List floatList = [
    Icons.home,
    Icons.search,
    CupertinoIcons.chat_bubble_text,
  ];

  List gridList = [
    "assets/images/ic_header.jpg",
    "assets/images/ic_hotel0.jpg",
    "assets/images/ic_hotel1.jpg",
    "assets/images/ic_hotel3.jpg",
    "assets/images/im_car1.jpg",
    "assets/images/im_car0.jpg",
    "assets/images/ic_hotel4.jpg",
    "assets/images/im_car2.jpg",
    "assets/images/im_party.jpeg",
    "assets/images/im_car4.jpg",
    "assets/images/image_1.jpeg",
    "assets/images/img.jpg",
    "assets/images/photo_2021-06-16_18-18-25.jpg",
    "assets/images/photo_2021-06-16_18-18-30.jpg",
    "assets/images/ic_hotel2.jpg",
  ];
  int index = 10;
  int _selectedIndex = 0;
  int _selectedPage = 0;

  bool isLoading = false;
  bool isLoadPage = false;
  String data = 'No data';
  List<Post> posts = [];
  int page = 0;
  double height = 0;
  double width = 0;

  List<int> selectedImageIndex = [];

  void fetchPosts() async {
    int pageNumber = (posts.length);
    String? response =
        await Network.GET(Network.API_LIST, Network.paramsPage(pageNumber));
    List<Post> newPosts = Network.parseResponse(response!);
    posts.addAll(newPosts);
    setState(() {
      isLoadPage = false;
    });
  }

  void fetchPosts2() async {
    int pageNumber = (posts.length);
    String? response =
        await Network.GET(Network.API_LIST, Network.paramsPage(pageNumber));
    List<Post> newPosts = Network.parseSearchParse(response!);
    posts.addAll(newPosts);
    setState(() {
      isLoadPage = false;
    });
  }

  void _apiLoadList({String? text = null}) async {
    text == null ? await Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {_showResponse(response!)}) :
    await Network.GET(Network.API_LIST_search, Network.paramsSearch(text, 1))
        .then((response) => {_showResponse2(response!)});
  }

  void _showResponse2(String response) {
    setState(() {
      isLoading = false;
      posts = Network.parseSearchParse(response);
      posts.shuffle();
    });
  }

  void _showResponse(String response) {
    setState(() {
      isLoading = false;
      posts = Network.parseResponse(response);
      posts.shuffle();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    _apiLoadList();
    _controller.text = '';
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          isLoadPage = false;
        }
      });
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadPage = true;
        });
        if(_controller.text == ''){
          fetchPosts();
        }else{
          fetchPosts2();
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }


  Widget homeBody(index) {
    return MaterialButton(
      onPressed: () {
        setState(() {
          selectedImageIndex.add(index);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>
                  DetailPage(
                    selectedIndex: selectedImageIndex, posts: posts,)));
        });
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
                placeholder: (context, url) =>
                    AspectRatio(
                        aspectRatio: posts[index].width! / posts[index].height!,
                        child: Container(
                          color: Utils.getColorFromHex(posts[index].color!),
                        )),
                errorWidget: (context, url, error) =>
                    AspectRatio(
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
  }

  @override
  Widget build(BuildContext context) {
    // if(_selectedPage == 1) {
    //   Navigator.of(context).pushNamed('SearchPage');
    // }
    if (_selectedPage == 0) {
      return Scaffold(
        body: SafeArea(
          child: !isLoading && posts.length >= 10
          ? SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: 90,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return MaterialButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          shape: StadiumBorder(),
                          color: _selectedIndex == index
                              ? Colors.black
                              : Colors.white,
                          elevation: 0,
                          child: Text(
                            list[index],
                            style: TextStyle(
                                color: _selectedIndex == index
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 84,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 2));
                        _apiLoadList();
                      },
                      child: MasonryGridView.count(
                        controller: _scrollController,
                        crossAxisCount: 2,
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return homeBody(index);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ),
        floatingActionButton: floatButtons(),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.miniCenterFloat,
      );
    }
    else if (_selectedPage == 1) {
      return searchPage(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
    }
    else if (_selectedPage == 2) {
      return categoriesPage(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
    }
    else {
      return profilePage(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
    }
  }

  Widget searchPage(double width, double height) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: WillPopScope(
            onWillPop: () async {
              setState(() {
                _controller.clear();
                typing = false;
              });
              return false;
            },
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: TextField(
                            controller: _controller,
                            showCursor: false,
                            textAlignVertical: TextAlignVertical.bottom,
                            onTap: () {
                              setState(() {
                                typing = !typing;
                              });
                            },
                            onEditingComplete: () {
                              setState(() {
                                _apiLoadList(text: _controller.text);
                              });
                            },
                            onSubmitted: (context) {
                              setState(() {
                                _apiLoadList(text: _controller.text);
                              });
                            },
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.grey.shade300,
                              filled: true,
                              prefixIcon: Icon(
                                CupertinoIcons.search,
                                color: Colors.black,
                              ),
                              suffixIcon: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                              hintText: "Search for ideas",
                              hintStyle: TextStyle(color: Colors.black45),
                            ),
                          ),
                        ),
                      ),
                      if(typing)
                      SizedBox(
                        width: typing ? 0 : 10,
                      ),
                      if(typing)
                        TextButton(
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            typing = false;
                          });
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // #SearchPageBody
                Expanded(
                  child: MasonryGridView.count(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return homeBody(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: floatButtons(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  List appBarCategories = ["Updates", "Messages"];
  int categoriesSelectedIndex = 1;
  List categoriesBody = [
    [
      [4, 2],
      [4, 2],
      [4, 2],
      [4, 2],
    ],
    [
      [4, 4],
      [2, 2],
      [2, 2],
      [2, 2],
      [2, 2],
    ],
    [
      [2, 2],
      [2, 2],
      [2, 2],
      [2, 2],
      [4, 2],
      [4, 2],
    ],
  ];

  Widget categoriesPage(double width, double height) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                width: 185,
                margin: EdgeInsets.only(bottom: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: appBarCategories.length,
                  itemBuilder: (context, index) {
                    return MaterialButton(
                      minWidth: 0,
                      onPressed: () {
                        setState(() {
                          categoriesSelectedIndex = index;
                        });
                      },
                      shape: StadiumBorder(),
                      color: categoriesSelectedIndex == index
                          ? Colors.black
                          : Colors.white,
                      elevation: 0,
                      child: Text(
                        appBarCategories[index],
                        style: TextStyle(
                            color: categoriesSelectedIndex == index
                                ? Colors.white
                                : Colors.black),
                      ),
                    );
                  },
                ),
              ),
              categoriesSelectedIndex == 0
                  ? Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          // #news
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  "Your Pin was Saved 2 times ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: width / 30)),
                                          TextSpan(
                                              text: "2d",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: width / 36.5)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: width / 15,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "13 more ideas for.your  board Food ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: width / 30),
                                          ),
                                          TextSpan(
                                              text: "2d",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: width / 36.5)),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),

                          // #circlePhotos
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: (width / 10).toDouble(),
                                      width: (width / 10).toDouble(),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: width / 15),
                                      height: (width / 10).toDouble(),
                                      width: (width / 10).toDouble(),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: width / 8.5),
                                      height: (width / 10).toDouble(),
                                      width: (width / 10).toDouble(),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(width.toString()),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      height: height,
                      width: width,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Share Ideas with\nyour friends\n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width / 15),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: width / 10),
                            child: TextField(
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                prefixIcon: Icon(
                                  CupertinoIcons.search,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  maxWidth: 50,
                                  minWidth: 50,
                                ),
                                hintText: "Search by name or email",
                                hintStyle: TextStyle(
                                    color: Colors.black45, fontSize: 16),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: width / 30, vertical: width / 40),
                            padding: EdgeInsets.only(bottom: width / 3),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: width / 20,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.group,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                "Sync contacts",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              if (categoriesSelectedIndex == 0)
                for (int i = 0; i < categoriesBody.length; i++)
                  Container(
                    height: (width - 20) / 2,
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: StaggeredGrid.count(
                      crossAxisCount: 8,
                      crossAxisSpacing: width / 200,
                      mainAxisSpacing: width / 200,
                      children: [
                        for (int ii = 0; ii < categoriesBody[i].length; ii++)
                          StaggeredGridTile.count(
                            crossAxisCellCount: categoriesBody[i][ii][0],
                            mainAxisCellCount: categoriesBody[i][ii][1],
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(gridList[ii]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: i == 0
                                  ? Text(
                                      "Title Name Here",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width / 30,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Container(),
                            ),
                          ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: floatButtons(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  List profileBody = [
    [
      [2, 2],
      [1, 1],
      [1, 1]
    ],
    [
      [2, 2],
      [1, 1],
      [1, 1]
    ],
    [
      [2, 2],
      [1, 1],
      [1, 1]
    ],
  ];

  Widget profilePage(double width, double height) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                color: Colors.black,
              )),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: width / 12, bottom: 20),
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.1),
                radius: width / 6,
                child: Text(
                  "A",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Text(
              "Abror Rajabov",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "@abrorrajabov004",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "0 followers . 0 following",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Container(
              height: 45,
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      showCursor: false,
                      textAlignVertical: TextAlignVertical.bottom,
                      onTap: () {
                        setState(() {
                          typing = !typing;
                        });
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          typing = !typing;
                        });
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.black.withOpacity(0.1),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        prefixIconConstraints:
                            BoxConstraints(maxWidth: 40, minWidth: 40),
                        hintText: "Search your Pins",
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {},
                    icon: Icon(
                      Icons.add,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              child: SingleChildScrollView(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "You haven't saved any ideas yet",
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      MaterialButton(
                        minWidth: 100,
                        height: 60,
                        elevation: 0,
                        onPressed: () {},
                        color: Colors.black.withOpacity(0.1),
                        shape: StadiumBorder(),
                        child: Text(
                          "Find ideas",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomSheet(
                onClosing: () {},
                builder: (context) {
                  return Container();
                }),
          ],
        ),
      ),
      floatingActionButton: floatButtons(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  Widget floatButtons() {
    return Container(
      width: 230,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1),
            blurStyle: BlurStyle.solid,
            blurRadius: 3,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: floatList.length + 1,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: index != 3 ? 4 : 0),
            child: index < 3
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        if(_selectedPage == 0 && index == 1){
                          _apiLoadList();
                        }
                        if(index == 1){
                          _controller.text = '';
                        }
                        _selectedPage = index;
                      });
                    },
                    icon: Icon(
                      floatList[index],
                      color:
                          _selectedPage == index ? Colors.black : Colors.grey,
                      size: _selectedPage == index ? 30 : 25,
                    ),
                  )
                : MaterialButton(
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.all(0),
                    minWidth: 60,
                    onPressed: () {
                      setState(() {
                        _selectedPage = index;
                      });
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blue,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
