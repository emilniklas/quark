@TestOn('browser')

library test.gherkin.external_feature.html;

import 'package:quark/integration.dart';
import 'external_feature.dart';
export 'package:quark/init.dart';
export 'package:quark/browser.dart';

@Feature('external.feature')
class ExternalFeatureHtmlTest = IntegrationTest with ExternalFeatureImplementation;
