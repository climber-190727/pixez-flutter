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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixez/lighting/lighting_page.dart';
import 'package:pixez/network/api_client.dart';

class RankModePage extends StatefulWidget {
  final String mode, date;

  const RankModePage({Key key, this.mode, this.date}) : super(key: key);

  @override
  _RankModePageState createState() => _RankModePageState();
}

class _RankModePageState extends State<RankModePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LightingList(
      source: () => RepositoryProvider.of<ApiClient>(context).getIllustRanking(
        widget.mode,
        widget.date,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
