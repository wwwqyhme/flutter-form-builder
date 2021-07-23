import 'package:flutter/material.dart';
import 'package:forme/forme.dart';
import 'base_page.dart';

class AsyncAutocompleteChip extends BasePage<List<AppProfile>,
    FormeAsyncAutocompleteChipModel<AppProfile>> {
  @override
  Widget get body {
    const mockResults = <AppProfile>[
      AppProfile('John Doe', 'jdoe@flutter.io',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201712%2F15%2F20171215221023_KiYWM.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534190&t=61b1e38740fad243832f475b5c9c1eee'),
      AppProfile('Paul', 'paul@google.com',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201905%2F28%2F20190528143150_fETNW.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534191&t=4e06a4bb62eb5df86cf71dd44bccdf85'),
      AppProfile('Fred', 'fred@google.com',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2F878a6c57bed136d9d176a6eb8289a04787b126bf.jpg&refer=http%3A%2F%2Fi0.hdslb.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534191&t=de222dd1577d54ea611ab3c2501327f3'),
      AppProfile('Brian', 'brian@flutter.io',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic4.zhimg.com%2F50%2Fv2-3d259dde90d4f5dd09fb8b2a8589df1f_hd.jpg&refer=http%3A%2F%2Fpic4.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534191&t=83d8b627ddfa4032330dcf57a630d6df'),
      AppProfile('John', 'john@flutter.io',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201812%2F7%2F2018127203650_KvXLM.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534191&t=9d6d7bed74aa7169a11c9c0f5c732ab3'),
      AppProfile('Thomas', 'thomas@flutter.io',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic3.zhimg.com%2Fv2-46a8e6a6f8419bc8bf02dcec85d991d2_b.jpg&refer=http%3A%2F%2Fpic3.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534191&t=f8c6d4284324e767e7904cd616aa1d2b'),
      AppProfile('Nelly', 'nelly@flutter.io',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic4.zhimg.com%2F50%2Fv2-095b2db945e2d3e0644ccbb26eab8ed8_hd.jpg&refer=http%3A%2F%2Fpic4.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534191&t=7c5219a60ed5a9f68ee29c03526a0bc6'),
      AppProfile('Marie', 'marie@flutter.io',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fdp.gtimg.cn%2Fdiscuzpic%2F0%2Fdiscuz_x5_gamebbs_qq_com_forum_201306_19_1256219xc797y90heepdbh.jpg%2F0&refer=http%3A%2F%2Fdp.gtimg.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534577&t=e9fe368a05adc0276b73ed4c3dc0cb05'),
      AppProfile('Charlie', 'charlie@flutter.io',
          'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1441836571,2166773131&fm=26&gp=0.jpg'),
      AppProfile('Diana', 'diana@flutter.io',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201901%2F04%2F20190104222555_Rvvyu.thumb.700_0.jpeg&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534577&t=94ca838c1857be312baf908bb4fe4e7c'),
      AppProfile('Ernie', 'ernie@flutter.io',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0119d95c482e8fa801213f26847b0f.jpg%402o.jpg&refer=http%3A%2F%2Fimg.zcool.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534577&t=b4294e94d5921f8a43b0bb170bbd30c4'),
      AppProfile('Gina', 'fred@flutter.io',
          'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201312%2F20%2F20131220165207_kjkFt.thumb.700_0.gif&refer=http%3A%2F%2Fimg5.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1626534577&t=47c047705eebac10c91c5ab62bcb6540'),
    ];
    return Column(
      children: [
        FormeAsnycAutocompleteChip<AppProfile>(
          optionsBuilder: (v) {
            if (v.text == '') {
              return Future.delayed(Duration.zero, () {
                return Iterable.empty();
              });
            }
            return Future.delayed(Duration(milliseconds: 800), () {
              return mockResults;
            });
          },
          decoration: InputDecoration(
              labelText: 'Async Autocomplete Chip',
              suffixIcon: IconButton(
                onPressed: () {
                  (controller as FormeAsyncAutocompleteChipController)
                      .textEditingController
                      .text = '';
                },
                icon: Icon(Icons.clear),
              )),
          model: FormeAsyncAutocompleteChipModel<AppProfile>(
            max: 2,
            exceedCallback: () {
              print('max is 2');
            },
            optionBuilder: (context, profile, isSelected) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(profile.imageUrl),
                  ),
                  enabled: !isSelected,
                  title: Text(profile.name),
                  subtitle: Text(profile.email),
                ),
              );
            },
            chipBuilder: (context, AppProfile profile, VoidCallback onDeleted) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: InputChip(
                  key: ObjectKey(profile),
                  label: Text(profile.name),
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(profile.imageUrl),
                  ),
                  onDeleted: onDeleted,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            },
            emptyOptionBuilder: (context) {
              return Text('no options found');
            },
          ),
          name: name,
          listener: FormeValueFieldListener(
            onValidate: FormeValidates.notEmpty(errorText: 'pls select one!'),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 250),
          child: Wrap(
            children: [
              createButton('update display', () {
                controller.updateModel(FormeAsyncAutocompleteChipModel(
                    displayStringForOption: (u) => u.name));
              }),
              createButton('update optionsView height', () {
                controller.updateModel(
                    FormeAsyncAutocompleteChipModel(optionsViewHeight: 300));
              }),
              createButton('update optionsView builder', () {
                controller.updateModel(FormeAsyncAutocompleteChipModel(
                  loadingOptionBuilder: (context) => Text('loading...'),
                  emptyOptionBuilder: (contex) => Text('empty ...'),
                  optionsViewDecoratorBuilder:
                      (context, child, width, closeOptionsView) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: SizedBox(
                          child: child,
                          width: width,
                        ),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, users) {
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final AppProfile profile = users.elementAt(index);
                          return InkWell(
                            onTap: () {
                              onSelected(profile);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(profile.imageUrl),
                                ),
                                title: Text(profile.name),
                                subtitle: Text(profile.email),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ));
              }),
              createButton('reset', () {
                controller.reset();
              }),
              createButton('validate', () {
                controller.validate();
              }),
            ],
          ),
        )
      ],
    );
  }

  @override
  String get title => 'FormeAutocompleteChip';
}

@immutable
class AppProfile {
  final String name;
  final String email;
  final String imageUrl;

  const AppProfile(this.name, this.email, this.imageUrl);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppProfile &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
