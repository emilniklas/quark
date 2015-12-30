library quark.contexts.html;

import 'dart:html';
import '../integration.dart';

abstract class HtmlContext {
  @Then(r'I(?: (?:should|expect to|will|can))? (?:see|read) \"(.*)\"(?: on the (?:screen|page))?')
  expectTextOnPage(String text) {
    expect(
        querySelector('html').text,
        contains(text),
        reason: '"$text" could not be found on the page!'
    );
  }
}
