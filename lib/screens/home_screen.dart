import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spawos_shopx/constants/constants.dart';
import 'package:spawos_shopx/provider/home_screen_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<HomeProvider>(context, listen: false).getProductData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQueryData = MediaQuery.of(context);
    double width = _mediaQueryData.size.width;
    double height = _mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.green,
            statusBarBrightness: Brightness.light),
        elevation: 0,
        title: Text('ShopX',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: kBlackColor,
            )),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return value.isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : value.error == true
                  ? Center(child: Text(value.message))
                  : value.productModel.isEmpty && value.error == false
                      ? const Center(child: Text('No Data Available..'))
                      : RefreshIndicator(
                          onRefresh:()=>value.getProductData(),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding:EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 6.w,
                                    mainAxisSpacing: 6.h,
                                    childAspectRatio: 3 / 4.5),
                            itemCount: value.productModel.length,
                            itemBuilder: (context, i) {
                              return Container(
                                padding:EdgeInsets.symmetric(
                                    vertical: 10.w, horizontal: 10.h),
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: kBorderColor, width: 1),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: LayoutBuilder(
                                  builder: (_, constraints) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            CachedNetworkImage(
                                              width: width * 0.32,
                                              height: width * 0.32,
                                              imageUrl:
                                                  value.productModel[i].imageLink,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                color: Colors.green,
                                              )),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 10.h,
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(2.h),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(100),
                                                ),
                                                width: 28.w,
                                                height: 28.w,
                                                child: Icon(
                                                    CupertinoIcons.heart,
                                                    color: Colors.blue,
                                                    size: 24.w),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        AutoSizeText(value.productModel[i].name,
                                            style: kTitleStyle, maxLines: 2),
                                        SizedBox(height: 6.h),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                padding:
                                                     EdgeInsets.symmetric(
                                                        horizontal: 5.w),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10.r),
                                                ),
                                                height: 20.h,
                                                width: 54.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                        child: Text(
                                                      value.productModel[i]
                                                          .rating
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                    Flexible(
                                                        child: Icon(
                                                      Icons.star,
                                                      color:
                                                          CupertinoColors.white,
                                                      size: 16.w,
                                                    ))
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height:6.h),
                                              AutoSizeText(
                                                '\$${value.productModel[i].price}',
                                                style:const TextStyle(
                                                  color: CupertinoColors.black,
                                                  fontWeight:FontWeight.w300,
                                                    ),
                                                minFontSize:22.sp,
                                                maxFontSize: 26.sp,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                      );
        },
      ),
    );
  }
}
