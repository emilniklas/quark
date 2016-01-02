library quark.contexts.html;

import 'dart:async';
import 'dart:html';
import '../integration.dart';

typedef /*void | Future*/ HtmlContextNavigator(String page);

abstract class HtmlContext {
  static HtmlContextNavigator navigator;

  @Then(r'I(?: (?:should|expect to|will|can))? (?:see|read) \"(.*)\"(?: on the (?:screen|page))?')
  void expectTextOnPage(String text) {
    expect(
        querySelector('html').text,
        contains(text),
        reason: '"$text" could not be found on the page!'
    );
  }

  static const _visitPattern = r'I (?:visit|go to|navigate to)(?: url| page)? \"(.*)\"';
  @Given(_visitPattern)
  @When(_visitPattern)
  Future visit(String path) async {
    if (navigator == null)
      fail('Implement HtmlContext#navigator to enable routing support');
    await navigator(path);
  }
}
