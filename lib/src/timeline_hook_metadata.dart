library quark.src.timeline_hook_metadata;

abstract class TimelineHookMetadata {
  const TimelineHookMetadata();
}

class BeforeMetadata extends TimelineHookMetadata {
  const BeforeMetadata();
}

class BeforeAllMetadata extends TimelineHookMetadata {
  const BeforeAllMetadata();
}

class AfterMetadata extends TimelineHookMetadata {
  const AfterMetadata();
}

class AfterAllMetadata extends TimelineHookMetadata {
  const AfterAllMetadata();
}

const before = const BeforeMetadata();
const beforeAll = const BeforeAllMetadata();
const after = const AfterMetadata();
const afterAll = const AfterAllMetadata();
