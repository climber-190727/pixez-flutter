/*
 * Copyright (C) 2020. by perol_notsf, All rights reserved
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pixez/component/pixiv_image.dart';
import 'package:pixez/generated/l10n.dart';
import 'package:pixez/main.dart';
import 'package:pixez/models/illust.dart';

class PhotoViewerPage extends StatefulWidget {
  final int index;
  final Illusts illusts;

  const PhotoViewerPage({Key key, this.index, this.illusts}) : super(key: key);

  @override
  _PhotoViewerPageState createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  var index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.index;
  }

  Widget _buildPager() => PageView(
        pageSnapping: false,
        onPageChanged: (index) {
          setState(() {
            this.index = index;
          });
        },
        controller: PageController(initialPage: widget.index),
        children: widget.illusts.metaPages
            .map((f) => PhotoView(
                imageProvider: PixivProvider.url(userSetting.zoomQuality == 0
                    ? f.imageUrls.large
                    : f.imageUrls.original)))
            .toList(),
      );

  Widget _buildMuti() => InkWell(
        onLongPress: () async {
          String result = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(I18n.of(context).Save),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop('OK');
                        },
                        child: Text('OK')),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop('CANCEL');
                        },
                        child: Text('CANCEL')),
                  ],
                );
              });
          if (result != null) {
            if (result == 'OK') {
              saveStore.saveImage(widget.illusts, index: index);
            }
          }
        },
        child: PhotoViewGallery.builder(
            onPageChanged: (i) {
              setState(() {
                this.index = i;
              });
            },
            pageController: PageController(initialPage: widget.index),
            itemCount: widget.illusts.metaPages.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: PixivProvider.url(
                    widget.illusts.metaPages[index].imageUrls.large),
                initialScale: PhotoViewComputedScale.contained * 1,
                heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.illusts.metaPages[index].imageUrls.large),
              );
            }),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            "${index + 1}/${widget.illusts.pageCount}",
            style: TextStyle(color: Colors.white),
          ),
        ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: widget.illusts.pageCount == 1
            ? InkWell(
                onLongPress: () async {
                  String result = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(I18n.of(context).Save),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop('OK');
                                },
                                child: Text('OK')),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop('CANCEL');
                                },
                                child: Text('CANCEL')),
                          ],
                        );
                      });
                  if (result != null) {
                    if (result == 'OK') {
                      saveStore.saveImage(widget.illusts);
                    }
                  }
                },
                child: PhotoView(
                  imageProvider: PixivProvider.url(userSetting.zoomQuality == 0
                      ? widget.illusts.imageUrls.large
                      : widget.illusts.metaSinglePage.originalImageUrl),
                ),
              )
            : _buildMuti());
  }
}
