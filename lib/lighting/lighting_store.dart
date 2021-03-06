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

import 'package:dio/dio.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mobx/mobx.dart';
import 'package:pixez/models/illust.dart';
import 'package:pixez/models/recommend.dart';
import 'package:pixez/network/api_client.dart';

part 'lighting_store.g.dart';

class LightingStore = _LightingStoreBase with _$LightingStore;
typedef Future<Response> FutureGet();

abstract class _LightingStoreBase with Store {
  final ApiClient _apiClient;
  final EasyRefreshController _controller;
  FutureGet source;

  String nextUrl;
  @observable
  ObservableList<Illusts> illusts = ObservableList();

  @observable
  String errorMessage;
  _LightingStoreBase(
    this.source,
    this._apiClient,
    this._controller,
  ) {}

  @action
  fetch() async {
    nextUrl = null;
    errorMessage = null;
    try {
      final result = await source();
      Recommend recommend = Recommend.fromJson(result.data);
      nextUrl = recommend.nextUrl;
      illusts.clear();
      illusts.addAll(recommend.illusts);
      _controller.finishRefresh(success: true);
    } catch (e) {
      errorMessage = e.toString();
      _controller.finishRefresh(success: false);
    }
  }

  @action
  fetchNext() async {
    errorMessage = null;
    try {
      if (nextUrl != null && nextUrl.isNotEmpty) {
        Response result = await _apiClient.getNext(nextUrl);
        Recommend recommend = Recommend.fromJson(result.data);
        nextUrl = recommend.nextUrl;
        illusts.addAll(recommend.illusts);
        _controller.finishLoad(success: true, noMore: false);
      } else {
        _controller.finishLoad(success: true, noMore: true);
      }
    } catch (e) {
      _controller.finishLoad(success: false);
    }
  }
}
