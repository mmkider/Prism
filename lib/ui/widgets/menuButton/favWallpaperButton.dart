import 'package:Prism/analytics/analytics_service.dart';
import 'package:Prism/data/favourites/provider/favouriteProvider.dart';
import 'package:Prism/data/pexels/model/wallpaperp.dart';
import 'package:Prism/data/wallhaven/model/wallpaper.dart';
import 'package:Prism/theme/jam_icons_icons.dart';
import 'package:Prism/ui/widgets/popup/signInPopUp.dart';
import 'package:flutter/material.dart';
import 'package:Prism/main.dart' as main;
import 'package:provider/provider.dart';

class FavouriteWallpaperButton extends StatefulWidget {
  final String id;
  final String provider;
  final WallPaper wallhaven;
  final WallPaperP pexels;
  final Map prism;
  final bool trash;
  const FavouriteWallpaperButton({
    @required this.id,
    @required this.provider,
    @required this.trash,
    this.wallhaven,
    this.pexels,
    this.prism,
    Key key,
  }) : super(key: key);

  @override
  _FavouriteWallpaperButtonState createState() =>
      _FavouriteWallpaperButtonState();
}

class _FavouriteWallpaperButtonState extends State<FavouriteWallpaperButton> {
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!main.prefs.get("isLoggedin")) {
          googleSignInPopUp(context, () {
            onFav(widget.id, widget.provider, widget.wallhaven, widget.pexels,
                widget.prism);
          });
        } else {
          onFav(widget.id, widget.provider, widget.wallhaven, widget.pexels,
              widget.prism);
        }
        // if (widget.provider == "Liked") {
        //   String route = currentRoute;
        // currentRoute = previousRoute;
        // previousRoute = route;
        // print(currentRoute);
        // Navigator.pop(context);
        // }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.25),
                    blurRadius: 4,
                    offset: Offset(0, 4))
              ],
              borderRadius: BorderRadius.circular(500),
            ),
            padding: EdgeInsets.all(17),
            child: Icon(
              widget.trash ? JamIcons.trash : JamIcons.heart,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              height: 63,
              width: 63,
              child: isLoading ? CircularProgressIndicator() : Container())
        ],
      ),
    );
  }

  void onFav(String id, String provider, WallPaper wallhaven, WallPaperP pexels,
      Map prism) async {
    setState(() {
      isLoading = true;
    });
    Provider.of<FavouriteProvider>(context, listen: false)
        .favCheck(id, provider, wallhaven, pexels, prism)
        .then((value) {
      analytics.logEvent(
          name: 'fav_status_changed',
          parameters: {'id': id, 'provider': provider});
      setState(() {
        isLoading = false;
      });
    });
  }
}
