@TestOn('vm')

library test.gherkin.external_feature.io;

import 'package:quark/integration.dart';
import 'external_feature.dart';
export 'package:quark/init.dart';
export 'package:quark/vm.dart';

@Feature('external.feature')
class ExternalFeatureIoTest = IntegrationTest with ExternalFeatureImplementation;
