import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:collection/collection.dart';
import 'AppColors.dart';
import 'AppStyles.dart';
import 'Product.dart';
import 'global.dart';

main() {
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.black,
        fontFamily: 'Raleway',
      ),
      home: HomePage(),
    ),
  );
} //ef

//first loading of products or not
bool flag = true;
int activeTab = 0;
Widget? home;
Widget? allProduct;
Widget? categories;
List<Widget> tabs = [];

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    //make 3 tabs
    home = HomeScreen();
    allProduct = AllProductScreen();
    categories = CategoriesScreen();
    //make tab references
    tabs = [home!, allProduct!, categories!];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      //body
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: tabs[activeTab],
      ),
      //Bottom Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'All Products',
            backgroundColor: AppColors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
            backgroundColor: AppColors.black,
          ),
        ],
        currentIndex: activeTab,
        selectedItemColor: AppColors.black,
        onTap: (index) {
          setState(() {
            activeTab = index;
            getTotalQty();
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //move to new creen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartScreen(),
            ),
          );
        },
        backgroundColor: AppColors.white,
        child: Badge(
          badgeColor: AppColors.black,
          badgeContent: Padding(
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 4),
            child: Text(
              cartTotalQty.toString(),
              style: TextStyle(color: AppColors.white),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 3),
            child: Icon(
              Icons.shopping_cart,
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  } //ef

} //ec

//====> class: HomeScreen
class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> featuredProducts = [];
  List<Product> newArrivalProducts = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          //headings
          const Text(
            "Explore",
            style: AppStyles.mainHeadingStyle,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2),
            child: Text(
              "Cool fashions for you",
              style: AppStyles.subHeadingStyle,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/flash-offer.jpg',
                    ),
                    fit: BoxFit.cover,
                  )),
              height: 55,
              width: double.infinity,
              child: null,
            ),
          ),

          //Featured heading
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Featured",
                  style: AppStyles.secondaryHeadingStlye,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      // activeTab =
                    });
                  },
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text("See all"),
                      const Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppColors.black,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          //Featured listview
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FutureBuilder<List<Product>>(
                future: getProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    //return progress
                    return const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    getFeatured(snapshot.data!);
                    //return widget
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredProducts.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              //move to new creen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    product: featuredProducts[i],
                                    tag: '${featuredProducts[i].id} featured',
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(
                              product: featuredProducts[i],
                              tag: '${featuredProducts[i].id} featured',
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),

          //New Arrival heading
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "New Arrival",
                  style: AppStyles.secondaryHeadingStlye,
                ),
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "See all",
                      style: AppStyles.seeAllStyle,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 3),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: AppColors.black,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          //New Arrival listview
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FutureBuilder<List<Product>>(
                future: getProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    //return progress
                    return const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    getNewArrivals(snapshot.data!);
                    //return widget
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: newArrivalProducts.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              //move to new creen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    product: newArrivalProducts[i],
                                    tag:
                                        '${newArrivalProducts[i].id} new arrival',
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(
                              product: newArrivalProducts[i],
                              tag: '${newArrivalProducts[i].id} new arrival',
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Product>> getProducts() async {
    if (flag) {
      var url = "http://192.168.183.1:1880/shirtstore";
      var jsonText = await get(url);
      var list = json.decode(jsonText.toString()) as List;
      products = list.map((e) => Product.fromMap(e)).toList();
      return products;
    }
    //if not first loading then return the global "products"
    return products;
  } //ef

  Future<Object> get(url) async {
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return res.body;
    } else {
      print(res.statusCode);
      return Future<Null>.value(null);
    }
  } //ef

  getFeatured(List<Product> products) {
    featuredProducts.clear();
    for (var p in products) {
      if (p.type == "featured") {
        featuredProducts.add(p);
      }
    }
  }

  getNewArrivals(List<Product> products) {
    newArrivalProducts.clear();
    for (var p in products) {
      if (p.type == "new arrival") {
        newArrivalProducts.add(p);
      }
    }
  }
}

class ProductCard extends StatelessWidget {
  Product product;
  String tag;
  ProductCard({Key? key, required this.product, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 140,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7.5),
              child: Container(
                color: AppColors.primaryBackgroundColor,
                child: Hero(
                  tag: tag,
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: AppStyles.cardNameStyle,
                ),
                Text(
                  "฿${AppStyles.deciPriceFormat.format(product.price)}",
                  style: AppStyles.cardPriceStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} //ec

//===> class: DetailScreen
class DetailScreen extends StatefulWidget {
  Product product;
  String tag;
  DetailScreen({Key? key, required this.product, required this.tag})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.detailScreenBackgroundColor,
      body: Column(
        children: [
          Stack(
            children: [
              //product image
              SizedBox(
                width: double.infinity,
                height: 440,
                child: Hero(
                  tag: widget.tag,
                  child: Image.asset(
                    widget.product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //back button
              Positioned(
                top: 40,
                left: 15,
                child: GestureDetector(
                  onTap: () {
                    //move back to home page
                    Navigator.pop(context);
                  },
                  child: const CircleAvatar(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //product details
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Column(
                  children: [
                    //product name
                    Text(
                      widget.product.name,
                      style: AppStyles.productNameStyle,
                    ),
                    //product price
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "฿${AppStyles.deciPriceFormat.format(widget.product.price)}",
                        style: AppStyles.productPriceStyle,
                      ),
                    ),
                    //action buttons
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 30,
                            onPressed: () {
                              setState(() {
                                decQty();
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              productQty.toString(),
                              style: AppStyles.productQtyStyle,
                            ),
                          ),
                          IconButton(
                            iconSize: 30,
                            onPressed: () {
                              setState(() {
                                incQty();
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          addToCart(widget.product);
                          getTotalQty();
                        });
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        child: Text(
                          'Add to Cart',
                          style: AppStyles.cartBtnStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } //ef

//qty to be added to the cart
  int productQty = 0;

  void incQty() {
    productQty++;
  } //ef

  void decQty() {
    if (productQty > 0) {
      productQty--;
    }
  } //ef

  void addToCart(Product product) {
    var productFound = cart.firstWhereOrNull((p) => product.id == p.id);
    if (productFound == null) {
      //add product to the cart
      cart.add(product);
    }
    //add qty to the product object qty
    product.qty += productQty;

    //this part is for added to cart confirmation
    Timer _timer;
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          _timer = Timer(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });

          return const AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            backgroundColor: AppColors.white,
            content: Text('Added to cart'),
          );
        });
  } //ef

} //ec

//====> class: CartScreen
class CartScreen extends StatefulWidget {
  CartScreen();

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text("Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(6, 0, 6, 5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.black),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      width: 210,
                      child: const Text("Description"),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      width: 120,
                      child: const Text("Quantity"),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 22.5),
                      width: 60,
                      child: const Text("Total"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 15,
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: cart.length,
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //image
                        Container(
                          height: 65,
                          width: 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(cart[i].image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        //product details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 140,
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cart[i].name),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      AppStyles.deciPriceFormat
                                          .format(cart[i].price)
                                          .toString(),
                                      style: AppStyles.cartPriceStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //qty
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              width: 120,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 9, horizontal: 6),
                                      decoration: const BoxDecoration(
                                        color: AppColors.black,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            decQty(cart[i]);
                                            getGrandTotal();
                                          });
                                        },
                                        child: const Icon(
                                          Icons.remove,
                                          size: 16,
                                          color: AppColors.lightGrey,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      cart[i].qty.toString(),
                                      style: AppStyles.cartQtyStyle,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 9, horizontal: 6),
                                      decoration: const BoxDecoration(
                                        color: AppColors.black,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            incQty(cart[i]);
                                            getGrandTotal();
                                          });
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          size: 16,
                                          color: AppColors.lightGrey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        AppStyles.deciPriceFormat
                                            .format(cart[i].price * cart[i].qty)
                                            .toString(),
                                        style: AppStyles.cartTotalPriceStyle,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              removeProduct(cart[i]);
                                              getGrandTotal();
                                            });
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            size: 18,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Grand Total",
                      style: AppStyles.grandTotalLabelStyle,
                    ),
                    Text(
                      "${AppStyles.deciPriceFormat.format(cartGrandTotal)} Baht",
                      style: AppStyles.grandTotalStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } //ef
} //ec

//====> class: AllProductScreen
class AllProductScreen extends StatefulWidget {
  AllProductScreen();

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          //headings
          const Text(
            "Products",
            style: AppStyles.mainHeadingStyle,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2, bottom: 10),
            child: Text(
              "The only place where cozy fashions found",
              style: AppStyles.subHeadingStyle,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: GridView.builder(
                //section to define column number, x andy spacing
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0, //x spacing
                  mainAxisSpacing: 15.0, //y spacing
                ),
                itemCount: products.length,
                itemBuilder: (context, i) {
                  //put your item rendering here
                  return GestureDetector(
                    onTap: () {
                      //move to new creen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            product: products[i],
                            tag: '${products[i].id} all',
                          ),
                        ),
                      );
                    },
                    child: ProductCard(
                      product: products[i],
                      tag: '${products[i].id} all',
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//====> class: CategoriesScreen
class CategoriesScreen extends StatefulWidget {
  CategoriesScreen();

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    //get categories
    getProductCategories();

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          //headings
          const Text(
            "Categories",
            style: AppStyles.mainHeadingStyle,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2, bottom: 10),
            child: Text(
              "The only place where cozy fashions found",
              style: AppStyles.subHeadingStyle,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: GridView.builder(
                //section to define column number, x andy spacing
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0, //x spacing
                  mainAxisSpacing: 15.0, //y spacing
                ),
                itemCount: productCatergories.length,
                itemBuilder: (context, i) {
                  //put your item rendering here
                  return Text(
                    productCatergories[i],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  } //ef

  void getProductCategories() {
    productCatergories.clear();
    for (var p in products) {
      if (!productCatergories.contains(p.category)) {
        productCatergories.add(p.category);
      }
    }
  }
} //ec
